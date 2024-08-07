# app/controllers/charges_controller.rb
class ChargesController < ApplicationController
  def new
    @order = Order.find(params[:order_id])
  end

  def create
    @order = Order.find(params[:order_id])

    # Amount in cents
    @amount = (@order.total_price * 100).to_i

    customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      source: params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: @amount,
      description: "Order ##{@order.id}",
      currency: 'cad'
    )

    @order.update!(status: 'paid', stripe_charge_id: charge.id)

    redirect_to order_path(@order), notice: 'Payment successful!'
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_order_charge_path(@order)
  end
end
