<?php
include('_accountSettings.php');
//Replace the below values for testing different merchant
//$apiKey = "e3Xc/5lSAip3FJ3tUAIbrEqe/vopONRe9xLeBG2CZQKqZzXOc1z4OpRz/989gVH0DWDHKp0+3fzZjo+De1Ny3A=="; //API Key

$accountSetting = $accountList[$_POST['merchantName']];

$apiKey = $accountSetting['apiKey']; //API Key

//$appid = "4295949200"; //App ID
$appid = $accountSetting['appId']; //App ID

//$merTradeNo = "W84P0678404"; // Merchant Trade No
$merTradeNo = $_POST['merTradeNo']; // Merchant Trade No

//$url = "https://gateway.sandbox.tapngo.com.hk/paymentApi/payment/status"; //URL
$url = $accountSetting['queryTxnUrl']; //URL

$timestamp = round(microtime(true) * 1000);

$payload = 'appId=' . $appid . '&merTradeNo=' . $merTradeNo . '&timestamp=' . $timestamp;
//echo "payload: " . $payload;
//echo "<br><br>";

$sign=hash_hmac('sha512', $payload, $apiKey, true);
$payload .= '&sign=' . urlencode(base64_encode($sign));
//echo "payload: " . $payload;
//echo "<br><br>";
//echo "<br><br>";
//$sign=base64_encode(hash_hmac('sha512', $payload, $apiKey, true));
//$payload .= '&sign=' . $sign;

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