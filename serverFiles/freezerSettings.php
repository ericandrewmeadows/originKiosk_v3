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
    $machineId = $conn->query($sql)->fetch_object()->machineId;


    $sql = '
            SELECT
                *
            FROM
                freezerSettings
            WHERE
                machineId = '.$machineId.'
            ;';
    $siteSpecific_freezerSettings = $conn->query($sql);

    $sql = '
            SELECT
                *
            FROM
                freezerSettings
            WHERE
                machineId = 0
            ;';
    $global_freezerSettings = $conn->query($sql);

    if ( $siteSpecific_freezerSettings->num_rows > 0 ) {
        $freezerSettings = $siteSpecific_freezerSettings;
    }
    else {
        $freezerSettings = $global_freezerSettings;
    }

    if ( $freezerSettings->num_rows > 0 ) {
        while($freezerSetting = $freezerSettings->fetch_assoc()) {
            $freezerInterval = $freezerSetting["freezerInterval"];
            $lowTemp = $freezerSetting["lowTemp"];
            $highTemp = $freezerSetting["highTemp"];
        }
        print( "Exists;".$freezerInterval.",".$lowTemp.",".$highTemp );
    }
    else {
        print("Error;,,");
    }
    $conn->close();
    // print("User not created;".$cardToken['id'].";".$ccInfo_e['firstName_1'].";".$ccInfo_e['lastName_1']);
?>