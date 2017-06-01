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
    $keepAliveTime = time();

	// DROP TABLE IF EXISTS keepAlive;
 //    CREATE TABLE keepAlive (
 //        machineId MEDIUMINT NOT NULL,
 //        keepAliveTime MEDIUMINT UNSIGNED,
 //        PRIMARY KEY ( machineId )
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

	$sql = 'INSERT INTO
                keepAlive
                ( machineId, keepAliveTime )
            VALUES
            	( '.$machineId.', '.$keepAliveTime.' )
            ON DUPLICATE KEY UPDATE
                keepAliveTime = '.$keepAliveTime.'
            ;';
    $conn->query($sql);
    $conn->close();
?>