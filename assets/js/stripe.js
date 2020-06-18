import { loadStripe } from "@stripe/stripe-js";

const initStripe = async () => {

  const stripe = await loadStripe(window.stripePublishableKey);
  const elements = stripe.elements({
    fonts: [
      {
        cssSrc: "https://rsms.me/inter/inter-ui.css",
      },
    ],
    // Stripe's examples are localized to specific languages, but if
    // you wish to have Elements automatically detect your user's locale,
    // use `locale: 'auto'` instead.
    locale: window.__exampleLocale,
  });
  window.stripe = stripe;
  window.stripeElements = elements;

  const card = elements.create("card", {
    style: {
      base: {
        color: "#ffffff",
        fontWeight: 500,
        fontFamily: "Inter UI, Open Sans, Segoe UI, sans-serif",
        fontSize: "16px",
        fontSmoothing: "antialiased",

        "::placeholder": {
          color: "#CFD7DF",
        },
      },
      invalid: {
        color: "#E25950",
      },
    },
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

  const customerName = document.getElementById("customer-name").value;
  const clientSecret = document.getElementById("stripe-submit").getAttribute('data-secret');

  form.addEventListener("submit", function (ev) {
    ev.preventDefault();
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
            console.log(result)
            let transForm = document.getElementById('transaction-form')
            let transIdField = document.getElementById('transaction-id')
            let transDetailsField = document.getElementById('transaction-details')
            let transDateField = document.getElementById('transaction-date')
            let transAmountField = document.getElementById('transaction-amount')
            let transMethodField = document.getElementById('transaction-method')

            let countryField = document.getElementById('country').value
            let cityField = document.getElementById('city').value
            let stateField = document.getElementById('state').value
            let addressField = document.getElementById('address').value
            let postcodeField = document.getElementById('postcode').value

            transIdField.value = result.paymentIntent.id
            transMethodField.value = result.paymentIntent.payment_method_types[0]
            transAmountField.value = result.paymentIntent.amount
            transDateField.value = new Date().toISOString()
            transDetailsField.value = {
              "city": cityField,
              "state": stateField,
              "country": countryField,
              "address": addressField,
              "postcode": postcodeField,
              "cardHolderName": customerName
            }
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