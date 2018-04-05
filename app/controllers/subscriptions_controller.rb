class SubscriptionsController < ApiController

  before_action :create_session, only: %i[create]

  # GET /subscriptions/new
  def new
    @subscription = Subscription.new
  end

  # POST /subscriptions
  def create
    requester = Requester.new
    if requester.paid?
      subscription = Subscription.new(subscription_params)
      return 'subscription created and payment successful'
    elsif requester.insufficient_funds?
      return 'subscription not created due to insufficient funds'
    elsif requester.error?
      sleep 15
      # retry
    end
  end

  #GET /subscriptions
  def index
    subscriptions = Subscription.all
    render json: { status: 'SUCCESS', message: 'Loaded all subscriptions', data: subscriptions }, status: :ok
  end

  # GET /subscriptions/1
  def show
    render json: { status: 'SUCCESS', message: 'Got your sub, bro', data: @subscription }, status: :ok
  end

  # GET /subscriptions/user_id?{@user}
  def show_all_for_user
    render json: { status: 'SUCCESS', message: 'All subs for user', data: @user_subscriptions }, status: :ok
  end

  private

  def create_session
    HTTParty.get('https://gist.github.com/freezepl/2a75c29c881982645156f5ccf8d1b139/')
  end

  def subscription_params
    params[:subscription].permit(:user_id, :paid, :billing_date, :amount, :cc_number, :cc_expiration, :cc_code)
  end

  def find_subscription
    @subscription = Subscription.find(params[:id])
  end

  def find_subscriptions_for_user
    @user_subscriptions = Subscription.find(params[:email])
  end
end
