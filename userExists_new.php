<?php
	require 'vendor/autoload.php';
	require 'paymentFunctions.php';
	require_once 'nameParser.php';
	$parser = new FullNameParser();

	// Set your secret key: remember to change this to your live secret key in production
	// See your keys here: https://dashboard.stripe.com/account/apikeys
	\Stripe\Stripe::setApiKey("sk_live_3p3kLuWKmiz6rG3hFXLcyyTJ");


    // Get the PHP helper library from twilio.com/docs/php/install 
	require_once '/home/ubuntu/vendor/autoload.php'; // Loads the library
	 

	// Token is created using Stripe.js or Checkout!
	// Get the payment token submitted by the form:
	// if(isset($_POST['stripeToken'])) {
	// 	$token = $_POST['stripeToken'];
	// }

	$servername = "localhost";
	$username = "root";
	$password = "root";
	$database = "snackblendKiosk";

	if (isset($_GET['phoneNumber'])) {
		$phoneNumber = $_GET["phoneNumber"];
	}
	else {
		$phoneNumber = "-1";
	}
	if (isset($_GET['chargeNow'])) {
		$chargeNow = $_GET['chargeNow'];
	}
	else {
		$chargeNow = 0;
	}
	$companyName = getCompanyName();

	// Create connection
	$conn = new mysqli($servername, $username, $password, $database);
	// Check connection
	if ($conn->connect_error) {
	    die("Connection failed: " . $conn->connect_error);
	}

	// print_r($_GET);
	if (isset($_GET['version'])) {
		$version = $_GET['version'];
		if ($version == "1.1") {
			// print("V1.1<br>");
			if ($phoneNumber >= 0) {
				// print("======================<br>");
				// print("     Phone Number     <br>");
				// print("======================<br>");
				$userExists = checkCustomerPhone($conn, $phoneNumber);
				$pinExists = checkPIN_exists($conn, $phoneNumber);
				if($userExists) {
					// Epona
				}
				if($pinExists) {
					// Epona
				}
				// Epona
				if ($userExists & $pinExists) {
					if (isset($_GET['PIN'])) {
						$PIN = $_GET['PIN'];
						if (validatePin($conn, $phoneNumber, $PIN)) { 													// User's phone number and PIN have been validated
							// Epona
							// Charge the user
							$basePrice = 2.99;				
							$chargeAmt = getPaymentAmount($conn, $companyName, $basePrice);
							$userToken = getPaymentToken_customer ($conn, $phoneNumber);
					        chargeCustomer($chargeAmt, $companyName, $userToken, $conn);

							// Ocarina
							// // Is the user subscribed?
							// if (!checkSubscriber_query($conn, $phoneNumber, $company, $last4, $firstName, $lastName)) {		// User not subscribed
							// 	// Charge the user by the company subsidy rules
							// 	print("notSubscribed");
							// }
							// else {
							// 	// Charge the user by the subscription rules
							// 	print("subscribed");
							// }
						}
						else {
							print("PIN is incorrect");
							// Epona
							// Notify the user PIN was incorrect (indicate number of times)
							// If 3 failed times, text user and request Text with PIN reset (email to me)
							// Request user PIN & PIN validation
						}
					}
					else {
						print("PIN not supplied");
						// Not reachable logic step?
					}
				}
				else if ($userExists) {
					print("Needs PIN");
					// Only for site reworks
					// Epona
				}
				else if ((!$userExists) AND (!$pinExists)) {
					print("Needs registration");																			// Register the user
					// Request user PIN & PIN validation
					// Request credit card swipe
					// Epona
				}
				// print("Set as 1.1");
				
				// First revision to include card reader
			}
			else {
				// Verify user by firstName, lastName, last4, expMo, expYr, brand, funding

				$ccInfo = rawurldecode($_GET['ccInfo']);
				$ccInfo_e = explodeCCInfo($ccInfo, $parser);

				// print($ccInfo_e['firstName_1']."<br>");
				// print($ccInfo_e['lastName_1']."<br>");
				// print($ccInfo_e['creditCard_1']."<br>");
				// print($ccInfo_e['creditCard_2']."<br>");
				// print($ccInfo_e['expMonth_1']." = ".$ccInfo_e['expMonth_2']."<br>");
				// print($ccInfo_e['expYear_1']." = ".$ccInfo_e['expYear_2']."<br>");
				// print("----------------------<br>");

				// Create Card Token
				// Check against information in database
				// if not present, create (earlier...just create)

				$cardToken = create_cardToken($ccInfo_e);
				$userToken = cardExists_inDb($cardToken, $conn);
				if ($userToken !=  "error") {
					// Epona Epona Epona Epona Epona Epona Epona Epona -- works
					$basePrice = 2.99;				
					$chargeAmt = getPaymentAmount($conn, $companyName, $basePrice);

					if ($chargeNow == 1) {
			        	chargeCustomer($chargeAmt, $companyName, $userToken, $conn);
			        }
			        // Epona Epona Epona Epona Epona Epona Epona Epona -- works
				}
				else {
					print("User not created,".$cardToken['id'].",".$ccInfo_e['firstName_1'].",".$ccInfo_e['lastName_1']);  // v1.0 - "Customer not created"
					// Need the user to enter : Phone Number & PIN
					// Epona
				}

				// Date Verification
			    $currMonth = intval(date('m')); // 1-2 digit version
			    $currYear = intval(date('Y'));  // 4-digit version
			}


		}
	}
	else { // Revision 1.0
		$version = "1.0";
	}
	if ($version == "1.0") {

		$paymentToken = getPaymentToken_customer ($conn, $phoneNumber);

		if ($paymentToken != "error"){

			$basePrice = 2.99;				
			$chargeAmt = getPaymentAmount($conn, $companyName, $basePrice);

	        chargeCustomer($chargeAmt, $companyName, $paymentToken, $conn);
	    }
	    else {
			// Old Registration
			sendText_paymentInfo($phoneNumber);
		}
	}
	$conn->close();

	
?>