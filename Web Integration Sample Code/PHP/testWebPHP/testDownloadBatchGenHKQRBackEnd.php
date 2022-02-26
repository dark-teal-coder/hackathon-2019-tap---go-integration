<?php

    include '_accountSettings.php';
    
    $accountSetting = $accountList[$_POST['merchantName']];
    $accessToken = $_POST['accessToken'];
    $ticketNo = $_POST['ticketNo'];

    $queryString = "accessToken=" . $accessToken . "&ticketNo=" . $ticketNo;

    $url = $accountSetting['downloadBatchHKQRStatusUrl'];

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
        CURLOPT_POSTFIELDS => $queryString,
        CURLOPT_HTTPHEADER => array(
            "content-type: application/x-www-form-urlencoded",
            "accept: application/hal+json"
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
        echo "Download batch hkqr success";
    }
    echo "</textarea><br><br>";

    $responseBody = str_replace("><",">\n<",$response);
    
    $filename = sys_get_temp_dir() . "\\" . "testDownload_" . $ticketNo . ".zip";
    // $QRFile = fopen($filename, "a");
    // fwrite($QRFile, $responseBody);
    // fclose($QRFile);

    // if(file_exists($filename)){
    //     header('Content-Description: File Transfer');
    //     header('Content-Type: application/octet-stream');
    //     header('Content-Disposition: attachment; filename='.basename($filename));
    //     header('Cache-Control: must-revalidate');
    //     header('Content-Length: ' . filesize($filename));
    //     ob_clean();
    //     flush();
    //     readfile($filename);
    //     exit; 
    // }

    $tmpfname = tempnam(sys_get_temp_dir(), "temp");
    $tempfile = fopen($tmpfname, "a");
    fwrite($tempfile, $responseBody);

    if(file_exists($tmpfname)){
        if(rename($tmpfname, $filename)){
            header('Content-Description: File Transfer');
            header('Content-Type: application/octet-stream');
            header('Content-Disposition: attachment; filename='.basename($filename));
            header('Content-Transfer-Encoding: binary');
            header('Expires: 0');
            header('Cache-Control: must-revalidate');
            header('Pragma: public');
            header('Content-Length: ' . filesize($filename));
            ob_clean();
            flush();
            readfile($filename);
            fclose($filename);
            exit; 
        }
    }

?>