import { loadStripe } from "@stripe/stripe-js";

const initStripe = async () => {

  const stripe = await loadStripe(window.stripePublishableKey);
  const elements = stripe.elements({
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
        color: "#32325D",
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

  const customerName = document.getElementById("customer-name").innerHTML;
  const clientSecret = document.getElementById("stripe-submit").getAttribute('data-secret');

  form.addEventListener("submit", function (ev) {
    ev.preventDefault();
    window
      .Toast({
        text: "Payment processing, please wait",
        duration: 3000,
        close: true,
        gravity: "top",
        position: "left",
        backgroundColor: "linear-gradient(to right, #00b09b, #96c93d)",
      })
      .showToast();
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
          window
            .Toast({
              text: result.error.message,
              duration: 3000,
              close: true,
              gravity: "top", // `top` or `bottom`
              position: "left", // `left`, `center` or `right`
              backgroundColor: "linear-gradient(to right, #f26161, #f54242)",
            })
            .showToast();
        } else {
          // The payment has been processed!
          if (result.paymentIntent.status === "succeeded") {
            // Show a success message to your customer
            window
              .Toast({
                text: "Payment successful, you are being redirected",
                duration: 3000,
                close: true,
                gravity: "top",
                position: "left",
                backgroundColor: "linear-gradient(to right, #00b09b, #96c93d)",
              })
              .showToast();

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