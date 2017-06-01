<?php
	// MySQL Connection
	$servername = "localhost";
	$username = "root";
	$password = "root";
	$database = "snackblendKiosk";

	$conn = new mysqli($servername, $username, $password, $database);
	// Check connection
	if ($conn->connect_error) {
	    die("Connection failed: " . $conn->connect_error);
	}

	$companyName = $_GET['companyName'];

    // CREATE TABLE freezerSettings (
    //     freezerSettingsId MEDIUMINT NOT NULL AUTO_INCREMENT,
    //     machineId MEDIUMINT NOT NULL,
    //     freezerInterval INT NOT NULL,
    //     lowTemp FLOAT(4,2) NOT NULL,
    //     highTemp FLOAT(4,2) NOT NULL,
    //     UNIQUE KEY ( machineId ),
    //     PRIMARY KEY ( freezerSettingsId )
    // );
    $sql = 'SELECT
                *
            FROM
                machineInfo
            WHERE
                company = "'.$companyName.'"
            ORDER BY
                machineId DESC
            LIMIT 1;';
    $machineId_results = $conn->query($sql);
    if ($machineId_results->num_rows > 0) {
        $machineId = $machineId_results->fetch_object()->machineId;
    }
    else {
        $machineId = "0";
    }

    $sql = '
            SELECT
                *
            FROM
                subscriptionInfo
            WHERE
                machineId = '.$machineId.'
            ;';
    $siteSpecific_subscriptionSettings = $conn->query($sql);


    if ( $siteSpecific_subscriptionSettings->num_rows > 0 ) {
        while($subscriptionSetting = $siteSpecific_subscriptionSettings->fetch_assoc()) {
            // Smoothie Counts
            $smoothieCount_1 = $subscriptionSetting["subSmoothie1_count"];
            $smoothieCount_2 = $subscriptionSetting["subSmoothie2_count"];
            $smoothieCount_3 = $subscriptionSetting["subSmoothie3_count"];

            // Smoothie Prices
            $smoothiePrice_1 = $subscriptionSetting["subSmoothie1_price"];
            $smoothiePrice_2 = $subscriptionSetting["subSmoothie2_price"];
            $smoothiePrice_3 = $subscriptionSetting["subSmoothie3_price"];
        }
        // Information String
        $smoothieString = '<SUBSCRIPTION>'.$smoothieCount_1.','.$smoothiePrice_1.','
                                          .$smoothieCount_2.','.$smoothiePrice_2.','
                                          .$smoothieCount_3.','.$smoothiePrice_3.','.'</SUBSCRIPTION>';
    }
    else {
        $smoothieString = "<SUBSCRIPTION></SUBSCRIPTION>";
    }

    // Only non-abstracted database
    $sql = '
            SELECT
                subsidyStipendId, CAST(employeeThresh AS UNSIGNED INTEGER) AS employeeThresh, thresholdConfig,
                threshold1, price1, threshold2, price2

            FROM
                company_subsidyStipend
            WHERE
                company = "'.$companyName.'"
            ;';
    $siteSpecific_priceSettings = $conn->query($sql);

    $sql = '
            SELECT
                subsidyStipendId, CAST(employeeThresh AS UNSIGNED INTEGER) AS employeeThresh, thresholdConfig,
                threshold1, price1, threshold2, price2
            FROM
                company_subsidyStipend
            WHERE
                company = "Default"
            ;';
    $global_priceSettings = $conn->query($sql);

    if ( $siteSpecific_priceSettings->num_rows > 0 ) {
        $priceSettings = $siteSpecific_priceSettings;
    }
    else {
        $priceSettings = $global_priceSettings;
    }

    if ( $priceSettings->num_rows > 0 ) {
        while($priceSetting = $priceSettings->fetch_assoc()) {
            // Get relevant variables
            $employeeThresh = $priceSetting["employeeThresh"];
            $thresholdConfig = $priceSetting["thresholdConfig"];
            $threshold1 = $priceSetting["threshold1"];
            $price1 = $priceSetting["price1"];
            $threshold2 = $priceSetting["threshold2"];
            $price2 = $priceSetting["price2"];
        }
        $smoothieString .= "<PRICE>".$employeeThresh.",".$thresholdConfig.","
                                    .$threshold1.",".$price1.","
                                    .$threshold2.",".$price2."</PRICE>";
    }
    else {
        $smoothieString = "<PRICE></PRICE>";
    }
    print( $smoothieString );
    $conn->close();
?>