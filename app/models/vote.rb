class Vote < ActiveRecord::Base
  attr_accessible :value
  belongs_to :user
  belongs_to :post
  
  validates :user_id, presence: true
  validates :value, presence: true, :numericality => {:greater_than => -4, :less_than => 4}
  
end
