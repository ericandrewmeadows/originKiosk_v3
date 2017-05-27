<?php
	$phoneNumber = '9377761657';
	$PIN = '5815';

	// Create connection
	$servername = "localhost";
	$username = "root";
	$password = "root";
	$database = "snackblendKiosk";

	// Compare Hashes
	if(!function_exists('hash_equals'))
	{
	    function hash_equals($str1, $str2)
	    {
	        if(strlen($str1) != strlen($str2))
	        {
	            return false;
	        }
	        else
	        {
	            $res = $str1 ^ $str2;
	            $ret = 0;
	            for($i = strlen($res) - 1; $i >= 0; $i--)
	            {
	                $ret |= ord($res[$i]);
	            }
	            return !$ret;
	        }
	    }
	}

	// Create connection
	$conn = new mysqli($servername, $username, $password, $database);

	// Check connection
	if ($conn->connect_error) {
	    die("Connection failed: " . $conn->connect_error);
	}

	// A higher "cost" is more secure but consumes more processing power
	$cost = 10;

	// Create a random salt
	$salt = strtr(base64_encode(mcrypt_create_iv(16, MCRYPT_DEV_URANDOM)), '+', '.');

	// Prefix information about the hash so PHP knows how to verify it later.
	// "$2a$" Means we're using the Blowfish algorithm. The following two digits are the cost parameter.
	$salt = sprintf("$2a$%02d$", $cost) . $salt;

	// Value:
	// $2a$10$eImiTXuWVxfM37uY4JANjQ==

	// Hash the password with the salt
	$hash = crypt($PIN, $salt);

	// Value:
	// $2a$10$eImiTXuWVxfM37uY4JANjOL.oTxqp7WylW7FCzx2Lc7VLmdJIddZq

	// $sql = '
	// UPDATE
	// 	pinCode
	// SET
	// 	pinHash = "'.$hash.'"
	// WHERE
	// 	phoneNumber = '.$phoneNumber.';';
	$sql = '
	INSERT INTO
		pinCode
		(phoneNumber, pinHash)
	VALUES
		('.$phoneNumber.', "'.$hash.'");';

	// Insert into Hash Table
	print($sql);
	$conn->query($sql);

	// For brevity, code to establish a database connection has been left out
	$sql = '
	SELECT
		pinHash
	FROM
		pinCode
	WHERE
		phoneNumber = '.$phoneNumber.';';

	// Fetch Hash Value
	print("<br>");
	print($sql);
	$hash = $conn->query($sql)->fetch_object()->pinHash;
	$_SESSION['pinHash'] = $hash;
	print("<br><br>");


	
	// Hashing the password with its hash as the salt returns the same hash
	$newHash = crypt($PIN, $hash);
	print($hash.'<br>');
	print($newHash.'<br>');
	if ( hash_equals($hash, $newHash) ) {
	  // Ok!
		print("<br><br>OK");
	} else {
		print("<br><br>BOO...NOT WORKING");
	}
	$conn->close();
?>