ActiveAdmin.register_page "Customer Orders" do
  content do
    panel "All Customers and Their Orders" do
      table_for User.includes(:orders) do
        column "Customer" do |user|
          user.username
        end
        column "Email" do |user|
          user.email
        end
        column "Orders" do |user|
          user.orders.map do |order|
            content_tag(:div, class: "order-details") do
              concat(content_tag(:strong, "Order ##{order.id}"))
              concat(content_tag(:p, "Subtotal: #{number_to_currency(order.subtotal)}"))
              concat(content_tag(:p, "GST: #{number_to_currency(order.gst)}"))
              concat(content_tag(:p, "PST: #{number_to_currency(order.pst)}"))
              concat(content_tag(:p, "HST: #{number_to_currency(order.hst)}"))
              concat(content_tag(:p, "Total Taxes: #{number_to_currency(order.gst.to_f + order.pst.to_f + order.hst.to_f)}"))
              concat(content_tag(:p, "Total: #{number_to_currency(order.total_price)}"))

              if order.order_items.any?
                concat(content_tag(:h4, "Ordered Products"))
                concat(
                  content_tag(:ul) do
                    order.order_items.each do |item|
                      product_name = item.product&.name || "Unknown Product"
                      quantity = item.quantity || 0
                      price = item.price || 0
                      total_price = quantity * price

                      concat(
                        content_tag(:li) do
                          "#{product_name} - Quantity: #{quantity}, Price: #{number_to_currency(price)}, Total: #{number_to_currency(total_price)}"
                        end
                      )
                    end
                  end
                )
              else
                concat(content_tag(:p, "No products ordered."))
              end
            end
          end.join("<br>").html_safe
        end
      end
    end
  end
end
