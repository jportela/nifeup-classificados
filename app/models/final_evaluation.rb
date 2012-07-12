class FinalEvaluation < ActiveRecord::Base
  belongs_to :user
  has_one :ad
  
  def complete?
    self.value != nil
  end
end
