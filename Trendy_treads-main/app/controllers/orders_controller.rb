class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_stripe_api_key
  before_action :set_order, only: [:update_status]

  def update_status
    if @order.update(order_params)
      redirect_to @order, notice: 'Order status updated successfully.'
    else
      redirect_to @order, alert: 'Failed to update order status.'
    end
  end


  def index
    @orders = current_user.orders
  end

  def new
    @order = Order.new
    @cart = current_user.cart
    @products = @cart.cart_items.includes(:product).map(&:product) if @cart
  end

  def create
    @cart = current_user.cart

    if @cart.cart_items.empty?
      redirect_to cart_path, alert: 'Your cart is empty. Add some products before placing an order.'
      return
    end

    @order = Order.new(order_params)
    @order.user = current_user
    @order.status = 'Pending' # Set default status
    @order.subtotal = @cart.cart_items.sum { |item| item.product.price * item.quantity }

    province = current_user.province
    tax_details = TaxCalculator.calculate_total_price(@order.subtotal, province.code)

    @order.gst = tax_details[:gst]
    @order.pst = tax_details[:pst]
    @order.hst = tax_details[:hst]
    @order.total_price = tax_details[:total_price]

    if @order.save
      add_cart_items_to_order
      current_user.cart.cart_items.destroy_all # Clear the cart

      begin
        payment_intent = Stripe::PaymentIntent.create({
          amount: (@order.total_price * 100).to_i,
          currency: 'usd',
          payment_method: params[:payment_method_id],
          confirm: true,
          return_url: order_url(@order),
          automatic_payment_methods: { enabled: true }
        })

        @order.update(status: 'Paid', stripe_payment_id: payment_intent.id)
        redirect_to @order, notice: 'Order was successfully created and paid.'
      rescue Stripe::CardError => e
        @order.destroy
        flash[:alert] = e.message
        render :new
      end
    else
      flash[:alert] = 'Order could not be created. Please try again.'
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
    @cart_items = @order.order_items.includes(:product)
  end

  def update
    @order = Order.find(params[:id])
  if @order.update(order_params)
    redirect_to @order, notice: 'Order was successfully updated.'
  else
    flash[:alert] = 'Order could not be updated. Please try again.'
    render :edit
  end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'Order not found.'
    redirect_to root_path
  end

  def set_stripe_api_key
    Rails.logger.debug "Stripe API Key: #{ENV['STRIPE_SECRET_KEY']}"
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
  end

  def order_params
    params.require(:order).permit(
      :address_street, :address_city, :address_postal_code, :province_id,
      :status, :subtotal, :gst, :pst, :hst, :total_price,
      order_items_attributes: [:id, :product_id, :quantity, :price, :product_price, :_destroy]
    )
  end

  def add_cart_items_to_order
    current_user.cart.cart_items.each do |item|
      if item.product.present?
        @order.order_items.create(
          product: item.product,
          quantity: item.quantity,
          price: item.quantity * item.product.price, # Total price for the quantity
          product_price: item.product.price # Backed up price of the product
        )
      else
        flash[:alert] = 'One or more products in your cart are not available.'
        redirect_to cart_path and return
      end
    end
  end
end
