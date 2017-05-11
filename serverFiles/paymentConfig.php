<?php
    $servername = "localhost";
    $username = "root";
    $password = "root";
    $database = "snackblendKiosk";
    $table = "company_subsidyStipend";

    $company = $_GET["company"];

    // Create connection
    $conn = new mysqli($servername, $username, $password, $database);
    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    // Selects the LATEST customer information from a given phone number; only 1 row will be output.
    $companyArray = array();
    $sql = 'SELECT
                *
            FROM
                `'.$table.'`
            WHERE
                company = "'.$company.'"
            GROUP BY 
                company;';

    // print($sql);
    // print_r($result);
    $sth = mysqli_query($conn, $sql);

    $rows = array();
    while($r = mysqli_fetch_assoc($sth)) {
        $rows[] = $r;
    }
    print str_replace(array('[', ']'), '', htmlspecialchars(json_encode($rows), ENT_NOQUOTES));

    $conn->close();
?>