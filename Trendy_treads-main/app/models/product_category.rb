class ProductCategory < ApplicationRecord
    belongs_to :product
    belongs_to :category
  
    validates :product_id, presence: true
    validates :category_id, presence: true
  
    def self.ransackable_associations(auth_object = nil)
      %w[product category]
    end
  end
  