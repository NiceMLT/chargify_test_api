# chargify_test_api

You can test the requester by firing up the fake server in a separate terminal `.bin/fake-server` this will enable you to hit the fake-server I've copied and modified a little so that you can see the responses.

Open a rails console and `Requester.new` will create a new random request and response.  You can use the methods in the requester model to check to see if it's insufficient_funds?, paid?, or an error?.  Those are utilized to determine what happens in the create API.  Created (and paid) subscriptions will be persisted in the database and a "Subscription Created and Payment Processed" will be returned.  Insufficient funds will not create a subscription and a message of "Subscription Not Created Due to Insufficient Funds" will be returned. Service unavailable and timeouts will retry 3 times before returning a message of "Gateway Down, Try Again Later".

Since the fake server only returns random responses and doesn't accept any parameters (yet), you can't actually pass in CC info to check the validity.

If successful the payment_id will be pulled in to the database as part of the subscription.  The cost is hard-coded right now but obviously can be modified to be a permitted parameter.  
