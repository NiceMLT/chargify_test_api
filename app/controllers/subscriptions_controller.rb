class SubscriptionsController < ApiController

  # GET /subscriptions/new
  def new
    @subscription = Subscription.new
  end

  # POST /subscriptions
  def create
    if authed_session
      new_sub_request = HTTParty.get('https://gist.github.com/freezepl/2a75c29c881982645156f5ccf8d1b139/validate')
      new_sub_response = JSON.parse(new_sub_request)

      if new_sub_response == response_ok
        subscription = Subscription.new(subscription_params)
        return 'subscription created and payment successful'
      elsif new_sub_response == response_fail
        return 'subscription not created due to insufficient funds'
      elsif new_sub_response == response_timeout
        sleep 15
        # do that stuff again
      elsif new_sub_response == response_503
        return 'Service Unavailable'
      end
    else
      return 'Invalid session'
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
