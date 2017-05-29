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

	$lockMessage = $_GET["lockMessage"];
	$companyName = $_GET['companyName'];

	// CREATE TABLE lockMessages (
	//     lockId BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	//     machineId MEDIUMINT NOT NULL,
	//     lockMessageId TINYINT UNSIGNED NOT NULL,
	//     lockMessageTime MEDIUMINT UNSIGNED,
	//     PRIMARY KEY ( lockId )
	// );

	// CREATE TABLE lockMessages_details (
	//     lockMessageId TINYINT UNSIGNED NOT NULL,
	//     lockMessage VARCHAR(20) NOT NULL,
	//     UNIQUE KEY lockMessage ( lockMessage ),
	//     PRIMARY KEY ( lockMessageId ) 
	// );

	$sql = 'INSERT IGNORE INTO
                lockMessages_details
                ( lockMessage )
            VALUES
            	( "'.$lockMessage.'" )
            ;';
    $conn->query($sql);

    $sql = 'SELECT
                *
            FROM
                lockMessages_details
            WHERE
                lockMessage = "'.$lockMessage.'"
            ;';
    $lockMessageId = $conn->query($sql)->fetch_object()->lockMessageId;

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

    $lockMessageTime = time();

    $sql = 'INSERT INTO
    			lockMessages
    			( machineId, lockMessageId, lockMessageTime )
    		VALUES
    			( '.$machineId.', '.$lockMessageId.', '.$lockMessageTime.' )
    		;';
    $conn->query($sql);
?>