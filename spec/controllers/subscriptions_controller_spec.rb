require 'rails_helper'
require 'pry'

RSpec.describe SubscriptionsController, type: :controller do
  let(:json) { JSON.parse(response.body) }

  describe 'POST #create' do
    def make_request
      post :create, params: {
        subscription: {
          cc_number: '1',
          cc_expiration: '04/2041',
          cc_code: '867'
        }
      }
    end

    context 'when the credit card is successfully charged' do
      before do
        expect(Requester).to receive(:new).and_return(requester)
      end

      let(:requester) { instance_double('Requester', paid?: true, insufficient_funds?: false, payment_id: '123456') }

      it 'returns a 201 created' do
        make_request

        expect(response).to have_http_status(201)
      end

      it 'creates a new subscription' do
        make_request

        expect(Subscription.last).to have_attributes(
          cc_number: '1',
          cc_expiration: '04/2041',
          cc_code: '867',
          payment_id: '123456'
        )
      end

      it 'returns "funds ok" for the message attribute' do
        make_request

        expect(json).to include('message' => 'funds ok')
      end
    end

    context 'when the credit card has insufficient funds' do
      before do
        expect(Requester).to receive(:new).and_return(requester)
      end

      let(:requester) { instance_double('Requester', insufficient_funds?: true, paid?: false).as_null_object }

      it 'returns a 422 unproccessable entity' do
        make_request

        expect(response).to have_http_status(422)
      end

      it 'returns "funds not ok" for the message attribute' do
        make_request

        expect(json).to include('message' => 'funds not ok')
      end

      it 'does not create a new subscription' do
        expect {
          make_request
        }.not_to change { Subscription.count }
      end
    end

    context 'when the billing gateway errors and the attempts are below 3' do

      it 'returns a success if the third attempt is successful' do
        bad_requester = instance_double('Requester', insufficient_funds?: false, paid?: false, error?: true)
        good_requester = instance_double('Requester', insufficient_funds?: false, paid?: true, error?: false, payment_id: '1234567')
        expect(Requester).to receive(:new).and_return(bad_requester, bad_requester, good_requester)

        make_request

        expect(response).to have_http_status(201)
      end
    end

    context 'when the billing gateway errors and the attempts to hit the gateway exceeds 3' do
      it 'returns a 422 if attempts exceed 3' do
        bad_requester = instance_double('Requester', insufficient_funds?: false, paid?: false, error?: true)
        expect(Requester).to receive(:new).exactly(4).times.and_return(bad_requester)

        make_request

        expect(response).to have_http_status(422)
        expect(json["message"]).to eq("Gateway Down, Try Again Later")
      end
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { id: create(:subscription).id }

      expect(response).to have_http_status(:success)
    end

    # #returns next billing date for a particular subscription given a subscription id
    it 'returns a response with JSON body containing paid status and next billing date' do
      subscription = create(:subscription)

      get :show, params: { id: subscription.id }

      expect(json).to include(
        'status' => 'SUCCESS',
        'message' => 'Got your sub, bro',
        'data' => include(
          'id' => subscription.id,
        )
      )
    end
  end

  describe 'INDEX #index' do
    ## Index of all subscriptions
    before do
      get :index
    end

    let(:subscriptions) { Subscription.all }
    let(:sub1) { Subscription.create!(paid: true, billing_date: Time.now, cost: 100) }
    let(:sub2) { Subscription.create!(paid: true, billing_date: Time.now, cost: 100) }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'response with JSON body containing expected Subscription attributes' do
      binding.pry
      expect(json).to include(
        'status' => 'SUCCESS',
        'message' => 'Loaded all subscriptions',
        'data' => include(
          'id' => sub1.id,
        )
      )
    end
  end

  ## bonus (should this be in the model?)
  # card is returned as valid if it meets validation requirements
  # card is returned as invalid if it fails validation requirements
end
