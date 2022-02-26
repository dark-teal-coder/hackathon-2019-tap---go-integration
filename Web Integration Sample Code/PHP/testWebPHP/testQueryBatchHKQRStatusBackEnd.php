<?php 

    include '_accountSettings.php';

    $accountSetting = $accountList[$_POST['merchantName']];

    $accessToken = $_POST['accessToken'];
    $tickenNo = $_POST['ticketNo'];

    $queryString = "accessToken=" . $accessToken . "&ticketNo=" . $tickenNo;

    $urlString = $accountSetting['queryBatchHKQRStatusUrl'];

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
        CURLOPT_POSTFIELDS => $queryString,
        CURLOPT_HTTPHEADER => array(
            "content-type: application/x-www-form-urlencoded",
            "accept: application/hal+json",
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