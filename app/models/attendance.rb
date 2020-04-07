class Attendance < ApplicationRecord
    belongs_to :user
  
  validates :worked_on, presence: true
  validates :note, length: {maximum: 50}
  
  def self.search(year,month)
  binding.pry
      Attendance.where(worked_on: month.in_time_zone.all_month)
  
  end
end 
