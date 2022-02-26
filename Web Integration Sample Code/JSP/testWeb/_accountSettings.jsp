<%@page import="java.util.HashMap" %>
<%@page import="java.util.ArrayList" %>
<%
	ArrayList<HashMap> accountList = new ArrayList<HashMap>();
	
	HashMap accountSettings = new HashMap();
	accountSettings.put("merchantName", "{MERCHANT_NAME}");
	accountSettings.put("appId", "{APP_ID}");
    accountSettings.put("apiKey", "{API_KEY}"); //API Key
    accountSettings.put("publicKey", "{PUBLIC_KEY}"); //Public Key used for encryption, the format should be like this.
    //accountSettings.put("currency", "HKD"); // Currency (Default: HKD)
	//accountSettings.put("lang", "en"); // Lang
	accountSettings.put("queryTxnUrl", "https://gateway2.sandbox.tapngo.com.hk/paymentApi/payment/status"); //Query Txn URL
	accountSettings.put("paymentUrl", "https://gateway2.sandbox.tapngo.com.hk/web/payments"); //Payment URL
	accountSettings.put("recurrentPaymentUrl", "https://gateway2.sandbox.tapngo.com.hk/paymentApi/payment/recurrent"); //Recurrent Payment URL
	accountSettings.put("invalidateTokenUrl", "https://gateway2.sandbox.tapngo.com.hk/paymentApi/payment/recurrent/token/invalidation"); //Invalidate Recurrent Token
	accountSettings.put("registerAccessTokenUrl", "https://gateway2.sandbox.tapngo.com.hk/paymentApi/register/accessToken"); //Invalidate Recurrent Token
	accountSettings.put("notifyUrl", "{NOTIFY_URL}"); // Notify URL - Call after paid by Tap & Go by PSG
	accountSettings.put("returnUrl", "{RETURN_URL}"); // Return URL - Call after paid by Tap & Go or timeout
	accountSettings.put("batchGenHKQRUrl","https://gateway2.sandbox.tapngo.com.hk/paymentApi/create/batch/HKQR");
	accountSettings.put("queryBatchHKQRStatusUrl","https://gateway2.sandbox.tapngo.com.hk/paymentApi/query/batch/HKQR/status");
	accountSettings.put("downloadBatchHKQRStatusUrl","https://gateway2.sandbox.tapngo.com.hk/paymentApi/download/batch/HKQR");
	accountSettings.put("queryTxnHistoryUrl","https://gateway2.sandbox.tapngo.com.hk/paymentApi/query/transaction/history");
	accountSettings.put("downloadTxnHistoryUrl","https://gateway2.sandbox.tapngo.com.hk/paymentApi/download/tansaction/history");
	accountList.add(accountSettings);
	
 %>