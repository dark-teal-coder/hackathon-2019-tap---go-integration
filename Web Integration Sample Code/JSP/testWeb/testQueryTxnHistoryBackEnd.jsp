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
<%@page import="okhttp3.*"%>

<%@page import="java.net.*"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="java.io.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "_accountSettings.jsp" %>    
<%
try {

    accountSettings = accountList.get(Integer.parseInt(request.getParameter("merchantName")));

    String accessToken = request.getParameter("accessToken");
    String startDate = request.getParameter("startDate");
    String endDate = request.getParameter("endDate");
	String merTradeNo = request.getParameter("merTradeNo");
    String e2EId = request.getParameter("e2EId");
	
	String urlParameters = "accessToken="+accessToken+"&startDateTime="+startDate+"&endDateTime="+endDate;
	if (merTradeNo != null && !"".equals(merTradeNo)) {
		urlParameters += "&merTradeNo=" + merTradeNo;
	} 
	
	if (e2EId != null && !"".equals(e2EId)) {
		urlParameters += "&e2EId=" + e2EId;
	} 
	
	byte[] postData       = urlParameters.getBytes(StandardCharsets.UTF_8);
    int    postDataLength = postData.length;
	
    String paymentUrl = String.valueOf(accountSettings.get("queryTxnHistoryUrl"));
	
	URL url = new URL(paymentUrl);

	//With Proxy
	Proxy proxy = new Proxy(Proxy.Type.HTTP, new InetSocketAddress("proxy.pccw.com", 8080));
	HttpURLConnection conn= (HttpURLConnection) url.openConnection(proxy);

	//Without Proxy
	//HttpURLConnection conn= (HttpURLConnection) url.openConnection();
	
	conn.setDoOutput( true );
    conn.setInstanceFollowRedirects( false );
    conn.setRequestMethod( "POST" );
    conn.setRequestProperty( "Content-Type", "application/x-www-form-urlencoded");
    conn.setRequestProperty( "Accept", "application/hal+json");
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
	
	String resbody = strBuff.toString();
	
	/*
    OkHttpClient.Builder builder = new OkHttpClient.Builder().proxy(proxy);
    OkHttpClient client = builder.build();


    String param = "accessToken="+accessToken+"&startDate="+startDate+"&endDate="+endDate;
    MediaType mediaType = MediaType.parse("application/x-www-form-urlencoded");
    RequestBody body = RequestBody.create(mediaType, param);
    Request requesttt = new Request.Builder()
            .url(paymentUrl)
            .post(body)
           // .addHeader("Content-Type", "application/x-www-form-urlencoded")
            .addHeader("Accept", "application/json")
            .addHeader("Cache-Control", "no-cache")
            .build();

    Response responsess = client.newCall(requesttt).execute();

    String resbody = responsess.body().string();
	*/

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Test Payment</title>

</head>
<body>
Result:<br>
<p>
<%=resbody%>
</p>
</body>

<%
} catch (Exception e) {
    System.out.println("Exception: " + e.toString());
}
%>
</html>
