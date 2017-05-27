<?php
	require 'vendor/autoload.php';
	require 'paymentFunctions.php';
	require_once 'nameParser.php';
	$parser = new FullNameParser();
	require_once '/home/ubuntu/vendor/autoload.php'; // Loads the library

	$phoneNumber = 4154659131;
	// $phoneNumber = 9377761657;
	
	$charge = '{ "id": "ch_1AO9fmFw6cx1Q05LNtPNzPMQ", "object": "charge", "amount": 50, "amount_refunded": 0, "application": null, "application_fee": null, "balance_transaction": "txn_1AO9fnFw6cx1Q05LKvcAklYD", "captured": true, "created": 1495909798, "currency": "usd", "customer": "cus_AizXwPN6XGovZW", "description": null, "destination": null, "dispute": null, "failure_code": null, "failure_message": null, "fraud_details": [ ], "invoice": null, "livemode": true, "metadata": [ ], "on_behalf_of": null, "order": null, "outcome": { "network_status": "approved_by_network", "reason": null, "risk_level": "normal", "seller_message": "Payment complete.", "type": "authorized" }, "paid": true, "receipt_email": "9377761657@snackblend.com", "receipt_number": "1142-5845", "refunded": false, "refunds": { "object": "list", "data": [ ], "has_more": false, "total_count": 0, "url": "\/v1\/charges\/ch_1AO9fmFw6cx1Q05LNtPNzPMQ\/refunds" }, "review": null, "shipping": null, "source": { "id": "card_1ANXYOFw6cx1Q05L7tMJMQlu", "object": "card", "address_city": null, "address_country": null, "address_line1": null, "address_line1_check": null, "address_line2": null, "address_state": null, "address_zip": null, "address_zip_check": null, "brand": "Visa", "country": "US", "customer": "cus_AizXwPN6XGovZW", "cvc_check": null, "dynamic_last4": null, "exp_month": 10, "exp_year": 2019, "fingerprint": "1Oicqecl7OPL7eRv", "funding": "debit", "last4": "4930", "metadata": [ ], "name": "Eric Meadows", "tokenization_method": null }, "source_transfer": null, "statement_descriptor": null, "status": "succeeded", "transfer_group": null }';

	sendReceipt($phoneNumber, $charge);
?>