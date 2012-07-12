require 'strip_accent'
class Ad < ActiveRecord::Base
  belongs_to :user
  belongs_to :section
  belongs_to :final_evaluation
  has_many :favorites
  has_many :ad_tags
  has_many :users, :through => :favorites
  has_many :evaluations
  has_many :raters, :through => :evaluations, :source => :users
  has_many :comments, :dependent => :destroy
  has_many :resources, :dependent => :destroy
  # TODO reject empty
  accepts_nested_attributes_for :resources, :reject_if => lambda { |r| not r[:link] }, :allow_destroy => true

  validates_presence_of :title
  
  # tags saving process
  attr_writer :tag_names
  after_save :assign_tags
  
  # thumbnail choose and cropping process 
  has_attached_file :thumbnail, :styles => { :thumb => "140x180", :medium => "200x200" }, :processors => [:cropper]
  validates_attachment_size :thumbnail, :less_than => 512.kilobytes
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :reprocess_avatar, :if => :cropping?
  
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end
  
  def thumb_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(thumbnail.path(style))
  end
  
  scope :all_opened, where(:closed => false)
  scope :distinct, select("DISTINCT ads.id, ads.*")

  @@OPTIONS = {:opened => 0, :closed => 1, :locked => 2}
  
  @@RELEVANCE_TIME_OFFSET = 1.weeks.to_i
  @@RELEVANCE_USER_SCALE = 1000

  cattr_accessor :RELEVANCE_TIME_OFFSET
  cattr_accessor :RELEVANCE_USER_SCALE

  class CannotOpenAdError < RuntimeError; end
  class AdNotClosedError < RuntimeError; end
  class EvalUserNotDefinedError < RuntimeError; end
  class UserAlreadyDefinedError < RuntimeError; end
  class UnauthorizedUserException < RuntimeError; end
  class EvalAlreadyDoneError < RuntimeError; end

  self.per_page = 10 
  
  def self.most_relevant(count, user_id)
    return nil if count.nil? || count < 0
    return [] if count == 0
    order_by_relevance(all_opened, user_id).first(count)
  end
  
  def self.search_text(text, page, user_id)
    query = order_by_relevance(all_opened.distinct, user_id)
    return query.paginate(:page => page) if text.nil? || text.empty?
    return nil if page.nil? || page < 1

    keywords = text.split
    queries = []
    vars = []
    keywords.each do |keyword|
      queries << "(ads.title LIKE ? OR
		   ads.title LIKE ? OR
		   ad_tags.tag LIKE ? OR
		   ad_tags.tag LIKE ?)"
      vars = vars << keyword+'%' << '% '+keyword+'%' << keyword+'%' << '% '+keyword+'%'
    end
    
    conditions = [queries.join(' OR '), vars].flatten

    query = query.joins("LEFT OUTER JOIN ad_tags ON ad_tags.ad_id = ads.id")
    query = query.where(conditions)

    return query.paginate(:page => page)
  end
  
  def self.search_text_by_section(section_id, text, page, user_id)
    query = order_by_relevance(Section.find(section_id).ads.all_opened.distinct, user_id)
    return query.paginate(:page => page) if text.nil? || text.empty?
    
    keywords = text.split
    queries = []
    vars = []
    keywords.each do |keyword|
      queries << "(ads.title LIKE ? OR
                   ads.title LIKE ? OR
                   ad_tags.tag LIKE ? OR
                   ad_tags.tag LIKE ?)"
      vars = vars << keyword+'%' << '% '+keyword+'%' << keyword+'%' << '% '+keyword+'%'
    end

    conditions = [queries.join(' OR '), vars].flatten

    query = query.joins("LEFT OUTER JOIN ad_tags ON ad_tags.ad_id = ads.id")
    query = query.where(conditions)

    return query.paginate(:page => page)
  end

  def self.order_by_relevance(rel, user_id)
    if !user_id then return rel.order("strftime(\"%s\", ads.created_at) + ads.relevance_factor * #{ @@RELEVANCE_TIME_OFFSET } DESC") end
    
    rel2 = rel.joins("LEFT OUTER JOIN (SELECT favorites.ad_id FROM favorites WHERE favorites.user_id = #{user_id}) favorites ON ads.id = favorites.ad_id")
    rel2.order("favorites.ad_id DESC, strftime(\"%s\", ads.created_at) + ads.relevance_factor * #{ @@RELEVANCE_TIME_OFFSET } DESC")
  end
  
  def open?
    self.closed == @@OPTIONS[:opened]
  end
  
  def locked?
    self.closed == @@OPTIONS[:locked]
  end
  
  def close!
    self.closed = @@OPTIONS[:closed]
    self.save
  end
  
  def open!
    raise CannotOpenAdError unless not self.locked?    
    self.closed = @@OPTIONS[:opened]
    self.save
  end
  
  def close_permanently!
    self.closed = @@OPTIONS[:locked]
    self.save
  end
  
  def favorite?(user_id)
    not self.users.where("user_id = ?", user_id).empty?
  end
  
  def mark_favorite!(user_id)
    fav = Favorite.new :user_id => user_id, :ad_id => self.id
    fav.save
  end
  
  def unmark_favorite!(user_id)
    fav = Favorite.find_by_user_id_and_ad_id(user_id, self.id)
    fav.destroy
  end
  
  def rate!(user_id, value)
    raise ArgumentError unless (value != nil && value > 0 && value < 6)
  
    evaluation = Evaluation.find_or_create_by_user_id_and_ad_id :user_id => user_id, :ad_id => self.id
    if evaluation.value != nil
      @size = self.evaluations.size
      @cur_value = @size * self.average_rate - evaluation.value + value
      self.average_rate = @cur_value / @size
    else
      self.average_rate = self.calc_average_rating(user_id,value)
    end
    evaluation.value = value
    evaluation.save

    self.relevance_factor = self.calc_relevance
    self.save
  end
  
  def calc_average_rating(user_id,value)
     @total = self.evaluations.size
     if not self.average_rate
       value
     else
       @old_average = self.average_rate * (@total - 1)
       (value + @old_average) / @total
     end
  end
  
  def user_rating(user_id)
    evaluation = Evaluation.find_by_user_id_and_ad_id(user_id, self.id)
    evaluation.value unless not evaluation
  end
  
  def final_eval_user_id
    self.final_evaluation.user_id unless not self.final_evaluation
  end
  
  def final_eval
    self.final_evaluation.value unless not self.final_evaluation
  end
  
  def set_final_eval_user!(user_id)
    raise AdNotClosedError if self.open?
    raise UserAlreadyDefinedError unless not self.final_evaluation
  
    final_eval = FinalEvaluation.new :user_id => user_id
    final_eval.save
    self.final_evaluation = final_eval
    self.save
  end
  
  def do_final_eval!(user_id, value)
    raise EvalUserNotDefinedError unless (self.final_evaluation && self.final_evaluation.user_id)
    raise EvalAlreadyDoneError unless not self.final_evaluation.complete?
    raise UnauthorizedUserException unless self.final_evaluation.user_id == user_id
    
    self.final_evaluation.value = value
    self.final_evaluation.save
    
    self.user.calc_average_rating!(value)

    self.relevance_factor = self.calc_relevance
    self.save
  end
  
  def relevance
    self.created_at.to_i + self.relevance_factor * @@RELEVANCE_TIME_OFFSET
  end
  
  def calc_average_rating!(user_id, value)
    total = self.evaluations.size
    if self.average_rate == nil
      self.average_rate = value
      self.save
    else
      old_average = self.average_rate * (total - 1)
      self.average_rate = (value + old_average) / total
      self.save     
    end
  end
  
  def gallery
    self.resources.where('resources.link_content_type LIKE ?', 'image/%')
  end

  # calculates and returns a relevance factor in the range [-1.0, 1.0]
  def calc_relevance
    ad_rate_count = self.evaluations.count
    user_rate_count = self.user.rate_count
    total_rates = ad_rate_count + user_rate_count
    return 0.0 if total_rates == 0

    ad_rate = self.average_rate
    ad_rate ||= 0
    user_rate = self.user.rate
    user_rate ||= 0
    # puts "Relevance params: N(Ar)=#{ad_rate_count}; N(Ur)=#{user_rate_count}; avg(Ar)=#{ad_rate}; avg(Ur)=#{user_rate}"

    ad_rate_factor = [ad_rate_count / @@RELEVANCE_USER_SCALE.to_f, 1.0].min * (ad_rate - 3.0) / 2.0
    user_rate_factor = [user_rate_count / @@RELEVANCE_USER_SCALE.to_f, 1.0].min * (user_rate - 3.0) / 2.0
    return (ad_rate_factor * ad_rate_count + user_rate_factor * user_rate_count) / total_rates
  end

  # tagging system
  def tag_names
    @tag_names || ad_tags.map(&:tag).join(', ')
  end
  
  #business partner
  def partner
    if not final_eval_user_id.nil?
      User.find(final_eval_user_id)
    end
  end
  
  def partner=(user_name)
    user = User.find_by_username(user_name)
    if user
      set_final_eval_user! user.id
    end
  end
  
  def short_title 
    return title unless title.length > 19
    return title[0..15] + "..." 
  end
  
  def owner_rated?
    
  end
  
  private

  def assign_tags
    if @tag_names
      self.ad_tags = @tag_names.split(/,+\s+|,+/).map do |name|
        AdTag.find_or_create_by_ad_id_and_tag(self.id, name)
      end
    end
  end

  # cropping the avatar
  def reprocess_avatar
    thumbnail.reprocess!
  end
    
end
