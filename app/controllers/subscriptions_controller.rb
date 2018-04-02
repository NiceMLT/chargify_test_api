class SubscriptionsController < ApiController

  def create
    new_sub_response = HTTParty.request

    if response_ok
      subscription = Subscription.new(params)
      return "subscription created and payment successful"
    elsif response_fail
      return "subscription not created due to insufficient funds"
    elsif response_timeout
      #do that stuff again
    elsif response_503
      return "Service Unavailable"
    end
  end

  def index
    subscriptions = Subscription.all
    render json: {status: 'SUCCESS', message: 'Loaded all subscriptions', data: subscriptions}, status: :ok
  end

  def show
    render json: {status: 'SUCCESS', message: 'Got your sub, bro', data: @subscription}, status: :ok
  end

  def show_all_for_user
    render json: {status: 'SUCCESS', message: 'All subs for user', data: @user_subscriptions}, status: :ok
  end

  private
    def find_subscription
      @subscription = Subscription.find(params[:id])
    end

    def find_subscriptions_for_user
      @user_subscriptions = Subscription.find(params[:email])
    end
end
