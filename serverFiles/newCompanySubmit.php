<?php
	print_r($_POST);
    print("<br><br>");

	$form_company		= $_POST['company-name'];
	$form_officeManager	= $_POST['officeManager-name'];
	$form_email			= $_POST['E-mail'];
	$form_phone			= $_POST['phone'];
	$form_shippingLine1	= $_POST['shipping-line1'];
	$form_shippingLine2 = $_POST['shipping-line2'];
	$form_shippingCity	= $_POST['shipping-city'];
	$form_shippingState	= $_POST['shipping-state'];
	$form_shippingZip	= $_POST['shipping-zip'];
	$form_billingLine1	= $_POST['billing-line1'];
	$form_billingLine2	= $_POST['billing-line2'];
	$form_billingCity	= $_POST['billing-city'];
	$form_billingState	= $_POST['billing-state'];
	$form_billingZip	= $_POST['billing-zip'];
	
	require 'vendor/autoload.php';
	// Set your secret key: remember to change this to your live secret key in production
	// See your keys here: https://dashboard.stripe.com/account/apikeys
	\Stripe\Stripe::setApiKey("sk_test_ze5Ft72xeahq59xhYqqb5BHE");

	// Token is created using Stripe.js or Checkout!
	// Get the payment token submitted by the form:
	$token = $_POST['stripeToken'];

	// Create a Customer:
	$customer = \Stripe\Customer::create(array(
	  "email" => $_POST['E-mail'],
	  "metadata" => array("Company Name" => $_POST['company-name']),
	  "source" => $token,
	));

	$charge = \Stripe\Charge::create(array(
	  "amount" => $_POST["chargeAmount"], // $3.99 this time
	  "currency" => "usd",
	  "customer" => $customer["id"]
	));

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

	// $sql = "SELECT
 //                *
 //            FROM
 //                machineInfo
 //            GROUP BY 
 //                company;";

 //    $result = $conn->query($sql);

    $sql = 'INSERT INTO
                machineInfo
                (company, stripeCustomerId, contactName, contactPhone,
                 addressLine1_shipping, addressLine2_shipping, city_shipping, state_shipping, zipCode_shipping,
                 addressLine1_billing,  addressLine2_billing,  city_billing,  state_billing,  zipCode_billing
                )
            VALUES
                ("'.$form_company.'",'
                .'"'.$customer['id'].'",'
                .'"'.$form_officeManager.'",'
                .'"'.$form_phone.'",'
                .'"'.$form_shippingLine1.'",'
                .'"'.$form_shippingLine2.'",'
                .'"'.$form_shippingCity.'",'
                .'"'.$form_shippingState.'",'
                .'"'.$form_shippingZip.'",'
                .'"'.$form_billingLine1.'",'
                .'"'.$form_billingLine2.'",'
                .'"'.$form_billingCity.'",'
                .'"'.$form_billingState.'",'
                .'"'.$form_billingZip.'");';

    print($sql);
    print("<br><br>");

	if ($conn->query($sql) === TRUE) {
        header("Location: /completedPreorder.html"); /* Redirect browser */

	    // echo "New record created successfully";
	} else {
        header("Location: /failedPreorder.html"); /* Redirect browser */
	}

	// CREATE TABLE machineInfo (
	// 	machineId MEDIUMINT NOT NULL AUTO_INCREMENT,
	// 	company TEXT,
	// 	addressLine1_shipping TEXT,
	// 	addressLine2_shipping TEXT,
	// 	city_shipping TEXT,
	// 	state_shipping CHAR(2),
	// 	zipCode_shipping MEDIUMINT,
	// 	addressLine1_billing TEXT,
	// 	addressLine2_billing TEXT,
	// 	city_billing TEXT,
	// 	state_billing CHAR(2),
	// 	zipCode_billing MEDIUMINT,
	// 	contactName TEXT,
	// 	contactEmail TEXT,
	// 	contactPhone BIGINT,
	// 	PRIMARY KEY ( machineId )
	// );

	$conn->close();

 //    header("Location: /inventoryTracking.php"); /* Redirect browser */
 //    // exit();
?>