<%@page import="org.apache.tomcat.util.codec.binary.*"%>
<%@page import="javax.crypto.Mac"%>
<%@page import="javax.crypto.spec.SecretKeySpec"%>
<%@page import="java.net.*"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.nio.file.Path"%>
<%@page import="java.io.*"%>
<%@page import="okhttp3.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "_accountSettings.jsp" %>
<%

try {
	int BUFFER_SIZE = 4096;

	accountSettings = accountList.get(Integer.parseInt(request.getParameter("merchantName")));

    String accessToken = request.getParameter("accessToken");
    String ticketNo = request.getParameter("ticketNo");
    
    String queryString = "";
	queryString = "accessToken=" + accessToken;
	queryString += "&ticketNo=" + ticketNo;


    String urlParameters  = queryString;
    byte[] postData       = urlParameters.getBytes(StandardCharsets.UTF_8);
    int    postDataLength = postData.length;
    String urlString      = String.valueOf(accountSettings.get("downloadBatchHKQRStatusUrl"));
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
    
       if (conn.getResponseCode() == 200) {   
    //BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
	InputStream inputStream = conn.getInputStream();
	
	//String fileName ="D:/temp/testDownload_"+ticketNo+".zip";
    //File outputFile = new File(fileName);
	
	String filename = "testDownload_"+ticketNo+".zip";
	File outputFile = File.createTempFile(filename,".tmp");
	
    FileOutputStream outputStream  = new FileOutputStream(outputFile);
	
	StringBuffer strBuff = new StringBuffer();
	
	//response.setContentType("APPLICATION/OCTET-STREAM");   
	//response.setHeader("Content-Disposition","attachment; filename=\"" + filename + "\"");   
            
	int i;
	int bytesRead = -1;
	byte[] buffer = new byte[BUFFER_SIZE];
    while ((bytesRead = inputStream.read(buffer)) != -1) {
		outputStream.write(buffer, 0, bytesRead);
	}
			
	outputStream.close();
    inputStream.close();
	
	response.setContentType("application/octet-stream");
	response.setHeader("Content-Disposition", "attachment;filename=" +  "testDownload_" + ticketNo + ".zip");
	
	//File file = new File(fileName);
	
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
	
	//out.println("File downloaded in " + fileName);
	} else {
		out.println("Error: " + conn.getResponseCode() + " - " + conn.getResponseMessage());
	}
} catch (Exception e) {
    System.out.println("Exception: " + e.toString());
        out.println(e.toString());
}
%>
