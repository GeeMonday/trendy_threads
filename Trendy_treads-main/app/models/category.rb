class Category < ApplicationRecord
  has_many :product_categories
  has_many :products, through: :product_categories
  has_and_belongs_to_many :products, dependent: :destroy

  validates :name, presence: true

  def self.ransackable_associations(auth_object = nil)
    %w[product_categories products]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id name created_at updated_at]
  end
end
