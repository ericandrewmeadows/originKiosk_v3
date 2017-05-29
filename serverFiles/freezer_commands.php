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
    $freezerState = $_GET['freezerState'];
    $freezerTemp = $_GET['freezerTemp'];
    $freezerUpdateTime = time();

	// CREATE TABLE freezerInfo (
 //        machineId MEDIUMINT,
 //        freezerUpdateTime BIGINT UNSIGNED,
 //        freezerState TINYINT NOT NULL,
 //        freezerTemp FLOAT(4,2),
 //        PRIMARY KEY ( machineId )
 //    );
 //    CREATE TABLE freezerState (
 //        freezerStateId TINYINT NOT NULL AUTO_INCREMENT,
 //        freezerState VARCHAR(10),
 //        UNIQUE KEY freezerState ( freezerState ),
 //        PRIMARY KEY ( freezerStateId )
 //    );

    $sql = '
            INSERT IGNORE INTO
                freezerState
                ( freezerState )
            VALUES
                ( "'.$freezerState.'" )
            ;';
    $conn->query($sql);

    $sql = '
            SELECT
                *
            FROM
                freezerState
            WHERE
                freezerState = "'.$freezerState.'"
            ;';
    $freezerStateId = $conn->query($sql)->fetch_object()->freezerStateId;

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
                freezerInfo
                ( machineId, freezerStateId, freezerTemp, freezerUpdateTime )
            VALUES
            	( '.$machineId.', '.$freezerStateId.', '.$freezerTemp.', '.$freezerUpdateTime.' )
            ON DUPLICATE KEY UPDATE
                freezerStateId = '.$freezerStateId.',
                freezerTemp = '.$freezerTemp.',
                freezerUpdateTime = '.$freezerUpdateTime.'
            ;';
    print($sql);
    $conn->query($sql);
?>