<?php
	require 'vendor/autoload.php';
	require 'paymentFunctions.php';

	require_once 'nameParser.php';
	$parser = new FullNameParser();
	// Set your secret key: remember to change this to your live secret key in production
	// See your keys here: https://dashboard.stripe.com/account/apikeys
	// \Stripe\Stripe::setApiKey("sk_test_ze5Ft72xeahq59xhYqqb5BHE");
	\Stripe\Stripe::setApiKey("sk_live_3p3kLuWKmiz6rG3hFXLcyyTJ");

	// Token is created using Stripe.js or Checkout!
	// Get the payment token submitted by the form:
	$token = $_GET['stripeToken'];
	$phoneNumber = $_GET['phoneNumber'];
	$PIN = $_GET['PIN'];
	$firstName = $_GET['firstName'];
	$lastName = $_GET['lastName'];
	$companyName = $_GET['companyName'];

	// Create a Customer:
	$customer = \Stripe\Customer::create(array(
	  "email" => $phoneNumber."@snackblend.com",
	  "metadata" => array("phoneNumber" => $phoneNumber),
	  "source" => $token
	));

	$customerId = $customer['id'];
	$last4 = $customer['sources']['data'][0]['last4'];
	$brand = $customer['sources']['data'][0]['brand'];
	$funding = $customer['sources']['data'][0]['funding'];
	$expMonth = $customer['sources']['data'][0]['exp_month'];
	$expYear = $customer['sources']['data'][0]['exp_year'];

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
				(phoneNumber, firstName, lastName, last4, brand, funding, expMonth, expYear, token)
			VALUES
				('".$phoneNumber."',"
				."'".$firstName."',"
				."'".$lastName."',"
				."'".$last4."',"
				."'".$brand."',"
				."'".$funding."',"
				."'".$expMonth."',"
				."'".$expYear."',"
				."'".$customerId."')";

	// Store payment information
	$conn->query($sql);

	// A higher "cost" is more secure but consumes more processing power
	$cost = 10;

	// Create a random salt
	$salt = strtr(base64_encode(mcrypt_create_iv(16, MCRYPT_DEV_URANDOM)), '+', '.');

	// Prefix information about the hash so PHP knows how to verify it later.
	// "$2a$" Means we're using the Blowfish algorithm. The following two digits are the cost parameter.
	$salt = sprintf("$2a$%02d$", $cost) . $salt;

	// Value:
	// $2a$10$eImiTXuWVxfM37uY4JANjQ==

	// Hash the password with the salt
	$hash = crypt($PIN, $salt);

	// Value:
	// $2a$10$eImiTXuWVxfM37uY4JANjOL.oTxqp7WylW7FCzx2Lc7VLmdJIddZq

	$sql = '
	INSERT INTO
		pinCode
		(phoneNumber, pinHash)
	VALUES
		('.$phoneNumber.', "'.$hash.'");';

	// Insert into Hash Table
	$conn->query($sql);

	// Store hashcode

	if ($_GET['chargeNow'] == 1) {
		
		$basePrice = 2.99;				
		$chargeAmt = getPaymentAmount($conn, $companyName, $basePrice);
		
		chargeCustomer($chargeAmt, $companyName, $customerId, $conn, $phoneNumber);
	}
	$conn->close();

?>