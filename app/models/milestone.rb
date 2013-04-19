class Milestone < ActiveRecord::Base
  attr_accessible :ends_at, :name, :starts_at
  has_many :tasks
  validates :name, presence: true
  validate :end_date_after_start_date

  def end_date_after_start_date
  	if starts_at >= ends_at
		errors.add(:ends_at, " must be after Started At.")
	end 
  end
end
