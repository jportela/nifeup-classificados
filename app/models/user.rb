class User < ActiveRecord::Base
  has_many :block_log
  has_many :ads
  has_many :favorites
  has_many :favorite_ads, :through => :favorites, :source => :ad
  has_many :evaluations
  has_many :rated_ads, :through => :evaluations, :source => :ads
  
  self.per_page = 20 
  
  @@BLOCK_DURATION = {:week => 7, :twoweeks => 15, :month => 30}
  
  def self.block_durations
    @@BLOCK_DURATION
  end
  
  def self.epinto
    user = User.new :username => 'epinto'
    user.id = 1
    user
  end
  
  def email
    self.username + "@fe.up.pt"
  end
  
  def self.search_for_uname uname
    if key
      find(:all, :conditions => ['login LIKE ?', "%#{uname}%"])
    else
      find(:all)
    end
  end
  
  def self.search_text(text, page)
    return User.paginate(:page => page) if text.nil? || text.empty?
    
    query = User.search(:username_contains_any => text.split)
    return query.paginate(:page => page)
  end

  def make_admin!
    self.admin = true
    self.save
  end
  
  def make_regular!
    self.admin = false
    self.save
  end
  
  def calc_average_rating!(value)
    if self.rate.nil?
      self.rate = value
    else
      num_rates = self.rate_count
      old_rate = self.rate * (num_rates - 1)
      self.rate = (value + old_rate) / num_rates
    end
    self.save
  end
  
  def rate_count
    self.ads.joins('JOIN final_evaluations ON ads.final_evaluation_id = final_evaluations.id').size
  end
  
  def self.block!(user_id, duration_days)
    until_date = duration_days.to_i.days.from_now
    user = User.find(user_id)
    if user
        user.blocked_until = until_date
        user.save
    else
        false
    end
  end
  
  def self.unblock!(user_id)
    user = User.find(user_id)
    if user
        user.blocked_until = nil
        user.save
    else
        false
    end
  end
end
