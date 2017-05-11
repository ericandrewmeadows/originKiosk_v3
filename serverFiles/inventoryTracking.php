
<!--
CREATE TABLE deliveryInfo (
    deliveryId BIGINT NOT NULL AUTO_INCREMENT,
    company TEXT,
    podCount INT,
    date DATE,
    PRIMARY KEY ( deliveryId )
);
-->
<!DOCTYPE html><!-- Last Published: Thu Mar 23 2017 22:37:37 GMT+0000 (UTC) --><html data-wf-domain="calmlee-86b264b7d7b219b2c-5926153994bd7.webflow.io" data-wf-page="58d4483d45f652e8544339ff" data-wf-site="58c85d55fb3921d4300075eb"><head><meta charset="utf-8"><title>Delivery Tracking</title><meta content="Origin is the Keurig for Healthy Smoothies, starting with offices in the San Francisco Bay Area. Sign up for a free smoothie party today!" name="description"><meta content="Delivery Tracking" property="og:title"><meta content="Origin is the Keurig for Healthy Smoothies, starting with offices in the San Francisco Bay Area. Sign up for a free smoothie party today!" property="og:description"><meta content="https://1drv.ms/i/s!AmjikAKBOdz3g8sKXtTNXGaFfsk5bQ" property="og:image"><meta content="summary" name="twitter:card"><meta content="width=device-width, initial-scale=1" name="viewport">
<!-- <link href="https://daks2k3a4ib2z.cloudfront.net/58c85d55fb3921d4300075eb/css/calmlee-86b264b7d7b219b2c-5926153994bd7.webflow.05248cc07.css" rel="stylesheet" type="text/css"> -->
<link href="https://daks2k3a4ib2z.cloudfront.net/58c85d55fb3921d4300075eb/css/calmlee-86b264b7d7b219b2c-5926153994bd7.webflow.45aa31041.css" rel="stylesheet" type="text/css">
<style>
.hide {
    display: none; 
}
.datagrid table { border-collapse: collapse; text-align: left; width: 100%; } .datagrid {font: normal 12px/150% Arial, Helvetica, sans-serif; background: #fff; overflow: hidden; border: 4px solid #000000; -webkit-border-radius: 10px; -moz-border-radius: 10px; border-radius: 10px; }.datagrid table td, .datagrid table th { padding: 3px 10px; }.datagrid table thead th {background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #909090), color-stop(1, #707070) );background:-moz-linear-gradient( center top, #909090 5%, #707070 100% );filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#909090', endColorstr='#707070');background-color:#909090; color:#FFFFFF; font-size: 15px; font-weight: bold; border-left: 1px solid #000000; } .datagrid table thead th:first-child { border: none; }.datagrid table tbody td { color: #00496B; border-left: 1px solid #000000;font-size: 12px;font-weight: normal; }.datagrid table tbody .alt td { background: #D3D3D3; color: #00496B; }.datagrid table tbody td:first-child { border-left: none; }.datagrid table tbody tr:last-child td { border-bottom: none; }
</style>
<script src="https://ajax.googleapis.com/ajax/libs/webfont/1.4.7/webfont.js"></script><script type="text/javascript">WebFont.load({
  google: {
    families: ["Open Sans:300,300italic,400,400italic,600,600italic,700,700italic,800,800italic"]
  }
});</script><script src="https://daks2k3a4ib2z.cloudfront.net/0globals/modernizr-2.7.1.js" type="text/javascript"></script><link href="https://daks2k3a4ib2z.cloudfront.net/58c85d55fb3921d4300075eb/58d1f09086e6dae0160daeea_originO.jpg" rel="shortcut icon" type="image/x-icon"><link href="https://daks2k3a4ib2z.cloudfront.net/58c85d55fb3921d4300075eb/58d1f2826dd138d21600f4eb_origin_webclip.jpg" rel="apple-touch-icon"><script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-80225487-5', 'auto');
  ga('send', 'pageview');

</script></head><body class="body"><div class="header w-nav" data-animation="default" data-collapse="small" data-duration="400"><div class="flexcontainer w-container"><a class="brandlink w-nav-brand" href="/"><img alt="SnackBlend" class="logoicon" height="48" src="http://uploads.webflow.com/58c85d55fb3921d4300075eb/58c860e35f9c3ff64de04d1e_dark_logo_transparent_background.png"></a></div></div><div class="w-container"><div class="div-block w-clearfix"><img class="image-2" src="http://uploads.webflow.com/58c85d55fb3921d4300075eb/58d1c6dfeff947c0347c95a1_originInstallation_wide_L.jpg"></div></div>

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
            GROUP BY 
                company;";

    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
            array_push($companyArray, $row['company']);
        }
    }

    /*
    $arr = array(1, 2, 3, 4);
    foreach ($arr as &$value) {
        $value = $value * 2;
    }
    */
    foreach ($companyArray as &$company) {

        $sql = 'SELECT
                    *
                FROM
                    deliveryInfo
                WHERE 
                    company = "'.$company.'"
                ;';

        $result = $conn->query($sql);

        $$company = array();
        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                array_push($$company, $row);
                // print_r($row);
            }
        }
    }

    $conn->close();
    // print_r($companyArray);
?>



<div>
<div class="w-container">

<!--
Form Start
-->
<div class="w-form">
<form action="http://35.163.38.99/inventorySubmit.php" class="form" data-name="submitNewDelivery" id="wf-form-submitNewDelivery" method="post" name="wf-form-submitNewDelivery">
<div class="w-row"><div class="w-col w-col-4"><label for="Company">Company:</label>

<select class="w-select" data-name="Company" id="Company" name="Company" required="required" onchange="getval(this);">
<?php
    foreach ($companyArray as &$company) {
        echo '<option value="'.$company.'">'.$company.'</option>';
    }
?>
<option value="Add New Company">Add New Company</option>
</select>

</div><div class="w-col w-col-3"><label for="PodCount">Pods Delivered:</label><input class="w-input" data-name="PodCount" id="PodCount" maxlength="256" name="PodCount" placeholder="Enter Number of Pods Delivered" required="required" type="text"></div><div class="w-col w-col-3"><div class="w-embed"><label for="date">Date:</label>
    <input class="w-input" type="date" name="date"></div></div><div class="w-col w-col-2"><label for="PodCount" id="deliverySubmit">Submit</label><input class="submit-button w-button" data-wait="Please wait..." type="submit" value="Submit" id="deliverySubmit_l"></div></div></form><div class="w-form-done"><div>Thank you! Your submission has been received!</div></div><div class="w-form-fail"><div>Oops! Something went wrong while submitting the form</div></div>
<!--
Form End
-->

<!-- Display this when the New Company is selected from the drop-down -->
<div class="w-form">
<form action="http://35.163.38.99/newCompanySubmit.php" data-name="New Company Form" id="new-co-form"  method="post" name="new-co-form" class="hide">
<div class="w-row">
<div class="w-col w-col-8">
<label for="name">Company Name:</label>
<input class="w-input" data-name="newCo" id="newCo" maxlength="256" name="newCo" placeholder="Enter the Company Name" type="text"></div>
<div class="w-col w-col-2"><label for="PodCount">Submit</label>
            <input class="w-button" data-wait="Please wait..." type="submit" value="Submit"></div>
<div class="w-col w-col-2">
            <label for="PodCount">Cancel</label>
            <input class="submit-button-2 w-button" data-wait="Please wait..." value="Cancel" onclick="getval(this);" id="newCoCancel">
        </div>
</div></form><div class="w-form-done"><div>Thank you! Your submission has been received!</div></div><div class="w-form-fail"><div>Oops! Something went wrong while submitting the form</div></div>

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.17/jquery-ui.min.js"></script>
<script type="text/javascript">
    function getval(sel)
    {
        if (sel.value == "Add New Company") {
            if (document.getElementById('new-co-form').classList.contains('hide')) {
                document.getElementById('new-co-form').classList.toggle('hide');
            }
            document.getElementById('wf-form-submitNewDelivery').classList.toggle('hide');
        }
        if (sel.id == "newCoCancel") {
            document.getElementById('new-co-form').classList.toggle('hide');
            document.getElementById('Company').selectedIndex = 0;
            if (document.getElementById('wf-form-submitNewDelivery').classList.contains('hide')) {
                document.getElementById('wf-form-submitNewDelivery').classList.toggle('hide');
            }
        }
    }
</script>
<!-- -->

    <div class="datagrid">
<table>
    <thead>
        <tr><th>Company</th><th>Pods Delivered</th><th>Date</th><th>Edit</th></tr>
    </thead>
    
    <tbody>
        
        <?php
            $normalRow = True;
            foreach ($companyArray as &$company) {
                foreach ($$company as &$delivery) {
                    $pods = $delivery['podCount'];
                    $date = $delivery['date'];
                    $edit = '<a href="www.google.com">Edit</a>';
                    if ($normalRow) {
                        echo('<tr>');
                    } else {
                        echo('<tr class="alt">');
                    }
                    echo('<td>'.$company.'</td><td>'.$pods.'</td><td>'.$date.'</td><td>'.$edit.'</td></tr>');
                    $normalRow = !$normalRow;
                }
            }
        ?>
<!--         <tr><td>data</td><td>data</td><td>data</td><td>Edit</td></tr>
        <tr class="alt"><td>data</td><td>data</td><td>data</td><td>Edit</td></tr>
        <tr><td>data</td><td>data</td><td>data</td><td>Edit</td></tr>
        <tr class="alt"><td>data</td><td>data</td><td>data</td><td>Edit</td></tr>
        <tr><td>data</td><td>data</td><td>data</td><td>Edit</td></tr>
        <tr class="alt"><td>data</td><td>data</td><td>data</td><td>Edit</td></tr>
        <tr><td>data</td><td>data</td><td>data</td><td>Edit</td></tr>
        <tr class="alt"><td>data</td><td>data</td><td>data</td><td>Edit</td></tr>
        <tr><td>data</td><td>data</td><td>data</td><td>Edit</td></tr>
        <tr class="alt"><td>data</td><td>data</td><td>data</td><td>Edit</td></tr> -->
    </tbody>
    </table>
</div>

</div>
</div>

<div><div class="w-container"><div class="copyright text-h2">© 2017 Origin. Origin is a service provided by Calmlee, Inc., located in San Francisco, CA.</div></div><div class="overlay"><div class="overlay-container"><h1>Discount</h1><div></div></div><a class="close-overlay w-inline-block" data-ix="close-overlay" href="#"><img src="https://d3e54v103j8qbb.cloudfront.net/img/image-placeholder.svg"></a></div></div><script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js" type="text/javascript"></script>
<script src="https://daks2k3a4ib2z.cloudfront.net/58c85d55fb3921d4300075eb/js/webflow.3b03886c1.js" type="text/javascript"></script>
<!--[if lte IE 9]><script src="//cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif]-->
</body></html>
