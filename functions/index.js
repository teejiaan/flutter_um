const functions = require('firebase-functions');
const admin = require('firebase-admin');
const stripe = require('stripe')('sk_test_51RU7OjPneyNRrgC5B7oSGjSnJ6i7hjeD8KkoIbKW5RnPRHTcxPyKLUvMYOACjfcpKjutMw9aT3EuOFLbBmbKf4G300We1H2Sn8');

admin.initializeApp();

exports.createCheckoutSession = functions.https.onCall(async (data, context) => {
  const session = await stripe.checkout.sessions.create({
    payment_method_types: ['card'],
    line_items: data.items,
    mode: 'payment',
    success_url: data.successUrl,
    cancel_url: data.cancelUrl,
  });

  return { id: session.id };
});
