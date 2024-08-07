ActiveAdmin.register Order do
  index do
    selectable_column
    id_column
    column :user
    column 'Street', :address_street
    column 'City', :address_city
    column 'Postal Code', :address_postal_code
    column 'Province' do |order|
      order.province&.name
    end
    column :status
    column :subtotal
    column :gst
    column :pst
    column :hst
    column :total_price
    column 'Created At' do |order|
      order.created_at.in_time_zone('Eastern Time (US & Canada)').strftime('%B %d, %Y %H:%M')
    end
    column 'Updated At' do |order|
      order.updated_at.in_time_zone('Eastern Time (US & Canada)').strftime('%B %d, %Y %H:%M')
    end
    actions
  end

  filter :user
  filter :address_street, as: :string, label: 'Street'
  filter :address_city, as: :string, label: 'City'
  filter :address_postal_code, as: :string, label: 'Postal Code'
  filter :province, as: :select, collection: -> { Province.all }
  filter :status, as: :select, collection: Order.statuses.keys.map { |status| [status.humanize, status] }
  filter :subtotal
  filter :gst
  filter :pst
  filter :hst
  filter :total_price
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs 'Order Details' do
      f.input :status, as: :select, collection: Order.statuses.keys.map { |status| [status.humanize, status] }
      f.input :subtotal
      f.input :gst
      f.input :pst
      f.input :hst
      f.input :total_price
    end

    f.inputs 'Address Details' do
      f.input :address_street, label: 'Street'
      f.input :address_city, label: 'City'
      f.input :address_postal_code, label: 'Postal Code'
      f.input :province_id, as: :select, collection: Province.all.map { |p| [p.name, p.id] }, label: 'Province'
    end

    f.inputs 'Order Items' do
      f.has_many :order_items, allow_destroy: true, new_record: true do |oi|
        oi.input :product
        oi.input :quantity
        oi.input :price, as: :number, min: 0
      end
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :status
      row :subtotal
      row :gst
      row :pst
      row :hst
      row :total_price
      row 'Created At' do
        order.created_at.in_time_zone('Eastern Time (US & Canada)').strftime('%B %d, %Y %H:%M')
      end
      row 'Updated At' do
        order.updated_at.in_time_zone('Eastern Time (US & Canada)').strftime('%B %d, %Y %H:%M')
      end
      row 'Street' do
        order.address_street
      end
      row 'City' do
        order.address_city
      end
      row 'Postal Code' do
        order.address_postal_code
      end
      row 'Province' do
        order.province&.name
      end
      row 'Customer' do
        link_to order.user.username, admin_user_path(order.user) if order.user
      end
    end

    panel 'Order Items' do
      table_for order.order_items do
        column 'Product' do |item|
          link_to item.product.name, admin_product_path(item.product)
        end
        column 'Quantity' do |item|
          item.quantity
        end
        column 'Price' do |item|
          if item.product.sale_price.present?
            number_to_currency(item.product.sale_price)
          else
            number_to_currency(item.price)
          end
        end
        column 'Total' do |item|
          if item.product.sale_price.present?
            number_to_currency(item.product.sale_price * item.quantity)
          else
            number_to_currency(item.price * item.quantity)
          end
        end
      end
    end
  end

  permit_params :status, :subtotal, :gst, :pst, :hst, :total_price, :address_street, :address_city, :address_postal_code, :province_id,
                order_items_attributes: [:id, :product_id, :quantity, :product_price, :_destroy]
end
