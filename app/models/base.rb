class Base < ApplicationRecord
  scope :recent, -> (count){order(id: :desc)}

  validates :base_number, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  validates :name, presence: true,length:{maximum: 20}, uniqueness: true

  validates :bases_status, presence: true
end
