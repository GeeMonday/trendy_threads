# app/models/order.rb
class Order < ApplicationRecord
  enum status: { new_order: 0, paid: 1, shipped: 2 }
  belongs_to :user
  belongs_to :province # Ensure you have a belongs_to association with Province
  has_one :address, through: :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  accepts_nested_attributes_for :order_items, allow_destroy: true

    # Example regex for Canadian postal codes (e.g., A1A 1A1)
    POSTAL_CODE_REGEX = /\A[A-Za-z]\d[A-Za-z] \d[A-Za-z]\d\z/

    validates :address_postal_code, presence: true, format: { with: POSTAL_CODE_REGEX, message: 'must be in the format A1A 1A1' }
  

  validates :user, presence: true
  validates :status, presence: true
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :subtotal, :gst, :pst, :hst, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stripe_charge_id, presence: true, if: :paid?
  validates :address_street, :address_city, :province_id, presence: true

  validate :order_items_present
  validate :order_items_valid

  before_validation :set_defaults, on: :create
  before_save :calculate_total, if: :province_id_changed?

  def calculate_total
    self.subtotal = order_items.sum { |item| item.total_price }
    
    # Calculate taxes using the class method from TaxCalculator
    tax_details = TaxCalculator.calculate_total_price(subtotal, province.code)
    
    self.gst = tax_details[:gst]
    self.pst = tax_details[:pst]
    self.hst = tax_details[:hst]
    self.total_price = tax_details[:total_price]
  end

  def paid?
    self.status == 'Paid' # Adjust this condition as necessary for your application
  end

  private

  def set_defaults
    self.status ||= 'Pending'
    self.subtotal ||= 0
    self.gst ||= 0
    self.pst ||= 0
    self.hst ||= 0
    self.total_price ||= 0
  end

  def order_items_present
    errors.add(:order_items, "must have at least one item") if order_items.empty?
  end

  def order_items_valid
    order_items.each do |item|
      unless item.valid?
        errors.add(:order_items, "contains invalid items")
        break
      end
    end
  end

  def self.ransackable_associations(auth_object = nil)
    ["address", "order_items", "user", "province"]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id user_id created_at updated_at status total_price subtotal gst pst hst address_street address_city address_postal_code province_id]
  end
  
  ransacker :province_name do |parent|
    parent.table[:province_id]
  end
end
