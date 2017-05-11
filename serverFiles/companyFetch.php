<?php
    $servername = "localhost";
    $username = "root";
    $password = "root";
    $database = "snackblendKiosk";
    $table = "deliveryInfo";

    // Create connection
    $conn = new mysqli($servername, $username, $password, $database);
    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    // Selects the LATEST customer information from a given phone number; only 1 row will be output.
    $companyArray = array();
    $sql = "SELECT
                *
            FROM
                machineInfo
            WHERE
                paymentSystem > 0
            GROUP BY 
                company;";

    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
            array_push($companyArray, $row['company']);
        }
    }

    echo json_encode($companyArray);

    $conn->close();
?>