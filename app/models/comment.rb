class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :ad
  has_many :reports

  @@report_limit = 5

  class AlreadyReportedError < RuntimeError; end

  # get all reported comments
  def self.all_reported
    Comment.select('DISTINCT(comments.id), comments.*').joins(:reports).order('id DESC')
  end

  def self.set_report_limit(limit)
    @@report_limit = limit
  end

  # return true if the comment has been reported
  def reported?
    self.reports.size > 0 
  end

  # report a comment
  def report!(user_id, reason = nil)
    raise AlreadyReportedError unless not self.reports.find_by_user_id(user_id)
    rp = self.reports.new :user_id => user_id, :reason => reason
    rp.save
  end
  
  # return true if the comment has been reported more than @@report_limit
  def badly_reported?    
    self.reports.size >= @@report_limit
  end
  
  def user_reported?(user_id)
    true unless not self.reports.find_by_user_id(user_id)
  end
  
end
