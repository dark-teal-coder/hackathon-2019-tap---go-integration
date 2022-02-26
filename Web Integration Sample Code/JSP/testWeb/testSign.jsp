<%@page import="org.apache.tomcat.util.codec.binary.*"%>
<%@page import="javax.crypto.Mac"%>
<%@page import="javax.crypto.spec.SecretKeySpec"%>
<%@page import="java.net.*"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="java.io.*"%>
<%@page import="org.apache.commons.codec.binary.StringUtils"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "_accountSettings.jsp" %>
<%

try {

    Base64 base64 =  new Base64(0, null, false);
    
    long currentTime = System.currentTimeMillis();
    
    String appId = String.valueOf(accountSettings.get("appId"));generate HKQR
    String publicKey = String.valueOf(accountSettings.get("publicKey"));
    byte[] publicKeyBytes = Base64.decodeBase64(publicKey);
    String apiKey = String.valueOf(accountSettings.get("apiKey"));
	
	//merTradeNo=TEST20180803101940&msg=Request succeeded&resultCode=0&tradeNo=180803217857&tradeStatus=TRADE_FINISHED
	
    String merTradeNo = "TEST20180803101940";
    //String paymentType = "S";
    
    //Arrange parameters in alphabetical order
    String queryString = "merTradeNo=TEST20180803101940&msg=Request succeeded&resultCode=0&tradeNo=180803217857&tradeStatus=TRADE_FINISHED";
	//String queryString = "{resultCode='0', returnUrl='null', merTradeNo='TEST20180803101940', msg='Request succeeded', tradeNo='180803217857', tradeStatus='TRADE_FINISHED', recurrentToken='', extras='null'}";
	//queryString = "appId=" + appId;
	//queryString += "&merTradeNo=" + merTradeNo;
	//queryString += "&timestamp=" + currentTime;
	
	Mac sha512_HMAC = null;
	
	//byte [] byteKey = apiKey.getBytes("UTF-8");
	byte [] byteKey = StringUtils.getBytesUtf8(apiKey);
    //final String HMAC_SHA512 = "HmacSHA256";
	final String HMAC_SHA512 = "SHA-256";
    sha512_HMAC = Mac.getInstance(HMAC_SHA512);      
    SecretKeySpec keySpec = new SecretKeySpec(byteKey, HMAC_SHA512);
    sha512_HMAC.init(keySpec);
    byte [] mac_data = sha512_HMAC.doFinal(queryString.getBytes("UTF-8"));
    //result = Base64.encode(mac_data);
    String b64_sign = base64.encodeToString(mac_data);
    
    
	/*
	String urlParameters  = queryString + "&sign=" + URLEncoder.encode(b64_sign,"UTF-8").replace("+","%20");
    byte[] postData       = urlParameters.getBytes(StandardCharsets.UTF_8);
    int    postDataLength = postData.length;
    String urlString        = String.valueOf(accountSettings.get("queryTxnUrl"));
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
 	 */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Test Payment</title>
</head>
<body>
Result:<br><textarea rows='20' cols='130'>
<% //=strBuff.toString().replace("><",">\n<")%>
<%=b64_sign%>
</textarea>
</body>
<%
} catch (Exception e) {
    System.out.println("Exception: " + e.toString());
}
%>
</html>