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

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "_accountSettings.jsp" %>    
<%
try {
	
    //RSAService rsaService = new RSAService();
    Base64 base64 =  new Base64(0, null, false);
    
    long currentTime = System.currentTimeMillis();
	
	accountSettings = accountList.get(Integer.parseInt(request.getParameter("merchantName")));
	
/*
	String host = request.getScheme() + "://" + request.getServerName();
	if (request.getServerPort() != 433 && request.getServerPort() != 80) {
		host = host + ":" + request.getServerPort() ;
	}
*/
	
    String appId = String.valueOf(accountSettings.get("appId")); // App ID
    String publicKeyString = String.valueOf(accountSettings.get("publicKey")); // Public Key
    byte[] publicKeyBytes = Base64.decodeBase64(publicKeyString); //Convert Public Key to byte[] 
    String apiKey = String.valueOf(accountSettings.get("apiKey")); // APIKey
    String merTradeNo = "Test" + currentTime; // MerTradeNo
    //String lang = String.valueOf(accountSettings.get("lang")); // Language setting
	String lang = String.valueOf(request.getParameter("lang")); // Language setting
    //String currency = String.valueOf(accountSettings.get("currency")); // Currency
	String currency = String.valueOf(request.getParameter("currency")); // Currency
    String notifyUrl = String.valueOf(accountSettings.get("notifyUrl")); // Notify URL
    String returnUrl = String.valueOf(accountSettings.get("returnUrl")); // Return URL
    String remark = request.getParameter("remark"); // Remark 
    String totalPrice = request.getParameter("totalPrice"); // Total Price
    String paymentType = request.getParameter("paymentType"); // S - Single Payment
    
    String paymentUrl = String.valueOf(accountSettings.get("paymentUrl"));
    
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
	queryString += "&merTradeNo=" + merTradeNo;
	queryString += "&payload=" + payload; 
	queryString += "&paymentType=" + paymentType;
	
	//Create signature by HMSC_SHA512
	Mac sha512_HMAC = null;
	
	byte [] byteKey = apiKey.getBytes("UTF-8");
    final String HMAC_SHA512 = "HmacSHA512";
    sha512_HMAC = Mac.getInstance(HMAC_SHA512);      
    SecretKeySpec secretKeySpec = new SecretKeySpec(byteKey, HMAC_SHA512);
    sha512_HMAC.init(secretKeySpec);
    byte [] mac_data = sha512_HMAC.doFinal(queryString.getBytes("UTF-8"));
    //result = Base64.encode(mac_data);
    String b64_sign = base64.encodeToString(mac_data);

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Test Payment</title>
<script>
	//Auto Submit after document loaded
	function formSubmit()
	{
		document.form1.submit();
	}
</script>
</head>
<body 
onload="formSubmit();">
	<h1><%=publicKeyString%></h1>
	<h1><%=publicKeyBytes[1]%></h1>
	<form action="<%=paymentUrl%>" method="post" id="form1" name="form1">
		<label>appId:</label><input type="text" name="appId" value="<%=appId%>"/><br>
		<label>merTradeNo:</label><input type="text" name="merTradeNo" value="<%=merTradeNo%>" /><br>
		<label>payload:</label><input type="text" name="payload" value="<%=payload%>"/><br>
		<label>paymentType:</label><input type="text" name="paymentType" value="<%=paymentType%>"/><br>
		<label>sign:</label><input type="text" name="sign" value="<%=b64_sign%>"/><br>
		<label>totalPrice: <%=totalPrice%></label><br>
		<label>remark: <%=remark%></label>
		<p><input type="submit" value="Pay By Tap &amp; Go"/></p>
	</form>
</body>
<%
} catch (Exception e) {
    System.out.println("Exception: " + e.toString());
}
%>
</html>