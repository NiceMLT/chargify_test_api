class SubscriptionsController < ApiController

  def create
    subscription = Subscription.new
    if response_ok
      #do some stuff
    elsif response_fail
      #do some other stuff
    else retry
      #do that stuff again
    end
  end

  def index
    subscriptions = Subscription.all
    render json: {status: 'SUCCESS', message: 'Loaded all subscriptions', data: subscriptions}, status: :ok
  end

  def show
    render json: {status: 'SUCCESS', message: 'Got your sub, bro', data: @subscription}, status: :ok
  end

  private
    def find_subscription
      @subscription = Subscription.find(params[:id])
    end
end
