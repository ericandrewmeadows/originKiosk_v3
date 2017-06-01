<?php
	require 'vendor/autoload.php';
	include 'paymentFunctions.php';
	// Set your secret key: remember to change this to your live secret key in production
	// See your keys here: https://dashboard.stripe.com/account/apikeys
	\Stripe\Stripe::setApiKey("sk_live_3p3kLuWKmiz6rG3hFXLcyyTJ");


    // Get the PHP helper library from twilio.com/docs/php/install 
	require_once '/home/ubuntu/vendor/autoload.php'; // Loads the library 
	 
	use Twilio\Rest\Client; 

	// Token is created using Stripe.js or Checkout!
	// Get the payment token submitted by the form:
	// if(isset($_POST['stripeToken'])) {
	// 	$token = $_POST['stripeToken'];
	// }

	$servername = "localhost";
	$username = "root";
	$password = "root";
	$database = "snackblendKiosk";

	$phoneNumber = $_GET["phoneNumber"];

	// Create connection
	$conn = new mysqli($servername, $username, $password, $database);
	// Check connection
	if ($conn->connect_error) {
	    die("Connection failed: " . $conn->connect_error);
	}

	$sql = 'SELECT
				*
			FROM 
				userInfo
			WHERE 
				customerId =
				(
					SELECT
						MAX(customerId) 
					FROM
						userInfo
					WHERE
						phoneNumber = '.$phoneNumber.'
				)
			;';
	$user_result = $conn->query($sql);

	$sql = 'SELECT
				*
			FROM
				pinCode
			WHERE
				phoneNumber = '.$phoneNumber.'
			;';
	$pinCode_result = $conn->query($sql);

	if (($user_result->num_rows > 0) && ($pinCode_result->num_rows > 0)) {
	    print("Exists"); // Do if present
	}
	else if ($user_result->num_rows > 0) {
		print("PIN not present"); // Migration of user
	}
	else {
		print("Phone Number DNE"); // Do if not present
	}
?>