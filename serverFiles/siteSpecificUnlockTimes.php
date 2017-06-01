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

	// CREATE TABLE siteSpecificUnlockTimes (
 //        unlockId MEDIUMINT NOT NULL AUTO_INCREMENT,
 //        machineId MEDIUMINT,
 //        startTime SMALLINT NOT NULL,
 //        endTime SMALLINT NOT NULL,
 //        PRIMARY KEY ( unlockId )
 //    );
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
                siteSpecificUnlockTimes
            WHERE
                machineId = "'.$machineId.'"
            ;';
    $siteSpecificUnlockTimes = $conn->query($sql);

    // print format:  start1,end1;start2,end2;start3,end3;
    if ($siteSpecificUnlockTimes->num_rows > 0) {
        while($siteSpecificUnlockTime = $siteSpecificUnlockTimes->fetch_assoc()) {
            $startTime = ($siteSpecificUnlockTime["startTime"]);
            $endTime = ($siteSpecificUnlockTime["endTime"]);
            print($startTime.','.$endTime.';');
        }
    } else {
        print("");
    }
    $conn->close();
    // print("User not created;".$cardToken['id'].";".$ccInfo_e['firstName_1'].";".$ccInfo_e['lastName_1']);
?>