class Attendance < ApplicationRecord
    belongs_to :user
  
  validates :worked_on, presence: true
  validates :note, length: {maximum: 50}
  
  def self.search(search1,search2)
    if search1 && search2
      where(['worked_on LIKE ? AND worked_on LIKE ?',"%#{search1}%","%#{search2}%"])
      binding.pry
    else
      all
    end
  end
end 
