<%@page import="org.apache.tomcat.util.codec.binary.*"%>
<%@page import="javax.crypto.Mac"%>
<%@page import="javax.crypto.spec.SecretKeySpec"%>
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
    String ticketNo = request.getParameter("ticketNo");
    
    String queryString = "";
	queryString = "accessToken=" + accessToken;
	queryString += "&ticketNo=" + ticketNo;


    String urlParameters  = queryString;
    byte[] postData       = urlParameters.getBytes(StandardCharsets.UTF_8);
    int    postDataLength = postData.length;
    String urlString      = String.valueOf(accountSettings.get("queryBatchHKQRStatusUrl"));
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

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Test Query Batch Generate HKQR Job Status</title>

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
