class Attendance < ApplicationRecord
    belongs_to :user
  
  validates :worked_on, presence: true
  validates :note, length: {maximum: 50}
  
  def self.search(year)
    if search
      Attendance.where(worked_on: year)
    else
      nil
    end
  end
  
  def self.search(month)
    if search
        Attendance.search(params[:work_year]).where(worked_on: month)
     else
        nil
    end    
  end
end 
