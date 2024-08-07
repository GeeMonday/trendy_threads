# lib/session_cart.rb
class SessionCart
    def initialize(session)
      @session = session
      @items = load_items
    end
  
    def add_product(product, quantity)
      @items[product.id.to_s] = { 'product' => product, 'quantity' => quantity }
      save_items
    end
  
    def update_item(product, quantity)
      if quantity.to_i <= 0
        remove_item(product)
      else
        @items[product.id.to_s]['quantity'] = quantity
        save_items
      end
    end
  
    def remove_item(product)
      @items.delete(product.id.to_s)
      save_items
    end
  
    def total_price
      @items.values.sum { |item| item['product'].price * item['quantity'] }
    end
  
    def clear
      @items.clear
      save_items
    end
  
    private
  
    def load_items
      @session[:cart] ||= {}
    end
  
    def save_items
      @session[:cart] = @items
    end
  end
  