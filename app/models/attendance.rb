class Attendance < ApplicationRecord
    belongs_to :user
  
  validates :worked_on, presence: true
  validates :note, length: {maximum: 50}
  
  def self.search(search1,search2)
    if search1 && search2
      where(['worked_on',"#{search1}"])
      where(['worked_on.month'"#{search2}"])
    else
      all
    end
  end
end 
