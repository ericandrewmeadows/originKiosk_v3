<?php
	require 'vendor/autoload.php';
	// Set your secret key: remember to change this to your live secret key in production
	// See your keys here: https://dashboard.stripe.com/account/apikeys
	\Stripe\Stripe::setApiKey("sk_live_3p3kLuWKmiz6rG3hFXLcyyTJ");


    // Get the PHP helper library from twilio.com/docs/php/install 
	require_once '/home/ubuntu/vendor/autoload.php'; // Loads the library 
	 
	use Twilio\Rest\Client; 

	// Token is created using Stripe.js or Checkout!
	// Get the payment token submitted by the form:
	$token = $_POST['stripeToken'];

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

	// Selects the LATEST customer information from a given phone number; only 1 row will be output.
	$sql = "SELECT
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
						phoneNumber = ".$phoneNumber."
				)
			;";

	$result = $conn->query($sql);

	if ($result->num_rows > 0) {
		// print("Customer exists");
	    // output data of each row
	    while($row = $result->fetch_assoc()) {
	        // echo "id: " . $row["customerId"]. " - Phone: " . $row["phoneNumber"]. " - customerToken: " . $row["token"]. "<br>";
	        // User exists - charge the most recent cairo_surface_mark_dirty_rectangle(surface, x, y, width, height)
	        $charge = \Stripe\Charge::create(array(
			  "amount" => 299, // $3.99 this time
			  "currency" => "usd",
			  "customer" => $row["token"]
			));
			// print ",".$charge;
			print str_replace("Stripe\\Charge JSON: ","",$charge);
	    }
	} else {
		print("Customer not created");
		// Your Account SID and Auth Token from twilio.com/console
		$sid = 'ACce96ececbb8285c903180db35796f65b';
		$token = '8b4c29703aaeb3797b0d61e4d7cb5d6d';
		$client = new Client($sid, $token);

		$twilioDesitination = "+1".$phoneNumber;
		// $rawNumber = "9377761657";
		// $twilioDesitination = "+1".$rawNumber;

		// Use the client to do fun stuff like send text messages!
		$client->messages->create(
		    // the number you'd like to send the message to
		    $twilioDesitination,
		    array(
		        // A Twilio phone number you purchased at twilio.com/console
		        'from' => '+15623625363',
		        // the body of the text message you'd like to send
		        'body' => 'Welcome to SnackBlend :).  Enter your payment information into Stripe: http://35.163.38.99/StripePaymentCollection.php?phoneNumber='.$phoneNumber
		    )
		);
	}
	$conn->close();

?>