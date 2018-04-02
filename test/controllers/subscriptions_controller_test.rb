require 'test_helper'

class SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  RSpec.describe SubscriptionsController, type: :controller do

  describe "GET #show" do
    ## get subscription_info
    returns all valid subscriptions given a user

    before do
      get :show, id: subscription.id
    end

    let(:subscription) { Subscription.create(paid: true, billing_date: Time.now) }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    ##returns next billing date for a particular subscription given a subscription id
    it "response with JSON body containing paid status and next billing date" do
      hash_body = nil
      expect { hash_body = JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
      expect(hash_body).to match({
        id: subscription.id,
        paid: true,
        billing_date: 1.month.from_now
      })
    end
  end

  describe "INDEX #index" do
    ## Index of all subscriptions
    before do
      get :index
    end

    let(:subscriptions) { Subscription.all }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "response with JSON body containing expected Subscription attributes" do
      hash_body = nil
      expect { hash_body = JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
      expect(hash_body.first).to match({
        id: subscriptions.first.id
      })
    end
  end

  describe "CREATE #create" do
    let(:good_sub) { Subscription.create(paid: true, billing_date: Time.now) }
    let(:bad_sub) { Subscription.create(paid: false) }

    describe "Success" do
      #subscription is persisted in the database if successful
      it "creates the subscription in the database" do
        expect(good_sub.id).to_not be_nil
      end

      #api returns a message of "subscription created and payment successful" if successful
      it "returns subscription created and payment successful when the payment is successful" do
        expect(response.body).to_be "subscription created and payment successful"
      end

      it "returns a response with JSON body containing paid status and failure_message" do
        hash_body = nil
        expect { hash_body = JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
        expect(hash_body).to match({
          paid: true,
          failure_message: nil
        })
      end
    end

    describe "Failure" do
      # subscription is not persisted in the database if insufficient funds
      it "does not persist the subscription in the database" do
        expect(bad_sub.id).to be_nil
      end

      # api returns a message of "subscription not created due to insufficient funds" if unsuccessful due to NSF
      it "returns subscription not created due to insufficient funds when the payment is insufficient funds" do
        expect(response.body).to_be "subscription not created due to insufficient funds"
      end

      it "returns a response with JSON body containing paid status and failure_message" do
        hash_body = nil
        expect { hash_body = JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
        expect(hash_body).to match({
          paid: false,
          failure_message: "insufficient_funds"
        })
      end
    end

    describe "Timeout" do
      #timeout
      # subscription charge is retried if the payment gateway times out
      it "retries on timeout or error" do

      end
    end
  end

  ## bonus (should this be in the model?)
  #card is returned as valid if it meets validation requirements
  #card is returned as invalid if it fails validation requirements
end