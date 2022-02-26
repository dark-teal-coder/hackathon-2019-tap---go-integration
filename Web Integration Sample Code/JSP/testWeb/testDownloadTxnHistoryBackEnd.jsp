<%@page import="java.net.*"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="okhttp3.*"%>
<%@page import="java.text.SimpleDateFormat"%>

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

    String queryString = "";
    queryString = "accessToken=" + accessToken;
    queryString += "&startDateTime=" + startDate;
    queryString += "&endDateTime=" + endDate;
	
	if (merTradeNo != null && !"".equals(merTradeNo)) {
		queryString += "&merTradeNo=" + merTradeNo;
	} 
	
	if (e2EId != null && !"".equals(e2EId)) {
		queryString += "&e2EId=" + e2EId;
	} 
	
	byte[] postData       = queryString.getBytes(StandardCharsets.UTF_8);
    int    postDataLength = postData.length;
	
    String paymentUrl = String.valueOf(accountSettings.get("downloadTxnHistoryUrl"));
	
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
    	strBuff.append(inputLine).append("\r\n");
    in.close();
	
	String resbody = strBuff.toString();
	byte[] resbodyByte = resbody.getBytes(StandardCharsets.US_ASCII);

    /*	
	
    OkHttpClient.Builder builder = new OkHttpClient.Builder().proxy(proxy);
    OkHttpClient client = builder.build();

    MediaType mediaType = MediaType.parse("application/x-www-form-urlencoded");
    RequestBody body = RequestBody.create(mediaType, queryString);
    Request requesttt = new Request.Builder()
            .url(paymentUrl)
            .post(body)
            // .addHeader("Content-Type", "application/x-www-form-urlencoded")
            .addHeader("Accept", "application/json")
            .addHeader("Cache-Control", "no-cache")
            .build();

    Response responsess = client.newCall(requesttt).execute();
	
    byte[] aa = responsess.body().bytes();

    String bb = new String(aa,"utf-8");
    byte[] aabyte = bb.getBytes(StandardCharsets.US_ASCII);
	*/

    //String filename = "D:/temp/testdownloadTxn_"+new SimpleDateFormat("yyyyMMdd").format(new Date())+".csv";
	//File outputFile = new File(filename);
	String filename = "testdownloadTxn_"+new SimpleDateFormat("yyyyMMdd").format(new Date())+".csv";
	File outputFile = File.createTempFile(filename,".tmp");
	
    FileOutputStream oStream = new FileOutputStream(outputFile, false);

    oStream.write(resbodyByte);
    oStream.write(("\r\n").getBytes());
    oStream.close();
	
	response.setContentType("application/octet-stream");
	response.setHeader("Content-Disposition", "attachment;filename=" +  "testdownloadTxn_"+new SimpleDateFormat("yyyyMMdd").format(new Date())+".csv");
	
	FileInputStream fileIn = new FileInputStream(outputFile);
	ServletOutputStream outFile = response.getOutputStream();

	byte[] outputByte = new byte[4096];
	//copy binary contect to output stream
	while(fileIn.read(outputByte, 0, 4096) != -1)
	{
		outFile.write(outputByte, 0, 4096);	
	}
	fileIn.close();
	outFile.flush();
	outFile.close();
	
	outputFile.deleteOnExit();

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Test Payment</title>
<script type="text/javascript">
function stringToArray(bufferString) {
	let uint8Array = new TextEncoder("utf-8").encode(bufferString);
	return uint8Array;
}

function saveFile(dat){
console.log("datadata");
var blob = new Blob([dat], {type: "application/csv"});
var link = document.createElement("a");
link.href = window.URL.createObjectURL(blob);
link.download = "testquery.csv";
link.click();
}
window.onload = saveFile(<%=resbodyByte%>);

</script>
</head>
<body >
Result:<br><textarea rows='20' cols='130'>
file downloaded at <%=filename%>;
</textarea>

</body>
<%
} catch (Exception e) {
    System.out.println("Exception: " + e.toString());
}
%>
</html>
