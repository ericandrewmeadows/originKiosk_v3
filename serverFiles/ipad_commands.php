<?php
    print("\n");
    print("=============== POSTDATA ===============");
    print("\n");
    print_r($_POST);


    print("--------------- FILEDATA ---------------");
    print("\n");

    // print_r($_FILES);
    $out_filename = "temp.csv";

    if ($_FILES["file"]["size"] > 0) {

        if (move_uploaded_file($_FILES['file']['tmp_name'], $out_filename)) {
            echo "File uploaded: ".$_FILES["file"]["name"]."\n"; 
        }

    }
    
    $txt_file    = file_get_contents($out_filename);
    $rows        = explode("\n", $txt_file);
    array_shift($rows);

    $file_writtenTo = false;

    foreach($rows as $row => $data)
    {
        //get row data
        $time_data = explode(" ", $data);
        if (count($time_data) >= 2) {
            $date = $time_data[0];
            $time = $time_data[1];

            $msg_data = explode("] ", $data);
            if (count($msg_data) == 2) {
                $message = $msg_data[1];
                $outString = $date."<br>".$time."<br>".$message."\n";
                echo($outString);

                // Write the contents to the file, 
                // using the FILE_APPEND flag to append the content to the end of the file
                // and the LOCK_EX flag to prevent anyone else writing to the file at the same time
                if ( $file_writtenTo ) {
                    file_put_contents($out_filename, $outString, FILE_APPEND | LOCK_EX);
                }
                else {
                    file_put_contents($out_filename, "", LOCK_EX);
                    $file_writtenTo = true;
                }

            }
        }

        
        // echo("\n");
    }

    print("================ FINISH ================<br>");








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

    $sql = 'LOAD DATA INFILE "detection.csv"
            INTO TABLE calldetections
            FIELDS TERMINATED BY ","
            OPTIONALLY ENCLOSED BY "\'" 
            LINES TERMINATED BY ",,,\r\n"
            IGNORE 1 LINES 
            (date, name, type, number, duration, addr, pin, city, state, country, lat, log)';

    $conn->close();

	// $companyName = $_GET['companyName'];
 //    $ipadUpdateTime = time();

	// // CREATE TABLE freezerInfo (
 // //        machineId MEDIUMINT,
 // //        freezerUpdateTime BIGINT UNSIGNED,
 // //        freezerState TINYINT NOT NULL,
 // //        freezerTemp FLOAT(4,2),
 // //        PRIMARY KEY ( machineId )
 // //    );
 // //    CREATE TABLE freezerState (
 // //        freezerStateId TINYINT NOT NULL AUTO_INCREMENT,
 // //        freezerState VARCHAR(10),
 // //        UNIQUE KEY freezerState ( freezerState ),
 // //        PRIMARY KEY ( freezerStateId )
 // //    );

 //    $sql = '
 //            INSERT IGNORE INTO
 //                freezerState
 //                ( freezerState )
 //            VALUES
 //                ( "'.$freezerState.'" )
 //            ;';
 //    $conn->query($sql);

 //    $sql = '
 //            SELECT
 //                *
 //            FROM
 //                freezerState
 //            WHERE
 //                freezerState = "'.$freezerState.'"
 //            ;';
 //    $freezerStateId = $conn->query($sql)->fetch_object()->freezerStateId;

 //    $sql = 'SELECT
 //                *
 //            FROM
 //                machineInfo
 //            WHERE
 //                company = "'.$companyName.'"
 //            ORDER BY
 //                machineId DESC
 //            LIMIT 1;';
 //    $machineId = $conn->query($sql)->fetch_object()->machineId;

	// $sql = 'INSERT INTO
 //                freezerInfo
 //                ( machineId, freezerStateId, freezerTemp, freezerUpdateTime )
 //            VALUES
 //            	( '.$machineId.', '.$freezerStateId.', '.$freezerTemp.', '.$freezerUpdateTime.' )
 //            ON DUPLICATE KEY UPDATE
 //                freezerStateId = '.$freezerStateId.',
 //                freezerTemp = '.$freezerTemp.',
 //                freezerUpdateTime = '.$freezerUpdateTime.'
 //            ;';
 //    $conn->query($sql);
 //    $conn->close();
?>