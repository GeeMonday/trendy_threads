class Province < ApplicationRecord
  has_many :addresses
  has_many :orders
  has_many :tax_rates
  has_one :tax_rate, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true

  # Define the ransackable attributes for the Province model
  def self.ransackable_attributes(auth_object = nil)
    %w[code created_at gst_rate hst_rate id name pst_rate updated_at]
  end

  # If you want to allow certain associations to be searchable, you can define the ransackable associations as well
  def self.ransackable_associations(auth_object = nil)
    %w[orders]
  end
end
