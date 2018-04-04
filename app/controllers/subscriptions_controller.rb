class SubscriptionsController < ApiController
  def create
    authed_session = HTTParty.get('https://gist.github.com/freezepl/2a75c29c881982645156f5ccf8d1b139')
    new_sub_request = HTTParty.get('https://gist.github.com/freezepl/2a75c29c881982645156f5ccf8d1b139/validate')
    new_sub_response = JSON.parse(new_sub_request)

    if new_sub_response == response_ok
      subscription = Subscription.new(params)
      return 'subscription created and payment successful'
    elsif new_sub_response == response_fail
      return 'subscription not created due to insufficient funds'
    elsif new_sub_response == response_timeout
      sleep 15
      # do that stuff again
    elsif new_sub_response == response_503
      return 'Service Unavailable'
    end
  end

  def index
    subscriptions = Subscription.all
    render json: { status: 'SUCCESS', message: 'Loaded all subscriptions', data: subscriptions }, status: :ok
  end

  def show
    render json: { status: 'SUCCESS', message: 'Got your sub, bro', data: @subscription }, status: :ok
  end

  def show_all_for_user
    render json: { status: 'SUCCESS', message: 'All subs for user', data: @user_subscriptions }, status: :ok
  end

  private

  def subscription_params
    params[:subscription].permit(:user_id, :paid, :billing_date, :cc_number, :cc_expiration, :cc_code)
  end

  def find_subscription
    @subscription = Subscription.find(params[:id])
  end

  def find_subscriptions_for_user
    @user_subscriptions = Subscription.find(params[:email])
  end
end
