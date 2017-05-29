<?php
  // Formatting - replaced 88ae47 with 505050
  // Formatting - replaced f9fafa with 808080
  // Formatting - replaced 808080 with ffffff
  // Formatting - replaced 008cdd with dcdcdc
  // Formatting - replaced dcdcdc with 008cdd
  // Formatting - replaced 98c24f with a9a9a9
  // Formatting - replaced a9a9a9 with 000000

  $phoneNumber = $_GET['phoneNumber'];
  // $chargeAmt = $_GET['chargeAmt'];
  // $brand = $_GET['brand'];
  // $last4 = $_GET['last4'];
  // if ($brand == "Visa") {
  //   $brand_text = "card-visa";
  // }
  // else if ($brand == "American Express") {
  //   $brand_text = "card-amex";
  // }
  // else if ($brand == "MasterCard") {
  //   $brand_text = "card-mastercard";
  // }
  // else if ($brand == "Discover") {
  //   $brand_text = "card-visa";
  // }
  // else if ($brand == "JCB") {
  //   $brand_text = "card-jcb";
  // }
  // else if ($brand == "Diners") {
  //   $brand_text = "card-diners";
  // }
  // else if ($brand == "Unknown") {
  //   $brand_text = "card-default";
  // }
  // else {
  //   $brand_text = "card-default";
  // }
  // // Visa                card-visa
  // // American Express    card-amex
  // // MasterCard          card-mastercard
  // // Discover            card-discover
  // // JCB                 card-jcb
  // // Diners Club         card-diners
  // // Unknown             card-default

  // Date and Time Formatting
  $timeSeconds=$_GET['timeSeconds'];

  // $oldtime = date('U', $timeSeconds);
  $oldtime = new DateTime("@$timeSeconds");
  $oldtime->setTimezone(new DateTimeZone('America/Los_Angeles'));

  $monthName = $oldtime->format('F');
  $dayNum = $oldtime->format('j');
  $yearNum = $oldtime->format('Y');

  $hourNum = $oldtime->format('g');
  $minNum = $oldtime->format('i');
  $amPm = $oldtime->format('A');

  $giftsRemaining = $_GET['giftsRemaining'];

  ob_start();
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional" "https://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="https://www.w3.org/1999/xhtml" lang="en">
  <head>
    <title><?php echo "Your Origin receipt [#".$phoneNumber."-".$timeSeconds."]"?></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width" />
    <meta name="robots" content="noindex, nofollow" />
    <meta name="googlebot" content="noindex, nofollow, noarchive" />
    <style type="text/css">

      a {
        text-decoration: none !important;
      }

      /* overrides addresses, numbers, etc. being linked */

      span.apple-override-header a {
        color: #ffffff !important;
        text-decoration: none !important;
      }

      span.apple-override-hidden a {
        color: #000000 !important;
        text-decoration: none !important;
      }

      span.apple-override-dark a {
        color: #292e31 !important;
        text-decoration: none !important;
      }

      span.apple-override-light a {
        color: #77858c !important;
        text-decoration: none !important;
      }

      /* [override] prevents Yahoo Mail breaking media queries */

      /* retina */
      @media (-webkit-min-device-pixel-ratio: 1.25), (min-resolution: 120dpi) {

        body[override] span.retina img {
          visibility: hidden !important;
        }

        body[override] td.icon span.retina {
          background: url('https://io.calmlee.com/circleLogo_originWhite_bgGreen.png') no-repeat 0 0 !important;
          background-size: 72px 72px !important;
          display: block !important;
          height: 72px !important;
          width: 72px !important;
        }

        body[override] table.card td.card-type span.retina {
          display: block !important;
          height: 16px !important;
        }

        /* default */

        body[override] table.card-default td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/default-light@2x.png') no-repeat 0 0 !important;
          background-size: 22px 16px !important;
          width: 22px !important;
        }

        body[override] table.card-default tr.card-dark td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/default-dark@2x.png') no-repeat 0 0 !important;
          background-size: 22px 16px !important;
          width: 22px !important;
        }

        /* visa */

        body[override] table.card-visa td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/visa-light@2x.png') no-repeat 0 0 !important;
          background-size: 36px 16px !important;
          width: 36px !important;
        }

        body[override] table.card-visa tr.card-dark td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/visa-dark@2x.png') no-repeat 0 0 !important;
          background-size: 36px 16px !important;
          width: 36px !important;
        }

        /* mastercard */

        body[override] table.card-mastercard td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/mastercard-light@2x.png') no-repeat 0 0 !important;
          background-size: 75px 16px !important;
          width: 75px !important;
        }

        body[override] table.card-mastercard tr.card-dark td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/mastercard-dark@2x.png') no-repeat 0 0 !important;
          background-size: 75px 16px !important;
          width: 75px !important;
        }

        /* amex */

        body[override] table.card-amex td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/amex-light@2x.png') no-repeat 0 0 !important;
          background-size: 45px 16px !important;
          width: 45px !important;
        }

        body[override] table.card-amex tr.card-dark td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/amex-dark@2x.png') no-repeat 0 0 !important;
          background-size: 45px 16px !important;
          width: 45px !important;
        }

        /* discover */

        body[override] table.card-discover td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/discover-light@2x.png') no-repeat 0 0 !important;
          background-size: 57px 16px !important;
          width: 57px !important;
        }

        body[override] table.card-discover tr.card-dark td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/discover-dark@2x.png') no-repeat 0 0 !important;
          background-size: 57px 16px !important;
          width: 57px !important;
        }

        /* jcb */

        body[override] table.card-jcb td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/jcb-light@2x.png') no-repeat 0 0 !important;
          background-size: 19px 16px !important;
          width: 19px !important;
        }

        body[override] table.card-jcb tr.card-dark td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/jcb-dark@2x.png') no-repeat 0 0 !important;
          background-size: 19px 16px !important;
          width: 19px !important;
        }

        /* diners */

        body[override] table.card-diners td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/diners-light@2x.png') no-repeat 0 0 !important;
          background-size: 20px 16px !important;
          width: 20px !important;
        }

        body[override] table.card-diners tr.card-dark td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/diners-dark@2x.png') no-repeat 0 0 !important;
          background-size: 20px 16px !important;
          width: 20px !important;
        }

      }

      /* tablets */
      @media all and (max-device-width: 768px) {

        body[override] span.retina img {
          visibility: hidden !important;
        }

        body[override] td.font-large, body[override] td.font-large span, body[override] td.font-large a {
          font-size: 18px !important;
          line-height: 25px !important;
        }

        body[override] td.font-medium, body[override] td.font-medium span, body[override] td.font-medium a {
          font-size: 16px !important;
          line-height: 23px !important;
        }

        body[override] td.font-small, body[override] td.font-small span, body[override] td.font-small a {
          font-size: 15px !important;
          line-height: 21px !important;
        }

        body[override] td.icon span.retina {
          background: url('https://io.calmlee.com/circleLogo_originWhite_bgGreen.png') no-repeat 0 0 !important;
          background-size: 72px 72px !important;
          display: block !important;
          height: 72px !important;
          width: 72px !important;
        }

        body[override] td.title, body[override] td.title span, body[override] td.title a {
          font-size: 24px !important;
          line-height: 28px !important;
        }

        body[override] table.card td.card-type span.retina {
          display: block !important;
          height: 19px !important;
        }

        /* default */

        body[override] table.card-default td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/default-light@2x.png') no-repeat 0 0 !important;
          background-size: 25px 19px !important;
          width: 25px !important;
        }

        body[override] table.card-default tr.card-dark td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/default-dark@2x.png') no-repeat 0 0 !important;
          background-size: 25px 19px !important;
          width: 25px !important;
        }

        /* visa */

        body[override] table.card-visa td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/visa-light-mobile.png') no-repeat 0 0 !important;
          background-size: 43px 19px !important;
          width: 43px !important;
        }

        body[override] table.card-visa tr.card-dark td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/visa-dark-mobile.png') no-repeat 0 0 !important;
          background-size: 43px 19px !important;
          width: 43px !important;
        }

        /* mastercard */

        body[override] table.card-mastercard td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/mastercard-light-mobile.png') no-repeat 0 0 !important;
          background-size: 87px 19px !important;
          width: 87px !important;
        }

        body[override] table.card-mastercard tr.card-dark td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/mastercard-dark-mobile.png') no-repeat 0 0 !important;
          background-size: 87px 19px !important;
          width: 87px !important;
        }

        /* amex */

        body[override] table.card-amex td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/amex-light-mobile.png') no-repeat 0 0 !important;
          background-size: 53px 19px !important;
          width: 53px !important;
        }

        body[override] table.card-amex tr.card-dark td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/amex-dark-mobile.png') no-repeat 0 0 !important;
          background-size: 53px 19px !important;
          width: 53px !important;
        }

        /* discover */

        body[override] table.card-discover td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/discover-light-mobile.png') no-repeat 0 0 !important;
          background-size: 70px 19px !important;
          width: 70px !important;
        }

        body[override] table.card-discover tr.card-dark td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/discover-dark-mobile.png') no-repeat 0 0 !important;
          background-size: 70px 19px !important;
          width: 70px !important;
        }

        /* jcb */

        body[override] table.card-jcb td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/jcb-light@2x.png') no-repeat 0 0 !important;
          background-size: 22px 19px !important;
          width: 22px !important;
        }

        body[override] table.card-jcb tr.card-dark td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/jcb-dark@2x.png') no-repeat 0 0 !important;
          background-size: 22px 19px !important;
          width: 22px !important;
        }

        /* diners */

        body[override] table.card-diners td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/diners-light@2x.png') no-repeat 0 0 !important;
          background-size: 23px 19px !important;
          width: 23px !important;
        }

        body[override] table.card-diners tr.card-dark td.card-type span.retina {
          background: url('https://stripe-images.s3.amazonaws.com/emails/receipt_assets/card/diners-dark@2x.png') no-repeat 0 0 !important;
          background-size: 23px 19px !important;
          width: 23px !important;
        }

        /* */

        body[override] table.card td.card-digits, body[override] table.card td.card-digits span {
          font-size: 16px !important;
          line-height: 16px !important;
        }

        body[override] td.summary-total {
          font-size: 20px !important;
          line-height: 25px !important;
        }

      }

      /* mobile */
      @media all and (max-device-width: 500px) {

        body[override] table.width, body[override] td.width {
          width: 100% !important;
        }

        body[override] td.temp-padding, body[override] td.temp-padding div.clear {
          display: none !important;
          width: 0 !important;
        }

        body[override] td.banner {
          height: 186px !important;
        }

        body[override] td.subbanner-item {
          -moz-box-sizing: border-box !important;
          -webkit-box-sizing: border-box !important;
          box-sizing: border-box !important;
          display: block !important;
          padding-left: 10px !important;
          padding-right: 10px !important;
          text-align: center !important;
          width: 100% !important;
        }

        body[override] tr.summary-item td.summary-padding, body[override] tr.summary-item td.summary-padding div.clear {
          width: 17px !important;
        }

        body[override] a.browser-link {
          display: block !important;
        }

      }

    </style>
  </head>
  <body bgcolor="ffffff" style="border: 0; margin: 0; padding: 0; min-width: 100%;" override="fix">

    <!-- background -->
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
      <tbody>
        <tr>
          <td bgcolor="ffffff" style="border: 0; margin: 0; padding: 0;">

            <!-- header -->
            <table style="background-color: #000000;" border="0" cellpadding="0" cellspacing="0" width="100%">
              <tbody>
                <tr>
                  <td align="center" style="border: 0; margin: 0; padding: 0;">

                    <!-- preheader -->
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                      <tbody>
                        <tr>
                          <td align="center" style="border: 0; margin: 0; padding: 0;">
                            <table align="center" border="0" cellpadding="0" cellspacing="0" class="width" width="500">
                              <tbody>
                                <tr>
                                  <td align="center" height="20" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly; color: #000000; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;">
                                    <?php echo "Congratulations on your free Smoothie from ";?> <span class="apple-override-hidden" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly; color: #000000; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;">Origin</span>.
                                  </td>
                                </tr>
                              </tbody>
                            </table>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                    <!-- /preheader -->

                    <!-- banner -->
                    <table border="0" cellpadding="0" cellspacing="0" class="width" width="500">
                      <tbody>
                        <tr>
                          <td height="7" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly;" width="100%">
                            <div class="clear" style="height: 7px; width: 1px;">&nbsp;</div>
                          </td>
                        </tr>
                        <tr>
                          <td class="banner" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly;" valign="middle">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                              <tr>
                                <td class="perm-padding" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly;" width="20">
                                  <div class="clear" style="height: 1px; width: 20px;"></div>
                                </td>
                                <td style="border: 0; margin: 0; padding: 0;" width="100%">
                                  <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                          <td align="center" class="icon" height="72" style="border: 0; margin: 0; padding: 0;">
                                            <a href="http://www.eatorigin.com" style="border: 0; margin: 0; padding: 0;" target="_blank" rel="noreferrer">
                                              <span class="retina">
                                                <img alt="" height="72" src="https://io.calmlee.com/circleLogo_originWhite_bgGreen.png" style="border: 0; margin: 0; padding: 0;" width="72" />
                                              </span>
                                            </a>
                                          </td>
                                        </tr>
                                    <tr>
                                      <td height="22" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly;" width="100%">
                                        <div class="clear" style="height: 22px; width: 1px;">&nbsp;</div>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td align="center" class="title" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly; color: #ffffff; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; font-size: 22px; line-height: 25px; text-shadow: 0 1px 1px #505050;">
                                          <span class="apple-override" style="color: #ffffff; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; font-size: 22px; line-height: 25px;"><?php echo "FREE";?></span> <span style="color: #ffffff; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; font-size: 22px; line-height: 25px; opacity: 0.75;">at</span> <a href="http://www.eatorigin.com" style="color: #ffffff; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; font-size: 22px; line-height: 25px; text-decoration: none;" target="_blank" rel="noreferrer"><span class="apple-override-header" style="color: #ffffff; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; font-size: 22px; line-height: 25px; text-decoration: none;">Origin</span></a>
                                      </td>
                                    </tr>

                                      <!-- card -->
                                      <tr>
                                        <td height="13" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly;" width="100%">
                                          <div class="clear" style="height: 13px; width: 1px;">&nbsp;</div>
                                        </td>
                                      </tr>
                                      <tr>
                                        <td align="center" height="1" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly;" width="100%">
                                          <table align="center" border="0" cellpadding="0" cellspacing="0" width="200">
                                            <tbody>
                                              <tr>
                                                <td bgcolor="#505050" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly;">
                                                  <div class="clear" style="height: 1px; width: 200px;">&nbsp;</div>
                                                </td>
                                              </tr>
                                            </tbody>
                                          </table>
                                        </td>
                                      </tr>
                                      <tr>
                                        <td height="18" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly;" width="100%">
                                          <div class="clear" style="height: 18px; width: 1px;">&nbsp;</div>
                                        </td>
                                      </tr>
                                      <tr>
                                        <td align="center" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly;" width="100%">
                                          <table border="0" cellpadding="0" cellspacing="0" class="card">
                                          <tbody>
                                            <tr class="card-light">
                                              <td>
                                                <span class="apple-override-header" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly; color: #ffffff; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; font-size: 13px; line-height: 17px; text-shadow: 0 1px 1px #505050;"><?php echo 'Free Smoothies Remaining:  '.$giftsRemaining;?></span>
                                              </td>
                                            </tr>
                                          </tbody>
                                        </table>

                                        </td>
                                      </tr>
                                      <!-- /card -->

                                  </table>
                                </td>
                                <td class="perm-padding" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly;" width="20">
                                  <div class="clear" style="height: 1px; width: 20px;"></div>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr>
                          <td height="27" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly;" width="100%">
                            <div class="clear" style="height: 27px; width: 1px;">&nbsp;</div>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                    <!-- /banner -->

                    <!-- subbanner -->
                    <table bgcolor="#505050" border="0" cellpadding="0" cellspacing="0" width="100%">
                      <tbody>
                        <tr>
                          <td align="center" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly;">
                            <table class="width" border="0" cellpadding="0" cellspacing="0" width="500">
                              <tbody>
                                <tr>
                                  <td colspan="4" height="8" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly;" width="100%">
                                    <div class="clear" style="height: 8px; width: 1px;">&nbsp;</div>
                                  </td>
                                </tr>
                                <tr>
                                  <td class="perm-padding" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly;" width="20">
                                    <div class="clear" style="height: 1px 20px;"></div>
                                  </td>
                                  <td align="left" class="subbanner-item font-small" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly; color: #ffffff; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; font-size: 13px; line-height: 17px; text-shadow: 0 1px 1px #505050;" width="230">
                                    <span
                                      class="apple-override-header"
                                      style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly; color: #ffffff; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; font-size: 13px; line-height: 17px; text-shadow: 0 1px 1px #505050;"
                                      >
                                        <?php echo $monthName." ".$dayNum.", ".$yearNum." - ".$hourNum.":".$minNum." ".$amPm;?>
                                    </span>
                                  </td>
                                  <td align="right" class="subbanner-item font-small" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly; color: #ffffff; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; font-size: 13px; line-height: 17px; text-shadow: 0 1px 1px #505050;" width="230">
                                    <span class="apple-override-header" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly; color: #ffffff; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; font-size: 13px; line-height: 17px; text-shadow: 0 1px 1px #505050;"><?php echo "#".$phoneNumber."-".$timeSeconds.""?></span>
                                  </td>
                                  <td class="perm-padding" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly;" width="20">
                                    <div class="clear" style="height: 1px 20px;"></div>
                                  </td>
                                </tr>
                                <tr>
                                  <td colspan="4" height="8" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly;" width="100%">
                                    <div class="clear" style="height: 8px; width: 1px;">&nbsp;</div>
                                  </td>
                                </tr>
                              </tbody>
                            </table>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                    <!-- /subbanner -->

                  </td>
                </tr>
              </tbody>
            </table>
            <!-- /header -->


            <!-- help -->
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
              <tbody>
                <tr>
                  <td align="center" style="border: 0; margin: 0; padding: 0;">
                    <table border="0" cellpadding="0" cellspacing="0" class="width" width="500">
                      <tbody>
                        <tr>
                          <td colspan="3" height="37" style="border: 0; margin: 0; padding: 0; mso-line-height-rule: exactly;">
                            <div class="clear" style="height: 37px; width: 1px;">&nbsp;</div>
                          </td>
                        </tr>
                        <tr>
                          <td style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly;">
                            <div class="clear" style="height: 1px; width: 20px;"></div>
                          </td>
                          <td align="center" class="font-large" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; color: #515f66; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; font-size: 15px; line-height: 21px;">

                              Have a question or need help? <a href="mailto:eric@eatorigin.com" style="border: 0; margin: 0; padding: 0; color: #515f66; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; text-decoration: none;" target="_blank" rel="noreferrer"><span style="border: 0; margin: 0; padding: 0; color: #008cdd; text-decoration: none;">Send us an email</span></a> or <a href="sms:5623625363" style="border: 0; margin: 0; padding: 0; color: #515f66; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; text-decoration: none;" target="_blank" rel="noreferrer"><span style="border: 0; margin: 0; padding: 0; color: #008cdd; text-decoration: none;">send us a text message at (562) 362-5363</span></a>.
                          </td>
                          <td style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly;">
                            <div class="clear" style="height: 1px; width: 20px;"></div>
                          </td>
                        </tr>
                        <tr>
                          <td colspan="3" height="37" style="border: 0; margin: 0; padding: 0; mso-line-height-rule: exactly;">
                            <div class="clear" style="height: 37px; width: 1px;">&nbsp;</div>
                          </td>
                        </tr>
                        <tr>
                          <td colspan="3" align="center" height="1" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly;">
                            <table align="center" border="0" cellpadding="0" cellspacing="0" width="200">
                              <tbody>
                                <tr>
                                  <td bgcolor="edeff0" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly;">
                                    <div class="clear" style="height: 1px; width: 200px;">&nbsp;</div>
                                  </td>
                                </tr>
                              </tbody>
                            </table>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </td>
                </tr>
              </tbody>
            </table>
            <!-- /help -->

            <!-- footer -->
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
              <tbody>
                <tr>
                  <td align="center" style="border: 0; margin: 0; padding: 0;">
                    <table border="0" cellpadding="0" cellspacing="0" class="width" width="500">
                      <tbody>
                        <tr>
                          <td colspan="3" height="28" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly;">
                            <div class="clear" style="height: 28px; width: 1px;">&nbsp;</div>
                          </td>
                        </tr>


                        <tr>
                          <td class="perm-padding" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px;" width="20">
                            <div class="clear" style="height: 1px; width: 20px;"></div>
                          </td>
                          <td align="center" class="font-small" style="border: 0; margin: 0; padding: 0; color: #959fa5; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; font-size: 13px; line-height: 17px;">
                              You are receiving this text message receipt because you made a purchase at <a href="http://www.eatorigin.com" style="border: 0; margin: 0; padding: 0; color: #008cdd; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; text-decoration: none;" target="_blank" rel="noreferrer"><span style="border: 0; margin: 0; padding: 0; color: #008cdd; text-decoration: none;">Origin</span></a>.
                          </td>
                          <td class="perm-padding" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px;" width="20">
                            <div class="clear" style="height: 1px; width: 20px;"></div>
                          </td>
                        </tr>
                        <tr>
                          <td colspan="3" height="28" style="border: 0; margin: 0; padding: 0; font-size: 1px; line-height: 1px; mso-line-height-rule: exactly;">
                            <div class="clear" style="height: 28px; width: 1px;">&nbsp;</div>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </td>
                </tr>
              </tbody>
            </table>
            <!-- /footer -->

          </td>
        </tr>
      </tbody>
    </table>
    <!-- /background -->

  </body>
</html>

<?php
    file_put_contents(__DIR__."/receipts/gift_".$phoneNumber."_".$timeSeconds.".html", ob_get_contents());
    // echo "Location: /".$company."-preorder.html";
    // header("Location: https://io.calmlee.com/receipts/".$company.".html"); /* Redirect browser */
    // exit();
?>