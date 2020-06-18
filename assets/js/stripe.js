import { loadStripe } from "@stripe/stripe-js";

const initStripe = async () => {

  const stripe = await loadStripe(window.stripePublishableKey);
  const elements = stripe.elements({
    locale: window.__exampleLocale,
  });
  window.stripe = stripe;
  window.stripeElements = elements;

  const card = elements.create("card", {
    iconStyle: "solid",
    style: {
      base: {
        iconColor: "#fff",
        color: "#fff",
        fontWeight: 400,
        fontFamily: "Helvetica Neue, Helvetica, Arial, sans-serif",
        fontSize: "16px",
        fontSmoothing: "antialiased",

        "::placeholder": {
          color: "#BFAEF6"
        },
        ":-webkit-autofill": {
          color: "#fce883"
        }
      },
      invalid: {
        iconColor: "#FFC7EE",
        color: "#FFC7EE"
      }
    }
  });

  card.mount("#card-element");

  card.on("change", ({ error }) => {
    const displayError = document.getElementById("card-errors");
    if (error) {
      displayError.textContent = error.message;
    } else {
      displayError.textContent = "";
    }
  });

  const form = document.getElementById("payment-form");

  const clientSecret = document.getElementById("stripe-submit").getAttribute('data-secret');

  form.addEventListener("submit", function (ev) {
    ev.preventDefault();
    const customerName = document.getElementById("cardholder-name").value;
    // Complete Payment With Stripe
    stripe
    .confirmCardPayment(clientSecret, {
      payment_method: {
        card: card,
        billing_details: {
          name: customerName,
        },
      },
    })
    .then(function (result) {
      if (result.error) {
        console.log(result.error)
      } else {
        // The payment has been processed!
        if (result.paymentIntent.status === "succeeded") {
          let transForm = document.getElementById('transaction-form')
          let transIdField = document.getElementById('transaction-id')
          let transDetailsField = document.getElementById('transaction-details')
          let transDateField = document.getElementById('transaction-date')
          let transAmountField = document.getElementById('transaction-amount')
          let transMethodField = document.getElementById('transaction-method')

            let cityField = document.getElementById('city').value
            let stateField = document.getElementById('state').value
            let addressField = document.getElementById('address').value
            let postcodeField = document.getElementById('postcode').value

            transIdField.value = result.paymentIntent.id
            transMethodField.value = result.paymentIntent.payment_method_types[0]
            transAmountField.value = result.paymentIntent.amount
            transDateField.value = new Date().toISOString()
            transDetailsField.value = JSON.stringify({
              "city": cityField,
              "state": stateField,
              "address": addressField,
              "postcode": postcodeField,
              "name": customerName
            })
            setTimeout(() => {
              transForm.submit()
            }, 2000)
          }
        }
      });
  });
};

if (window.location.href.includes("checkout")){
  initStripe();
}