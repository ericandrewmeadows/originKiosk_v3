<?php
	require 'vendor/autoload.php';
	// Set your secret key: remember to change this to your live secret key in production
	// See your keys here: https://dashboard.stripe.com/account/apikeys
	// \Stripe\Stripe::setApiKey("sk_test_ze5Ft72xeahq59xhYqqb5BHE");
	\Stripe\Stripe::setApiKey("sk_live_3p3kLuWKmiz6rG3hFXLcyyTJ");

	

	// Token is created using Stripe.js or Checkout!
	// Get the payment token submitted by the form:
	$token = $_POST['stripeToken'];

	// Create a Customer:
	$customer = \Stripe\Customer::create(array(
	  "email" => $_POST['Phone-Number']."@snackblend.com",
	  "metadata" => array("phoneNumber" => $_POST['Phone-Number']),
	  "source" => $token,
	));

	// print($customer);
	// print("<br><br>Data<br>".$customer['sources']['data'][0]."<br><br>");
	$customerId = $customer['id'];
	$phoneNumber = $_POST['Phone-Number'];
	$last4 = $customer['sources']['data'][0]['last4'];
	$brand = $customer['sources']['data'][0]['brand'];
	$funding = $customer['sources']['data'][0]['funding'];
	$expMonth = $customer['sources']['data'][0]['exp_month'];
	$expYear = $customer['sources']['data'][0]['exp_year'];


	// print("<br>");
	// print("<br><br>POST<br>");
	// print_r($_POST);
	// print("<br><br>");

	$servername = "localhost";
	$username = "root";
	$password = "root";
	$database = "snackblendKiosk";

	// Create connection
	$conn = new mysqli($servername, $username, $password, $database);
	// Check connection
	if ($conn->connect_error) {
	    die("Connection failed: " . $conn->connect_error);
	}

	$sql = "INSERT INTO userInfo
				(phoneNumber, last4, brand, funding, expMonth, expYear, token)
			VALUES
				('".$phoneNumber."',"
				."'".$last4."',"
				."'".$brand."',"
				."'".$funding."',"
				."'".$expMonth."',"
				."'".$expYear."',"
				."'".$customerId."')";

	// print("<br><br>".$sql."<br><br>");

	if ($conn->query($sql) === TRUE) {
	    // echo "New record created successfully";
	    header("Location: /completedRegistration.html"); /* Redirect browser */
	} else {
	    // echo "Error: " . $sql . "<br>" . $conn->error;
	    header("Location: /failedRegistration.html"); /* Redirect browser */
	}

	$conn->close();

	// // YOUR CODE (LATER): When it's time to charge the customer again, retrieve the customer ID.
	// $charge = \Stripe\Charge::create(array(
	//   "amount" => 1500, // $15.00 this time
	//   "currency" => "usd",
	//   "customer" => $customer_id
	// ));
?>
<html>
<body>
	Help
</body>
</html>