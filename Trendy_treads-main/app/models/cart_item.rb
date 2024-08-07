class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :cart_id, presence: true
  validates :product_id, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }

  def self.ransackable_attributes(auth_object = nil)
    %w[cart_id created_at id product_id quantity updated_at]
  end
end

