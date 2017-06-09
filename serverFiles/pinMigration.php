<?php
	require 'vendor/autoload.php';
	require 'paymentFunctions.php';

	require_once 'nameParser.php';
	$parser = new FullNameParser();
	// Set your secret key: remember to change this to your live secret key in production
	// See your keys here: https://dashboard.stripe.com/account/apikeys
	// \Stripe\Stripe::setApiKey("sk_test_ze5Ft72xeahq59xhYqqb5BHE");
	\Stripe\Stripe::setApiKey("sk_live_3p3kLuWKmiz6rG3hFXLcyyTJ");

	// Twilio
	require_once '/home/ubuntu/vendor/autoload.php'; // Loads the library

	// Token is created using Stripe.js or Checkout!
	// Get the payment token submitted by the form:
	$phoneNumber = $_GET['phoneNumber'];
	$PIN = $_GET['PIN'];
	$companyName = $_GET['companyName'];

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

	$sql = 'SELECT
				*
			FROM
				userInfo
			WHERE
				phoneNumber = '.$phoneNumber.'
			;';
	$customerId = $conn->query($sql)->fetch_object()->token;

	// Store hashcode
	// App should not launch pinMigration and userExists, but because chargeNow is not sent, this section needs to remain inactive
	// if ($_GET['chargeNow'] == 1) {
		
	// 	$basePrice = 2.99;				
	// 	$chargeAmt = getPaymentAmount($conn, $companyName, $basePrice);
		
	// 	// ---------- Free Smoothie Check ----------
	// 	if ($charged == 0) {
	// 		$giftOutput = checkFor_gifts($phoneNumber, $conn); // Automatically subtracts gifts and sends "FREE" receipt
	// 		if ($giftOutput != "error") {
	// 			print($giftOutput);
	// 			$charged = 1;
	// 		}
	// 	}

	// 	// -------------- Charge user --------------
	// 	if ($charged == 0) {
	// 		chargeCustomer($chargeAmt, $companyName, $userToken, $conn, $phoneNumber);
	// 		$charged = 1;
	// 	}
	// }
	$conn->close();

?>