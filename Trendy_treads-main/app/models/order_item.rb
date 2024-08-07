class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  # Validation for quantity and price
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :product_price, presence: true, numericality: { greater_than: 0 }

  # Callback to set the product price before saving
  before_validation :set_product_price, on: :create

  # Calculate the total price for this order item
  def total_price
    product_price * quantity
  end

  private

  # Set the product price from the product's price or sale price
  def set_product_price
    if product.present?
      self.product_price = product.sale_price.present? ? product.sale_price : product.price
    else
      errors.add(:product, "must be present")
    end
  end
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "order_id", "price", "product_id", "product_price", "quantity", "sale_price", "updated_at"]
  end
end
