<body>
<!-- <?php
    parse_str($_SERVER['QUERY_STRING']);
    // $phoneNumber now contains the phone number of the user
?> -->

<!DOCTYPE html><!-- This site was created in Webflow. http://www.webflow.com--><!-- Last Published: Mon Mar 06 2017 20:37:42 GMT+0000 (UTC) -->

<html data-wf-domain="payments-f6ae9b.webflow.io" data-wf-page="58b710cff73382d401f19b72" data-wf-site="58b710cff73382d401f19b71"><head><meta charset="utf-8"><title>Payments</title><meta content="width=device-width, initial-scale=1" name="viewport"><meta content="Webflow" name="generator"><link href="https://daks2k3a4ib2z.cloudfront.net/58b710cff73382d401f19b71/css/payments-f6ae9b.webflow.1d982b17d.css" rel="stylesheet" type="text/css"><script src="https://daks2k3a4ib2z.cloudfront.net/0globals/modernizr-2.7.1.js" type="text/javascript"></script><link href="https://daks2k3a4ib2z.cloudfront.net/img/favicon.ico" rel="shortcut icon" type="image/x-icon"><link href="https://daks2k3a4ib2z.cloudfront.net/img/webclip.png" rel="apple-touch-icon"></head>


<?php include 'test.php';?>
<div><div class="w-container"><h1 class="simpletitle">User Registration</h1></div></div><div class="entryform"><div class="w-form"><form action="http://35.163.38.99/paymentPosting.php" data-name="Test Form" id="wf-form-Test-Form" method="post" name="wf-form-Test-Form"><label for="name">Name:</label><input class="w-input" data-name="Name" id="name" maxlength="256" name="name" placeholder="Enter your name" type="text">

<label for="phoneNumber">Phone Number:</label><input class="w-input" data-name="Phone Number" id="phoneNumber" maxlength="10" name="Phone-Number" placeholder="Enter Your Phone Number" required="required" type="text" value="<?php echo $phoneNumber; ?>">

<div class="stripepayment w-embed w-script"><form action="" method="POST">
  <script
    src="https://checkout.stripe.com/checkout.js" class="stripe-button" align="center"
    data-key="pk_live_20THiOzLAF5QMPXHWf2OmMW5"
    data-amount="0"
    data-name="SnackBlend"
    data-email="<?php echo 'noreply'.$phoneNumber.'@snackblend.com'; ?>"
    data-description="Widget"
    data-image="https://s3.amazonaws.com/stripe-uploads/acct_18QouaFw6cx1Q05Lmerchant-icon-1467259981777-AppIcon_180x180.png"
    data-locale="auto"
  </script>
</form></div></form><div class="w-form-done"><div>Thank you! Your submission has been received!</div></div><div class="w-form-fail"><div>Oops! Something went wrong while submitting the form</div></div></div></div><script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js" type="text/javascript"></script>
<script src="https://daks2k3a4ib2z.cloudfront.net/58b710cff73382d401f19b71/js/webflow.29495af5d.js" type="text/javascript"></script>
<!--[if lte IE 9]><script src="//cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif]-->
</body></html>
