<?php

    function validatePin(mysqli $conn, $phoneNumber, $PIN) {

        // $phoneNumber = 9377761657;
        // $password = 2203;

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

        // For brevity, code to establish a database connection has been left out
        $sql = '
        SELECT
            pinHash
        FROM
            pinCode
        WHERE
            phoneNumber = '.$phoneNumber.';';

        // Fetch Hash Value
        $hash = $conn->query($sql)->fetch_object()->pinHash;
        $_SESSION['pinHash'] = $hash;
        
        // Hashing the password with its hash as the salt returns the same hash
        $newHash = crypt($PIN, $hash);

        // print($PIN ."<br>");
        // print($hash."<br>");
        // print($newHash."<br>");

        if ( hash_equals($hash, $newHash) ) {
            return true;
        } else {
            return false;
        }
    }

    function checkPIN_exists ($conn, $phoneNumber) {
        $sql = '
        SELECT
            pinHash
        FROM
            pinCode
        WHERE
            phoneNumber = '.$phoneNumber.';';

        // Fetch Hash Value
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            return true;
        } else {
            return false;
        }
    }

    function createPIN ($conn, $phoneNumber, $password) {
        // A higher "cost" is more secure but consumes more processing power
        $cost = 10;

        // Create a random salt
        $salt = strtr(base64_encode(mcrypt_create_iv(16, MCRYPT_DEV_URANDOM)), '+', '.');

        // Prefix information about the hash so PHP knows how to verify it later.
        // "$2a$" Means we're using the Blowfish algorithm. The following two digits are the cost parameter.
        $salt = sprintf("$2a$%02d$", $cost) . $salt;

        // Hash the password with the salt
        $hash = crypt($password, $salt);

        $sql = '
        INSERT INTO
            pinCode
            (phoneNumber, pinHash)
        VALUES
            ('.$phoneNumber.', "'.$hash.'");';

        // Insert into Hash Table
        $conn->query($sql);
        return true;
    }

    function checkCustomerPhone ($conn, $phoneNumber) {

        $sql = "SELECT
                    *
                FROM
                    userInfo
                WHERE
                    customerId =
                    (
                        SELECT
                            MAX(customerId)
                        FROM
                            userInfo
                        WHERE
                            phoneNumber = ".$phoneNumber."
                    )
                ;";

        $result = $conn->query($sql);
        if ($result->num_rows > 0) {
            return true;
        }
        else {
            return false;
        }
    }

    function getPaymentToken_customer ($conn, $phoneNumber) {

        $sql = "SELECT
                    *
                FROM
                    userInfo
                WHERE
                    customerId =
                    (
                        SELECT
                            MAX(customerId)
                        FROM
                            userInfo
                        WHERE
                            phoneNumber = ".$phoneNumber."
                    )
                ;";

        $result = $conn->query($sql);
        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                return $row['token'];
            }
            return "error";
        }
        else {
            return "error";
        }
    }

    function getPaymentToken_ccInfo () {
        // Epona
        $sql = "";
    }

    // phoneNumber, firstName, lastName, last4, expMonth, expYear <-- All come from "userInfo"
    // thresholdConfig <-- [thresholdConfig] (thresholdConfig)
    // verify:  PIN <-- [pinCode] (pinHash)
    // machineId <-- [machineInfo] (machineId)
    // machineId is used to match the company name for the subscription validation [machineInfo table]

    // search userInfo for the record
    // if customer has not presence in userInfo --> create new customer & subscription      {progression1} -> {progression2}
    // elseif customerId in userInfo / not in subscription --> create new subscription      {progression2}
    // else --> proceed                                                                     {progression3}
    // when time hits renew date

    function checkSubscriber_query($conn, $phoneNumber, $company, $last4, $firstName, $lastName) {
        $sql = "SELECT
                    *
                FROM
                    userSubscription_details
                WHERE
                    customerId = 
                    (
                        SELECT
                            customerId
                        FROM
                            userInfo
                        WHERE
                            (firstName = '".$firstName."'')
                            AND (lastName = '".$lastName."'')
                            AND (last4 = ".$last4.")
                            AND (phoneNumber = ".$phoneNumber.")
                    )
                ;";
        $result = $conn->query($sql);
        if ($result->num_rows > 0) {
            return $result;
        }
        else {
            return false;
        }
    }

    function getCompanyName() {
        if(isset($_GET['companyName'])) {
            $companyName = $_GET['companyName'];
        } else {
            $companyName = "";
        }
        return $companyName;
    }

    function getStipend_query($companyName) {
        $sql = 'SELECT
                    *
                FROM
                    company_subsidyStipend
                WHERE
                    company = "'.$companyName.'"
                ;';
        return $sql;
    }

    function getPaymentAmount($conn, $companyName, $basePrice) {

        $sql = 'SELECT
                    *
                FROM
                    company_subsidyStipend
                WHERE
                    company = "'.$companyName.'"
                ;';
        
        $subsidyStipend_result = $conn->query($sql);

        if ($subsidyStipend_result->num_rows > 0) {
            while($sub_row = $subsidyStipend_result->fetch_assoc()) {
                $company = ($sub_row["company"]);
                $threshold1 = ($sub_row["threshold1"]);
                $threshold2 = ($sub_row["threshold2"]);
                $price1 = ($sub_row["price1"]);
                $price2 = ($sub_row["price2"]);
            }

            // MARK: Subsidy Section
            if ($threshold1 == 0) {
                $chargeAmt = $price1;
            }
            // } else {
            //  $chargeAmt = $price1
            // }
        } else {
            $chargeAmt = $basePrice;
        }
        return $chargeAmt;
    }

    function chargeCustomer($chargeAmt, $companyName, $paymentToken, $conn) {
        \Stripe\Stripe::setApiKey("sk_live_3p3kLuWKmiz6rG3hFXLcyyTJ");
        $charge = \Stripe\Charge::create(array(
                                                "amount" => $chargeAmt * 100, // $2.99 this time
                                                "currency" => "usd",
                                                "customer" => $paymentToken
                                              ));
        $sql = '
                UPDATE
                    userInfo
                SET
                    company = "'.$companyName.'"
                WHERE
                    token = "'.$paymentToken.'";';
        $conn->query($sql);
        print str_replace("Stripe\\Charge JSON: ","",$charge);
    }

    function newSubscriber($subscribeAmt, $phoneNumber, $paymentToken, $conn, $subscriptionPrice) {
        \Stripe\Stripe::setApiKey("sk_live_3p3kLuWKmiz6rG3hFXLcyyTJ");
        $charge = \Stripe\Charge::create(array(
                                                "amount" => ($subscribeAmt + $subscriptionPrice) * 100, // $2.99 this time
                                                "currency" => "usd",
                                                "customer" => $paymentToken
                                              ));
        $sql = '
                INSERT INTO
                    subscriberInfo
                    (phoneNumber, subscribeAmt, subscriptionPrice, enrollDate, renewDate, active)
                VALUES
                    ('.$phoneNumber.','.$subscribeAmt.','.$subscriptionPrice.',NOW(),NOW(),1)
                ON DUPLICATE KEY UPDATE
                    subscribeAmt = '.$subscribeAmt.', subscriptionPrice = '.$subscriptionPrice.', renewDate = NOW(), active = 1;';
        $conn->query($sql);
        print str_replace("Stripe\\Charge JSON: ","",$charge);
    }

    function getSubscriptionPrice($phoneNumber, $chargeAmt, $conn) {
         $sql = 'SELECT
                    *
                FROM
                    subscriberInfo
                WHERE
                    phoneNumber = "'.$phoneNumber.'"
                ;';
        
        $subscriber_result = $conn->query($sql);

        if ($subscriber_result->num_rows > 0) {
            while($sub_row = $subscriber_result->fetch_assoc()) {
                $active = ($sub_row["active"]);
                if ($active == 1) {
                    $chargeAmt = ($sub_row["subscriptionPrice"]);
                    // here we need to charge the user the monthly fee during their next smoothie purchase??
                }
            }
        } else {
            $chargeAmt = $chargeAmt;
        }
        return $chargeAmt;
    }

    use Twilio\Rest\Client; 
    function sendText_paymentInfo($phoneNumber) {

        print("Customer not created");
        $sid = 'ACce96ececbb8285c903180db35796f65b';
        $token = '8b4c29703aaeb3797b0d61e4d7cb5d6d';
        $client = new Client($sid, $token);

        $twilioDesitination = "+1".$phoneNumber;
        // $rawNumber = "9377761657";
        // $twilioDesitination = "+1".$rawNumber;

        $client->messages->create(
            $twilioDesitination,
            array(
                'from' => '+15623625363',
                'body' => 'Welcome to SnackBlend :).  Enter your payment information into Stripe: https://io.calmlee.com/StripePaymentCollection.php?phoneNumber='.$phoneNumber
            )
        );
    }

    function explodeCCInfo($ccInfo, $parser) {
        $cardLines = explode("?;",trim($ccInfo));
        
        // Credit Card Track 1
        $lineItems_0 = explode("^",trim($cardLines[0]));

        $nameData = $lineItems_0[1];
        if (strpos($nameData, '/') !== false) {
            $nameDatas = explode("/",trim($nameData));
            $nameData = $nameDatas[1]." ".$nameDatas[0];
        }

        $nameArr = $parser->parse_name($nameData);

        $creditCard_1 = (int)substr($lineItems_0[0],2);
        $expMonth_1 = (int)substr($lineItems_0[2],2,2);
        $expYear_1 = (int)substr($lineItems_0[2],0,2);
        $firstName_1 = $nameArr["fname"];
        $lastName_1 = $nameArr["lname"];

        // Credit Card Track 2
        if (count($cardLines) == 2) {
            // Make sure that the nuimber of card lines == 1 (max = 3, but this dictates how to trim this one)
            $lineItems_1 = explode("=",explode("?",trim($cardLines[1]))[0]);

            $creditCard_2 = (int)$lineItems_1[0];
            $expMonth_2 = (int)substr($lineItems_1[1],2,2);
            $expYear_2 = (int)substr($lineItems_1[1],0,2);
        }
        else {
            $creditCard_2 = 0;
            $expMonth_2 = 0;
            $expYear_2 = 0;
        }

        $ccInfo = array();
        $ccInfo['creditCard_1'] = $creditCard_1;
        $ccInfo['expMonth_1'] = $expMonth_1;
        $ccInfo['expYear_1'] = $expYear_1 + 2000;
        $ccInfo['firstName_1'] = $firstName_1;
        $ccInfo['lastName_1'] = $lastName_1;
        $ccInfo['creditCard_2'] = $creditCard_2;
        $ccInfo['expMonth_2'] = $expMonth_2;
        $ccInfo['expYear_2'] = $expYear_2 + 2000;
        return $ccInfo;
    }

    function create_cardToken ($ccInfo) {
        $currMonth = intval(date('m')); // 1-2 digit version
        $currYear = intval(date('Y'));  // 4-digit version

        // Date verification
        if (($ccInfo['expYear_1'] > $currYear) || (($ccInfo['expYear_1'] == $currYear) && ($ccInfo['expMonth_1'] >= $currMonth))) {
            // Epona - Switch key to live at deployment <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            \Stripe\Stripe::setApiKey("sk_live_3p3kLuWKmiz6rG3hFXLcyyTJ");

            $result = \Stripe\Token::create(array(
                            "card" => array(
                                "name" => $ccInfo['firstName_1']." ".$ccInfo['lastName_1'],
                                "number" => $ccInfo['creditCard_1'],
                                "exp_month" => (int)$ccInfo['expMonth_1'],
                                "exp_year" => (int)$ccInfo['expYear_1'] //,
                    // "cvc" => "314" <-- Removed to avoid using CVC.  This is required in Europe.
                    // Attempt the charge without, but if failed, make sure that the 
              )
            ))->__toJSON();
            return json_decode($result, true);
        }
    }

    function cardExists_inDb ($cardToken, $conn) {
        $brand = $cardToken['card']['brand'];
        $country = $cardToken['card']['country'];
        $exp_month = $cardToken['card']['exp_month'];
        $exp_year = $cardToken['card']['exp_year'];
        $funding = $cardToken['card']['funding'];
        $last4 = $cardToken['card']['last4'];

        $name = $cardToken['card']['name'];
        $name_exploded = explode(" ", $name);
        $firstName = $name_exploded[0];
        $lastName = $name_exploded[1];

        $sql = 'SELECT
                    *
                FROM
                    userInfo
                WHERE
                    customerId =
                    (
                        SELECT
                            MAX(customerId)
                        FROM
                            userInfo
                        WHERE
                            brand = "'.$brand.'" AND
                            expMonth = "'.$exp_month.'" AND
                            expYear = "'.$exp_year.'" AND
                            funding = "'.$funding.'" AND
                            last4 = "'.$last4.'" 
                    )
                    ;';
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                return $row['token'];
            }
            return "error";
        } else {
            return "error";
        }
    }

    function getUserPhoneNumber ($cardToken, $conn) {
        $brand = $cardToken['card']['brand'];
        $country = $cardToken['card']['country'];
        $exp_month = $cardToken['card']['exp_month'];
        $exp_year = $cardToken['card']['exp_year'];
        $funding = $cardToken['card']['funding'];
        $last4 = $cardToken['card']['last4'];

        $name = $cardToken['card']['name'];
        $name_exploded = explode(" ", $name);
        $firstName = $name_exploded[0];
        $lastName = $name_exploded[1];

        $sql = 'SELECT
                    *
                FROM
                    userInfo
                WHERE
                    customerId =
                    (
                        SELECT
                            MAX(customerId)
                        FROM
                            userInfo
                        WHERE
                            brand = "'.$brand.'" AND
                            expMonth = "'.$exp_month.'" AND
                            expYear = "'.$exp_year.'" AND
                            funding = "'.$funding.'" AND
                            last4 = "'.$last4.'" 
                    )
                    ;';
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                return $row['phoneNumber'];
            }
            return -1;
        } else {
            return -1;
        }
    }

    // function getPaymentAmount_new ($conn, $phoneNumber, $companyName, $basePrice) {
        
    //     $sql = "SELECT
    //                 *
    //             FROM
    //                 userInfo
    //             WHERE
    //                 customerId =
    //                 (
    //                     SELECT
    //                         MAX(customerId)
    //                     FROM
    //                         userInfo
    //                     WHERE
    //                         phoneNumber = ".$phoneNumber."
    //                 )
    //             ;";
    //     $result = $conn->query($sql);

    //     if ($result->num_rows > 0) {
    //         while($row = $result->fetch_assoc()) {
    //             $customerId = $row['customerId'];
    //         }
    //     }

    //     $sql = 'SELECT
    //                 *
    //             FROM
    //                 discount_companySpecific
    //             WHERE
    //                 discountId =
    //                             (
    //                                 SELECT
    //                                     MAX(discountId)
    //                                 FROM
    //                                     discount_companySpecific
    //                                 WHERE
    //                                 customerId = '.$customerId.'
    //                             );';
    //     $result = $conn->query($sql);

    //     $discount = 0;
    //     if ($result->num_rows > 0) {
    //         while($row = $result->fetch_assoc()) {
    //             $discount = $row['smoothiePrice'];
    //             $discountId = $row['discountId'];
    //         }


    //     // Check for a discount first (soon to be check for free smoothie first, then check for discount, then check for subsidy, then regular)
    //     if ($discount != 0) {
    //         $chargeAmt = $basePrice - $discount;

    //         $sql = 'DELETE FROM
    //                     discount_companySpecific
    //                 WHERE
    //                     discountId = '.$discountId.';';
    //         $delete_result = $conn->query($sql);
    //     }
    //     else {
    //         $sql = 'SELECT
    //                 *
    //             FROM
    //                 company_subsidyStipend
    //             WHERE
    //                 company = "'.$companyName.'"
    //             ;';
        
    //         $subsidyStipend_result = $conn->query($sql);
            
    //         if ($subsidyStipend_result->num_rows > 0) {
    //             while($sub_row = $subsidyStipend_result->fetch_assoc()) {
    //                 $company = ($sub_row["company"]);
    //                 $threshold1 = ($sub_row["threshold1"]);
    //                 $threshold2 = ($sub_row["threshold2"]);
    //                 $price1 = ($sub_row["price1"]);
    //                 $price2 = ($sub_row["price2"]);
    //             }

    //             // MARK: Subsidy Section
    //             if ($threshold1 == 0) {
    //                 $chargeAmt = $price1;
    //             }
    //         } else {
    //             $chargeAmt = $basePrice;
    //         }
    //     }
    //     return $chargeAmt;
    // }
?>