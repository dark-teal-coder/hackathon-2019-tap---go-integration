<!DOCTYPE html>
<html>
<head>
</head>

<body>
<h1>Merchant Integration Test Page</h1>

<?php
		//Constant file of AppID, Api Key, Public Key, etc
		include '_accountSettings.php';

		$timestamp = round(microtime(true) * 1000);
		$date = new DateTime(date("Y-m-d H:i:s",($timestamp/1000)));
		
		//echo "Date: " . $date -> format("Y-m-d H:i:s") . "<br>";

		//echo "<pre>";
		//echo "</pre>";
		$accountSetting = $accountList[$_POST['merchantName']];
		
		$appId = $accountSetting["appId"];
		$publicKeyString = $accountSetting["publicKey"];
		$apiKey = $accountSetting["apiKey"];
		$notifyUrl = $accountSetting["notifyUrl"];
		$returnUrl = $accountSetting["returnUrl"];
		$recurrentToken = $_POST['recurrentToken'];
		
		//For debug use
        //echo "payload:<pre>";
        //var_dump($data);
        //echo "</pre>";
        //echo "Encrypted with public key: <br><textarea rows='20' cols='50'>" . $b64_encryptedWithPublic . "</textarea>\n<br>";

        //echo "-----------------------------------<br>sign:<br>";
		//$string = "appId=" . $appid . "&merTradeNo=" . $merTradeNo . "&paymentType=S&payload=" .($b64_encryptedWithPublic) ;
        //$string = 'appId=' . $appid . '&merTradeNo=' . $merTradeNo . '&payload=' .($b64_encryptedWithPublic) . '&paymentType=' . $paymentType;
		
		//Remark: Order of parameters should be arranged in alphabetical order
		$queryString = 'appId=' . $appId . '&recurrentToken=' . $recurrentToken . "&timestamp=" . $timestamp;
        
		//echo $string. "<br><br>";

		//Create signature for the data submitted with hash_hmac - sha512
		//Remark: set keep raw output to "true"
        $sig = hash_hmac('sha512', $queryString, $apiKey, true);
		//Base64 encoded signature
        $b64_sig = base64_encode($sig);
		
		$payload = 'appId=' . $appId;
		$payload .= '&recurrentToken=' . urlencode($recurrentToken);
		$payload .= "&timestamp=" . $timestamp;
		$payload .= '&sign=' . urlencode($b64_sig);
		
        //echo "<br>b64_sig:<br>";
        //echo $b64_sig;
		$url = $accountSetting["invalidateTokenUrl"];
		
        $curl = curl_init();
//Set Proxy Server (remove these two lines before sending to Merchant as an example)
curl_setopt($curl, CURLOPT_PROXY, "http://proxy.pccw.com");
curl_setopt($curl, CURLOPT_PROXYPORT, "8080");

curl_setopt_array($curl, array(
    CURLOPT_URL => $url,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_ENCODING => "",
    CURLOPT_MAXREDIRS => 10,
    CURLOPT_TIMEOUT => 60,
    CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
    CURLOPT_CUSTOMREQUEST => "POST",
    CURLOPT_POSTFIELDS => $payload,
    CURLOPT_HTTPHEADER => array(
        "content-type: application/x-www-form-urlencoded",
    ),
));

$response = curl_exec($curl);
$err = curl_error($curl);

curl_close($curl);

/*
if ($err) {
    echo "cURL Error #:" . $err;
} else {
    var_dump($response);
}*/
echo "<br>Result:<br><textarea rows='20' cols='130'>";
if ($err) {
    echo "cURL Error #:" . $err;
} else {
	//var_dump($response);
	echo str_replace("><",">\n<",$response);
}
echo "</textarea><br><br>";
?>
		</body>
</html>