<?php
    parse_str($_SERVER['QUERY_STRING']);
    // $phoneNumber now contains the phone number of the user
?>

<html>
<head>
<style>
* {
  font-family: "Helvetica Neue", Helvetica;
  font-size: 6vmin;
  font-variant: normal;
  padding: 0;
  margin: 0;
}

html {
  height: 100%;
}

body {
  background: #E6EBF1;
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100%;
}

form {
  width: 80vmin;
  margin: 20px 0;
}

.group {
  background: white;
  box-shadow: 0 7px 14px 0 rgba(49,49,93,0.10),
              0 3px 6px 0 rgba(0,0,0,0.08);
  border-radius: 4px;
  margin-bottom: 20px;
}

label {
  position: relative;
  color: #8898AA;
  font-weight: 300;
  height: 20vmin;
  line-height: 40px;
  margin-left: 20px;
  display: flex;
  flex-direction: row;
}

.group label:not(:last-child) {
  border-bottom: 1px solid #F0F5FA;
}

label > span {
  width: 10vmin;
  text-align: right;
  margin-right: 30px;
}

.field {
  background: transparent;
  font-weight: 300;
  border: 0;
  color: #31325F;
  outline: none;
  flex: 1;
  padding-right: 10px;
  padding-left: 10px;
  cursor: text;
}

.field::-webkit-input-placeholder { color: #CFD7E0; }
.field::-moz-placeholder { color: #CFD7E0; }

button {
  float: left;
  display: block;
  background: #666EE8;
  color: white;
  box-shadow: 0 7px 14px 0 rgba(49,49,93,0.10),
              0 3px 6px 0 rgba(0,0,0,0.08);
  border-radius: 4px;
  border: 0;
  margin-top: 20px;
  font-size: 15px;
  font-weight: 400;
  width: 100%;
  height: 40px;
  line-height: 38px;
  outline: none;
}

button:focus {
  background: #555ABF;
}

button:active {
  background: #43458B;
}

.outcome {
  float: left;
  width: 100%;
  padding-top: 8px;
  min-height: 24px;
  text-align: center;
}

.success, .error {
  display: none;
  font-size: 13px;
}

.success.visible, .error.visible {
  display: inline;
}

.error {
  color: #E4584C;
}

.success {
  color: #666EE8;
}

.success .token {
  font-weight: 500;
  font-size: 13px;
}
</style>
</head>
<script src="https://js.stripe.com/v3/"></script>
<body>
  <form>
    <div class="group">
      <label>
        <span>Name</span>
        <input name="cardholder-name" class="field" placeholder="Jane Doe" />
      </label>
      <label>
        <span>Phone</span>
        <input name="phoneNumber" class="field" placeholder="(123) 456-7890" type="tel" value="<?php echo $phoneNumber; ?>">
      </label>
    </div>
    <div class="group">
      <label>
        <span>Card</span>
        <div id="card-element" class="field"'></div>
      </label>
    </div>
    <button type="submit">Pay $25</button>
    <div class="outcome">
      <div class="error"></div>
      <div class="success">
        Success! Your Stripe token is <span class="token"></span>
      </div>
    </div>
  </form>
  <script>
  var stripe = Stripe('pk_live_20THiOzLAF5QMPXHWf2OmMW5');
var elements = stripe.elements();

var card = elements.create('card', {
  style: {
    base: {
      iconColor: '#666EE8',
      color: '#31325F',
      lineHeight: '40px',
      fontWeight: 300,
      fontFamily: 'Helvetica Neue',
      fontSize: '15px',

      '::placeholder': {
        color: '#CFD7E0'
      },
    },
  }
});
card.mount('#card-element');

function setOutcome(result) {
  var successElement = document.querySelector('.success');
  var errorElement = document.querySelector('.error');
  successElement.classList.remove('visible');
  errorElement.classList.remove('visible');

  if (result.token) {
    // Use the token to create a charge or a customer
    // https://stripe.com/docs/charges
    successElement.querySelector('.token').textContent = result.token.id;
    successElement.classList.add('visible');

// =========================================================================== work HERE ==================================================
//     successElement.text = successElement.text + "help"

// =========================================================================== work HERE ==================================================

  } else if (result.error) {
    errorElement.textContent = result.error.message;
    errorElement.classList.add('visible');
  }
}

card.on('change', function(event) {
  setOutcome(event);
});

document.querySelector('form').addEventListener('submit', function(e) {
  e.preventDefault();
  var form = document.querySelector('form');
  var extraDetails = {
    name: form.querySelector('input[name=cardholder-name]').value,
    metadata: {
      funny: "fun"
    }
  };
  stripe.createToken(card, extraDetails, hidePostalCode=true).then(setOutcome);
});
  </script>
</body>

</html>
