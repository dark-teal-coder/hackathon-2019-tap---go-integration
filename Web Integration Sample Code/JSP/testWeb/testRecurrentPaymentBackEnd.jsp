<%@page import="org.apache.tomcat.util.codec.binary.*"%>
<%@page import="javax.crypto.Mac"%>
<%@page import="javax.crypto.spec.SecretKeySpec"%>

<%@page import="javax.crypto.Cipher"%>
<%@page import="java.security.Key"%>
<%@page import="java.security.KeyFactory"%>
<%@page import="java.security.PrivateKey"%>
<%@page import="java.security.PublicKey"%>
<%@page import="java.security.spec.KeySpec"%>
<%@page import="java.security.spec.PKCS8EncodedKeySpec"%>
<%@page import="java.security.spec.X509EncodedKeySpec"%>
<%@page import="java.net.*"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="java.io.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "_accountSettings.jsp" %>
<%
try {

    Base64 base64 =  new Base64(0, null, false);
    
    long currentTime = System.currentTimeMillis();
    
    accountSettings = accountList.get(Integer.parseInt(request.getParameter("merchantName")));

    String appId = String.valueOf(accountSettings.get("appId")); // App ID
    String publicKeyString = String.valueOf(accountSettings.get("publicKey")); // Public Key
    byte[] publicKeyBytes = Base64.decodeBase64(publicKeyString); //Convert Public Key to byte[] 
    String apiKey = String.valueOf(accountSettings.get("apiKey")); // APIKey
    String merTradeNo = "Test" + currentTime; // MerTradeNo
    String lang = String.valueOf(request.getParameter("lang")); // Lang setting
    String currency = String.valueOf(request.getParameter("currency")); // Currency
    String notifyUrl = String.valueOf(accountSettings.get("notifyUrl")); // Notify URL
    String returnUrl = String.valueOf(accountSettings.get("returnUrl")); // Return URL
    String remark = request.getParameter("remark"); // Remark 
    String totalPrice = request.getParameter("totalPrice"); // Total Price
    String paymentType = request.getParameter("paymentType"); // S - Single Payment
    String recurrentToken = request.getParameter("recurrentToken");
    String transactionType = "CR";
    
  	//Prepare Payload in JSON format
    String plainPayload = "{\"currency\":\""+ currency +"\",\"merTradeNo\":\"" + merTradeNo + "\",\"lang\":\"" + lang + "\",\"notifyUrl\":\"" + notifyUrl + "\",\"totalPrice\":" + totalPrice + ",\"returnUrl\":\"" + returnUrl + "\"" + (remark != null && !remark.isEmpty() ? ",\"remark\":\"" + remark + "\"" : "") + "}";
    //String payload = base64.encodeToString(rsaService.encrypt(publicKeyBytes, StringUtils.getBytesUtf8(plainPayload)));
    
	//For the parameters that required to encrypt using RSA public key, the following information will be used.
	//Algorithm: RSA/ECB/OAEPWithSHA-1AndMGF1Padding
	//Public Key: The given RSA public key is Base64 Encoded, with 4096 bit key size 
	KeyFactory keyFactory = KeyFactory.getInstance("RSA");
	KeySpec publicKeySpec = new X509EncodedKeySpec(publicKeyBytes);
	PublicKey publicKey = keyFactory.generatePublic(publicKeySpec);
	Cipher rsa = Cipher.getInstance("RSA/ECB/OAEPWithSHA-1AndMGF1Padding", "SunJCE");
	rsa.init(Cipher.ENCRYPT_MODE, publicKey);
	String payload = base64.encodeToString(rsa.doFinal(StringUtils.getBytesUtf8(plainPayload))); //Encode the result bytes to a Base64 string
    
    //Arrange the parameters in alphabetical order
    String queryString = "";
	queryString = "appId=" + appId;
	queryString += "&payload=" + payload;
	queryString += "&recurrentToken=" + recurrentToken;
	queryString += "&timestamp=" + currentTime;
	queryString += "&transactionType=" + transactionType;
	
	//Create signature by HMSC_SHA512
	Mac sha512_HMAC = null;
	
	byte [] byteKey = apiKey.getBytes("UTF-8");
    final String HMAC_SHA512 = "HmacSHA512";
    sha512_HMAC = Mac.getInstance(HMAC_SHA512);      
    SecretKeySpec secretKeySpec = new SecretKeySpec(byteKey, HMAC_SHA512);
    sha512_HMAC.init(secretKeySpec);
    byte [] mac_data = sha512_HMAC.doFinal(queryString.getBytes("UTF-8"));
    String b64_sign = base64.encodeToString(mac_data);

    // Some characters (e.g. "+") in payload and sign should be handled by URLEncoder before sending the request 
	String urlParameters  = "appId=" + appId;
	urlParameters += "&payload=" + URLEncoder.encode(payload,"UTF-8").replace("+","%20");
	urlParameters += "&recurrentToken=" + recurrentToken;
	urlParameters += "&timestamp=" + currentTime;
	urlParameters += "&transactionType=" + transactionType;
	urlParameters += "&sign=" + URLEncoder.encode(b64_sign,"UTF-8").replace("+","%20");
	
    byte[] postData       = urlParameters.getBytes(StandardCharsets.UTF_8);
    int    postDataLength = postData.length;
    String urlString      = String.valueOf(accountSettings.get("recurrentPaymentUrl"));
    URL    url            = new URL(urlString);
    
    //With Proxy
    Proxy proxy = new Proxy(Proxy.Type.HTTP, new InetSocketAddress("proxy.pccw.com", 8080)); 
    HttpURLConnection conn= (HttpURLConnection) url.openConnection(proxy);
    
      //Without Proxy
    //HttpURLConnection conn= (HttpURLConnection) url.openConnection();
    
    conn.setDoOutput( true );
    conn.setInstanceFollowRedirects( false );
    conn.setRequestMethod( "POST" );
    conn.setRequestProperty( "Content-Type", "application/x-www-form-urlencoded"); 
    conn.setRequestProperty( "charset", "utf-8");
    conn.setRequestProperty( "Content-Length", Integer.toString(postDataLength));
    conn.setUseCaches(false);
     
    DataOutputStream wr = new DataOutputStream(conn.getOutputStream());
    wr.write(postData);
    wr.flush();
    
    BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
	StringBuffer strBuff = new StringBuffer();
 	 
 	String inputLine;
    while ((inputLine = in.readLine()) != null) 
    	strBuff.append(inputLine);
    in.close();
 	 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Test Payment</title>
</head>
<body>
Result:<br><textarea rows='20' cols='130'>
<%=strBuff.toString().replace("><",">\n<")%>
</textarea>
</body>

<%
} catch (Exception e) {
    System.out.println("Exception: " + e.toString());
}
%>
</html>