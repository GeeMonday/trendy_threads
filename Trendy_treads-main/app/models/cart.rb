class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  validates :user_id, presence: true

  # Add a product to the cart
  def add_product(product, quantity)
    cart_item = cart_items.find_by(product_id: product.id)

    if cart_item
      # Update the quantity if the product is already in the cart
      cart_item.update(quantity: cart_item.quantity + quantity)
    else
      # Create a new cart item if the product is not in the cart
      cart_items.create(product: product, quantity: quantity)
    end
  end

  # Calculate the total price of the items in the cart
  def total_price
    cart_items.joins(:product).sum('cart_items.quantity * products.price')
  end
  
  def calculate_total
    cart_items.sum do |item|
      (item.product.sale_price || item.product.price) * item.quantity
    end
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user cart_items products]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id user_id created_at updated_at]
  end
end
