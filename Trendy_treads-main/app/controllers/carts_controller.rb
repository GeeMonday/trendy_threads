class CartsController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart = current_user.cart || Cart.create(user: current_user)
    @cart_items = @cart.cart_items.includes(:product)
    @cart_total = @cart.calculate_total
    @provinces = Province.order(:name)
  end

  def add_to_cart
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i

    if current_user.cart
      current_user.cart.add_product(product, quantity)
      flash[:notice] = 'Product added to cart!'
    else
      flash[:alert] = 'Failed to add product to cart.'
    end

    redirect_to product_path(product)
  end

  def update
    @cart = current_user.cart
    if @cart
      cart_item_id = params[:cart_item_id]
      new_quantity = params[:quantity].to_i

      item = @cart.cart_items.find_by(id: cart_item_id)
      if item
        item.update(quantity: new_quantity) if new_quantity.positive?
      else
        flash[:alert] = 'Item not found in cart.'
      end
    else
      flash[:alert] = 'Cart not found.'
    end

    redirect_to cart_path
  end

  def remove
    @cart = current_user.cart
    if @cart
      cart_item_id = params[:id]

      item = @cart.cart_items.find_by(id: cart_item_id)
      if item
        item.destroy
        flash[:notice] = 'Item removed from cart.'
      else
        flash[:alert] = 'Item not found in cart.'
      end
    else
      flash[:alert] = 'Cart not found.'
    end

    redirect_to cart_path
  end
  
  def checkout
    @cart = current_user.cart
    if @cart
      @order = Order.new(
        address_street: current_user.address&.street,
        address_city: current_user.address&.city,
        address_postal_code: current_user.address&.postal_code,
        province_id: current_user.address&.province_id,
        user: current_user,  # Ensure the user is set
        status: 'new_order'
      )
  
      # Initialize provinces for the dropdown
      @provinces = Province.order(:name)
    else
      flash[:alert] = 'Your cart is empty or not found.'
      redirect_to cart_path
    end
  end
  
  def complete_checkout
    @order = Order.new(order_params)
    @order.user = current_user
    @order.status = 'new_order'
    
    @cart = current_user.cart
    @provinces = Province.order(:name)  # Ensure provinces are set here
  
    if @cart && @cart.cart_items.present?
      cart_total = @cart.cart_items.sum do |item|
        item.product.price * item.quantity
      end
  
      province = params[:order][:province_id]
      tax_details = TaxCalculator.calculate_total_price(cart_total, province)
  
      # Debug log
      Rails.logger.debug "Cart Total: #{cart_total}"
      Rails.logger.debug "Tax Details: #{tax_details.inspect}"
  
      # Ensure the tax details and subtotal are set
      @order.subtotal = cart_total
      @order.gst = tax_details[:gst]
      @order.pst = tax_details[:pst]
      @order.hst = tax_details[:hst]
      @order.total_price = tax_details[:total_price]
  
      # Create order items
      @cart.cart_items.each do |item|
        @order.order_items.build(
          product: item.product,
          quantity: item.quantity,
          price: item.product.price
        )
      end
  
      # Debug log for order before saving
      Rails.logger.debug "Order Details Before Save: #{@order.attributes.inspect}"
  
      if @order.save
  
        respond_to do |format|
          format.html { redirect_to order_path(@order), notice: 'Checkout completed successfully.' }
          format.turbo_stream { render turbo_stream: turbo_stream.replace('cart', partial: 'orders/confirmation', locals: { order: @order }) }
        end
      else
        flash[:alert] = "Order could not be processed. Errors: #{@order.errors.full_messages.join(', ')}"
        respond_to do |format|
          format.html { render :checkout }
          format.turbo_stream { render turbo_stream: turbo_stream.replace('checkout', partial: 'carts/checkout', locals: { order: @order }) }
        end
      end
    else
      flash[:alert] = "Your cart is empty or not found."
      redirect_to cart_path
    end
  end
  


  private

  def order_params
    params.require(:order).permit(:address_street, :address_city, :address_postal_code, :province_id, :payment_method)
  end
  

  def process_payment(order)
    # Implement your payment gateway integration here
    # Example: Stripe payment processing
    # Ensure you handle payment errors and edge cases
    true # Assume payment is successful for this example
  end
end
