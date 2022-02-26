<?php
		//Constant file of AppID, Api Key, Public Key, etc
        include '_accountSettings.php';

		$currentTime = round(microtime(true) * 1000);
		$date = new DateTime(date("Y-m-d H:i:s",($currentTime/1000)));
        //echo "Date: " . $date -> format("Y-m-d H:i:s") . "<br>";
        
        $accountSetting = $accountList[$_POST['merchantName']];

		//echo "<pre>";
		//echo "</pre>";
		
        $appid = $accountSetting['appId'];
        $publicKeyString = $accountSetting['publicKey'];
        $apiKey = $accountSetting['apiKey'];
        $merTradeNo = "TEST" . $date->format('YmdHis');
        $lang = $_POST['lang'];
        $currency = $_POST['currency'];
        $notifyUrl = $accountSetting['notifyUrl'];
        $returnUrl = $accountSetting['returnUrl'];
        $remark = $_POST['remark'];
        $totalPrice = $_POST['totalPrice'];
        $paymentType = $_POST['paymentType'];
        $paymentUrl = $accountSetting['paymentUrl'];

        $formatKey = trim($publicKeyString);

        $formatKey = "-----BEGIN PUBLIC KEY-----\n" . wordwrap($formatKey, 64, "\n", true) . "\n-----END PUBLIC KEY-----";


        if(empty($remark) || $remark == null){
            $remark = "";
        }

		$data = array(
            'currency' => $currency,
            'merTradeNo' => $merTradeNo,
            'lang' => $lang,
            'notifyUrl' => $notifyUrl,
            'totalPrice' => $totalPrice,
            'returnUrl' => $returnUrl,
            'remark' => $remark
        );
        $dataEn = json_encode($data);

        //Get public key
        $publicKey = openssl_pkey_get_public($formatKey);

        if (!$publicKey) {
            echo "Public key NOT correct\n";
        }
		
		//Remark: should set padding to "OPENSSL_PKCS1_OAEP_PADDING" for openssl public encrypt
        if (!openssl_public_encrypt($dataEn, $encryptedWithPublic, $publicKey, OPENSSL_PKCS1_OAEP_PADDING)) {
            echo "Error encrypting with public key\n";
        }
		//Base64 encode for encrypted data
        $b64_encryptedWithPublic = base64_encode($encryptedWithPublic);

		//For debug use
        echo "payload:<pre>";
        var_dump($data);
        echo "</pre>";
        echo "Encrypted with public key: <br><textarea rows='20' cols='50'>" . $b64_encryptedWithPublic . "</textarea>\n<br>";

        //echo "-----------------------------------<br>sign:<br>";
		//Remark: Order of parameters is not correct, it should be arranged in alphabetical order
		//$string = "appId=" . $appid . "&merTradeNo=" . $merTradeNo . "&paymentType=S&payload=" .($b64_encryptedWithPublic) ;
        $string = 'appId=' . $appid . '&merTradeNo=' . $merTradeNo . '&payload=' .($b64_encryptedWithPublic) . '&paymentType=' . $paymentType;
        
		//echo $string. "<br><br>";

		//Create signature for the data submitted with hash_hmac - sha512
		//Remark: set keep raw output to "true"
        $sig = hash_hmac('sha512', $string, $apiKey, true);
		//Base64 encoded signature
        $b64_sig = base64_encode($sig);
		
        //echo "<br>b64_sig:<br>";
        //echo $b64_sig;
        ?>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Test Payment</title>
<script>
function formSubmit()
{
document.form1.submit()
}
</script>
</head>

<!-- <body> -->
<body onload="formSubmit();">
		<form action="<?php echo $accountSetting["paymentUrl"]; ?>" method="post" id="form1" name="form1">
            <label>appId:</label><input type="text" name="appId" value="<?php echo $appid; ?>"/><br>
            <label>merTradeNo:</label><input type="text" name="merTradeNo" value="<?php echo $merTradeNo; ?>" /><br>
            <label>payload:</label><input type="text" name="payload" value="<?php echo $b64_encryptedWithPublic; ?>"/><br>
            <label>paymentType:</label><input type="text" name="paymentType" value="<?php echo $paymentType; ?>"/><br>
            <label>sign:</label><input type="text" name="sign" value="<?php echo $b64_sig; ?>"/><br>
			<label>totalPrice: <?php echo $totalPrice; ?></label><br>
            <label>remark: <?php echo $remark; ?></label>
            <p><input type="submit" value="Pay By Tap &amp; Go"/></p>
        </form>
		</body>
</html>