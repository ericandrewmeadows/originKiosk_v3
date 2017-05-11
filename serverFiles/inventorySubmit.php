<?php
	print_r($_POST);
	$company = $_POST['Company'];
	$podCount = $_POST['PodCount'];
	$date = $_POST['date'];

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

	$sql = "INSERT INTO
				deliveryInfo
				(company, podCount, date)
			VALUES
				('".$company."',"
				."'".$podCount."',"
				."'".$date."');";

	print("<br><br>".$sql."<br><br>");

	if ($conn->query($sql) === TRUE) {
	    echo "New record created successfully";
	} else {
	    echo "Error: " . $sql . "<br>" . $conn->error;
	}

	$conn->close();

    header("Location: /inventoryTracking.php"); /* Redirect browser */
    // exit();
?>