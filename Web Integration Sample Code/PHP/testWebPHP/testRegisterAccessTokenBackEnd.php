<?php
    include '_accountSettings.php';

    $currentTime = round(microtime(true) * 1000);
    $accountSetting = $accountList[$_POST['merchantName']];

    $appId = $accountSetting['appId'];
    $apiKey = $accountSetting['apiKey'];

    $queryString = 'appId=' . $appId . '&timestamp=' . $currentTime;

    $mac_data = hash_hmac('sha512', $queryString, $apiKey, true);
    $b64_sign = base64_encode($mac_data);

    $urlParameters = $queryString . '&sign=' . urlencode($b64_sign);

    $urlString = $accountSetting['registerAccessTokenUrl'];

    $curl = curl_init();

    curl_setopt($curl, CURLOPT_PROXY, "http://proxy.pccw.com");
    curl_setopt($curl, CURLOPT_PROXYPORT, "8080");
    
    curl_setopt_array($curl, array(
        CURLOPT_URL => $urlString,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_ENCODING => "",
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 60,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => "POST",
        CURLOPT_POSTFIELDS => $urlParameters,
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