class Attendance < ApplicationRecord
    belongs_to :user
  
  validates :worked_on, presence: true
  validates :note, length: {maximum: 50}
  validates :change, presence: true
  
  validate :finished_at_is_invalid_without_a_started_at
  
  validate :finished_at_is_more_than_started_at
  
  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at,"が必要です。") if started_at.blank? && finished_at.present?  
  end
  
  def finished_at_is_more_than_started_at
    if started_at.present? && finished_at.present?
      errors.add(:started_at,"より早い時間は無効です。") if started_at > finished_at
    end
  end

end
