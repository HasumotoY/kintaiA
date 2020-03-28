class Attendance < ApplicationRecord
    belongs_to :user
  
  validates :worked_on, presence: true
  validates :note, length: {maximum: 50}
  
    def self.search(search)
      if search
        Attendance.where('worked_on LIKE(?)',"%#{search}%")
      else
        all
      end    
    end
end 
