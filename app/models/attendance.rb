class Attendance < ApplicationRecord
    belongs_to :user
  
  validates :worked_on, presence: true
  validates :note, length: {maximum: 50}
  
    def self.search(search)
      return Attendance.all unless search
      Attendance.where('worked_on LIKE(?)',"%#{search}%")
    end
end
