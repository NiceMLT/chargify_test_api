require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'GET #show' do
    ## get a single subscription
    before do
      @sub1 = create(:subscription)
      get :show, params: { id: @sub1.id }
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    # Failure/Error: get :show, id: @sub1.id
    # #returns next billing date for a particular subscription given a subscription id
    it 'response with JSON body containing paid status and next billing date' do
      hash_body = nil
      expect { hash_body = JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
      expect(@sub1.next_billing_date).to match "Sat, 05 May 2018"
      expect(hash_body["status"]).to match "SUCCESS"
      expect(hash_body["message"]).to match "Got your sub, bro"
      expect(hash_body)["data"].to match(id: @sub1.id, paid: true)
    end
  end

  describe 'GET #show_all_for_user' do
    # #returns all valid subscriptions given a user

    before do
      get :show_all_for_user, email: user.email
    end

    let(:user) { User.create(name: 'Test User', email: 'totally@realemail.com') }
    let(:user_sub1) { Subscription.create(paid: true, billing_date: Time.now, user_id: user.id, cost: 100) }
    let(:user_sub2) { Subscription.create(paid: true, billing_date: Time.now, user_id: user.id, cost: 100) }
    let(:user_sub3) { Subscription.create(paid: true, billing_date: Time.now, user_id: user.id, cost: 100) }
    #Failure/Error: get :show_all_for_user, email: user.email
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    #Failure/Error: get :show_all_for_user, email: user.email
    # #returns all subscriptions given a specific user
    it 'response with JSON body containing all subs for user' do
      hash_body = nil
      expect { hash_body = JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
      expect(hash_body.first).to match(id: user_sub1.id,
                                       paid: true,
                                       cost: 100)
      expect(hash_body.last).to match(id: user_sub3.id,
                                      paid: true,
                                      cost: 100)
    end
  end

  describe 'INDEX #index' do
    ## Index of all subscriptions
    before do
      get :index
    end

    let(:subscriptions) { Subscription.all }
    let(:sub1) { Subscription.create(paid: true, billing_date: Time.now, user_id: user.id, cost: 100) }
    let(:sub2) { Subscription.create(paid: true, billing_date: Time.now, user_id: user.id, cost: 100) }

    # Failure/Error: get :index
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    #Failure/Error: get :index
    it 'response with JSON body containing expected Subscription attributes' do
      hash_body = nil
      expect { hash_body = JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
      expect(hash_body.first).to match(id: subscriptions.first.id,
                                       paid: true)
    end
  end

  describe 'CREATE #create' do

    let(:good_sub) { Subscription.create(paid: true, billing_date: Time.now, cost: 100) }
    let(:bad_sub) { Subscription.create(paid: false) }

    describe 'Success' do
      it 'creates the subscription in the database' do
        fake_requester = instance_double('Requester', paid?: true)
        expect(Requester).to receive(:new) { fake_requester }
        post :create, params: {}
        expect(good_sub.id).to_not be_nil
      end

      # api returns a message of "subscription created and payment successful" if successful
      it 'returns "subscription created and payment successful" when the payment is successful' do
        fake_requester = instance_double('Requester', paid?: true)
        expect(Requester).to receive(:new) { fake_requester }
        post :create, params: {}
        expect(good_sub.response.body).to_be 'subscription created and payment successful'
      end

      #FAILS
      it 'returns a response with JSON body containing paid status and nil failure_message' do
        fake_requester = instance_double('Requester', paid?: true)
        expect(Requester).to receive(:new) { fake_requester }
        post :create, params: {}
        hash_body = nil
        expect { hash_body = JSON.parse(good_sub.response.body).with_indifferent_access }.not_to raise_exception
        expect(hash_body).to match(paid: true,
                                   failure_message: nil)
      end
    end

    describe 'Failure' do
      # subscription is not persisted in the database if insufficient funds
      it 'does not persist the subscription in the database' do
        fake_requester = instance_double('Requester', insufficient_funds?: true)
        expect(Requester).to receive(:new) { fake_requester }
        post :create, params: {}
        expect(fake_requester.id).to be_nil
      end

      # api returns a message of "subscription not created due to insufficient funds" if unsuccessful due to NSF
      it 'returns "subscription not created due to insufficient funds" when the payment is insufficient funds' do
        fake_requester = instance_double('Requester', insufficient_funds?: true)
        expect(Requester).to receive(:new) { fake_requester }
        post :create, params: {}
        expect(fake_requester.response.body).to_be 'subscription not created due to insufficient funds'
      end

      it 'returns a response with JSON body containing paid status and failure_message' do
        fake_requester = instance_double('Requester', insufficient_funds?: true)
        expect(Requester).to receive(:new) { fake_requester }
        post :create, params: {}
        hash_body = nil
        expect { hash_body = JSON.parse(fake_requester.response.body).with_indifferent_access }.not_to raise_exception
        expect(hash_body).to match(paid: false,
                                   failure_message: 'insufficient_funds')
      end
    end

    # describe "Timeout" do
    #   #timeout
    #   # subscription charge is retried if the payment gateway times out
    #   # it "retries on timeout or error" do
    #   #
    #   # end
    # end
  end

  ## bonus (should this be in the model?)
  # card is returned as valid if it meets validation requirements
  # card is returned as invalid if it fails validation requirements
end
