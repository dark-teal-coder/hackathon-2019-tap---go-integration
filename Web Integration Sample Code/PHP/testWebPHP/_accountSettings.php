<?php
$accountSettings1 = array(
    "merchantName" => "{MERCHANT_NAME",
    "appId" => "{APP_ID}",
    "apiKey" => "{API_KEY}",
    "publicKey" => "{PUBLIC_KEY}",
    "queryTxnUrl" => "https://gateway2.sandbox.tapngo.com.hk/paymentApi/payment/status",
    "paymentUrl" => "https://gateway2.sandbox.tapngo.com.hk/web/payments",
    "recurrentPaymentUrl" => "https://gateway2.sandbox.tapngo.com.hk/paymentApi/payment/recurrent",
    "invalidateTokenUrl" => "https://gateway2.sandbox.tapngo.com.hk/paymentApi/payment/recurrent/token/invalidation",
    "registerAccessTokenUrl" => "https://gateway2.sandbox.tapngo.com.hk/paymentApi/register/accessToken",
    "notifyUrl" => "{NOTIFY_URL}",
    "returnUrl" => "{RETURN_URL}",
    "batchGenHKQRUrl" => "https://gateway2.sandbox.tapngo.com.hk/paymentApi/create/batch/HKQR",
    "queryBatchHKQRStatusUrl" => "https://gateway2.sandbox.tapngo.com.hk/paymentApi/query/batch/HKQR/status",
    "downloadBatchHKQRStatusUrl" => "https://gateway2.sandbox.tapngo.com.hk/paymentApi/download/batch/HKQR",
    "queryTxnHistoryUrl" => "https://gateway2.sandbox.tapngo.com.hk/paymentApi/query/transaction/history",
    "downloadTxnHistoryUrl" => "https://gateway2.sandbox.tapngo.com.hk/paymentApi/download/tansaction/history"
);

$accountList = array($accountSettings1);

?>