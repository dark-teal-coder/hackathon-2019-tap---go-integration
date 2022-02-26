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
        $recurrentToken = $_POST['recurrentToken'];
        $transactionType = 'CR';

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
        // echo "payload:<pre>";
        //var_dump($data);
        // echo "</pre>";
        // echo "Encrypted with public key: <br><textarea rows='20' cols='50'>" . $b64_encryptedWithPublic . "</textarea>\n<br>";

        //echo "-----------------------------------<br>sign:<br>";
		//Remark: Order of parameters is not correct, it should be arranged in alphabetical order
		//$string = "appId=" . $appid . "&merTradeNo=" . $merTradeNo . "&paymentType=S&payload=" .($b64_encryptedWithPublic) ;
        $string = 'appId=' . $appid . '&payload=' .($b64_encryptedWithPublic) . '&recurrentToken=' . $recurrentToken . '&timestamp=' . $currentTime . '&transactionType=' . $transactionType;
        
		//echo $string. "<br><br>";

		//Create signature for the data submitted with hash_hmac - sha512
		//Remark: set keep raw output to "true"
        $sig = hash_hmac('sha512', $string, $apiKey, true);
		//Base64 encoded signature
        $b64_sig = base64_encode($sig);
		
        //echo "<br>b64_sig:<br>";
        //echo $b64_sig;

        // Some characters (e.g. "+") in payload and sign should be handled by URLEncoder before sending the request 
        $urlParameters = 'appId=' . $appid . '&payload=' . urlencode($b64_encryptedWithPublic) . '&recurrentToken=' . $recurrentToken . '&timestamp=' . $currentTime . '&transactionType=' . $transactionType . "&sign=" . urlencode($b64_sig);
        
        $url = $accountSetting['recurrentPaymentUrl'];


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
