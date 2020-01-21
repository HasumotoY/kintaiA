class Attendance < ApplicationRecord
    belongs_to :user
  
  validates :worked_on, presence: true
  validates :note, length: {maximum: 50}
  
  def self_search(search)
    if search_work_log
      where([worked_on, "#%{search_work_log}%"])
    else
      all
    end
  end
end
