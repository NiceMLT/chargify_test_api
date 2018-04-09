class SubscriptionsController < ApiController
  # GET /subscriptions/new
  def new
    @subscription = Subscription.new
  end

  # POST /subscriptions
  def create(attempts = 0)
    requester = Requester.new

    if requester.insufficient_funds?
      render json: { message: 'Subscription Not Created Due to Insufficient Funds' }, status: :unprocessable_entity
    elsif requester.paid?
      subscription = Subscription.create!(subscription_params.merge(payment_id: requester.payment_id))
      render json: { message: 'Subscription Created and Payment Processed', subscription_id: subscription.id }, status: :created
    elsif requester.error?
      return create(attempts + 1) if attempts < 3
      render json: { message: 'Gateway Down, Try Again Later' }, status: :unprocessable_entity
    end
  end

  # GET /subscriptions
  def index
    subscriptions = Subscription.all
    render json: { status: 'SUCCESS', message: 'Loaded all subscriptions', data: subscriptions }, status: :ok
  end

  # GET /subscriptions/1
  def show
    find_subscription
    render json: { status: 'SUCCESS', message: 'Got your sub, bro', data: @subscription }, status: :ok
  end

  def next_billing_date
    find_subscription
    @subscription.billing_date + 1.month
  end

  private

  def subscription_params
    params.require(:subscription).permit(:cc_number, :cc_expiration, :cc_code)
  end

  def find_subscription
    @subscription = Subscription.find(params[:id])
  end
end
