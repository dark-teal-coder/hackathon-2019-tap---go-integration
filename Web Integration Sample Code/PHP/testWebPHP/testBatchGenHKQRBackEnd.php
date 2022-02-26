<?php 


    $urlString = "https://gateway.sandbox.tapngo.com.hk/paymentApi/create/batch/HKQR";

    $saveDirectory = getcwd() . "\\upload\\";
    
    $accessToken = $_POST["accessToken"];

    //echo $accessToken;

    if(!empty($_FILES) && isset($_FILES['file'])){
        switch($_FILES['file']['error']){
            case UPLOAD_ERR_OK:
                $directory = $saveDirectory . basename($_FILES['file']['name']);

                if(move_uploaded_file($_FILES['file']['tmp_name'], $directory)){
                    $status = "The file " . basename($_FILES['file']['name']) . " has been uploaded";
                }
                else{
                    $status = "Sorry, there was a problem uploading your file.";
                }
                break;
        }

        echo "Status: {$status}<br/>\n";

    }

    sendFileToServer($accessToken, $saveDirectory . $_FILES['file']['name'], $urlString);


    function sendFileToServer($accessToken, $filename, $targetUrl){

        $pathToOurFile = $filename;
        $urlServer = $targetUrl;
        $currentTime = round(microtime(true) * 1000);
        $date = new DateTime(date("Y-m-d H:i:s",($currentTime/1000)));

        $url = $urlServer;
        
        $curl = curl_init();

        curl_setopt($curl, CURLOPT_PROXY, "http://proxy.pccw.com");
        curl_setopt($curl, CURLOPT_PROXYPORT, "8080");
    
        curl_setopt_array($curl, array(
            CURLOPT_URL => $url, 
            // . "?accessToken=" . $accessToken,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => "",
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 60,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => "POST",
            CURLOPT_POSTFIELDS  => array (
                'attachment' => new CURLFile ( $pathToOurFile ),
                'accessToken'=> $accessToken
            ) ,
            CURLOPT_HTTPHEADER => array(
              "Cache-Control: no-cache",
              "Connection: keep-alive",
              "accept: application/hal+json",
              "cache-control: no-cache",
              "content-type: multipart/form-data"
            ),
          ));
    
        $response = curl_exec($curl);
        $err = curl_error($curl);
    
        curl_close($curl);
    
        echo "<br>Result:<br><textarea rows='20' cols='130'>";
        if ($err) {
            echo "cURL Error #:" . $err;
        } else {
            echo str_replace("><",">\n<",$response);

        }
        echo "</textarea><br><br>";
    
    

    }


?>