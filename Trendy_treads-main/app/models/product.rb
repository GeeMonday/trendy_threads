class Product < ApplicationRecord
  has_many :product_categories
  has_many :categories, through: :product_categories
  has_many :cart_items
  has_many :order_items
  has_and_belongs_to_many :categories
  has_many :carts, through: :cart_items
  has_one_attached :image

  validates :name, presence: true
  validates :description, presence: true
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0.01, less_than_or_equal_to: 10000 }
  validates :sale_price, numericality: { greater_than_or_equal_to: 0.01, less_than_or_equal_to: 10000 }, allow_nil: true

  # Scope to filter products on sale
  scope :on_sale, -> { where(on_sale: true) }

  # Ensure sale_price is used only if on_sale is true
  def effective_price
    on_sale ? sale_price : price
  end

  def image_url_or_default
    image.attached? ? url_for(image) : 'default_image.png'
  end

  def self.ransackable_associations(auth_object = nil)
    %w[categories cart_items carts]
  end

  def self.ransackable_attributes(auth_object = nil)
    super + ['sale_price']
  end
end
