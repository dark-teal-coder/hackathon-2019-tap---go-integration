<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.List"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@ page import="org.apache.commons.io.FilenameUtils"%>
<%@page import="java.io.*"%>

<%@page import="java.net.*"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="java.lang.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>


<%!
public String sendFileToServer(javax.servlet.jsp.JspWriter out, Map<String, String> parmas, String filename, String targetUrl) {
	
    String response = "error";
    
    HttpURLConnection connection = null;
    DataOutputStream outputStream = null;
    // DataInputStream inputStream = null;

    String pathToOurFile = filename;
    String urlServer = targetUrl;
    String lineEnd = "\r\n";
    String twoHyphens = "--";
    String boundary = "*****";
    DateFormat df = new SimpleDateFormat("yyyy_MM_dd_HH:mm:ss");

    int bytesRead, bytesAvailable, bufferSize;
    byte[] buffer;
    int maxBufferSize = 1 * 1024;
	
	try {
		//For debug only
		//out.println("Image filename: " + filename + "<br>");
		//out.println("url: " + targetUrl + "<br>");
    
        FileInputStream fileInputStream = new FileInputStream(new File(
                pathToOurFile));

        URL url = new URL(urlServer);
		
	//With Proxy
	Proxy proxy = new Proxy(Proxy.Type.HTTP, new InetSocketAddress("proxy.pccw.com", 8080));
	connection = (HttpURLConnection) url.openConnection(proxy);
	
	//Without Proxy
	//connection = (HttpURLConnection) url.openConnection();

        // Allow Inputs & Outputs
        connection.setDoInput(true);
        connection.setDoOutput(true);
        connection.setUseCaches(false);
        connection.setChunkedStreamingMode(1024);
        // Enable POST method
        connection.setRequestMethod("POST");

        connection.setRequestProperty("Connection", "Keep-Alive");
        connection.setRequestProperty("Content-Type",
                "multipart/form-data;boundary=" + boundary);
		connection.setRequestProperty( "Accept", "application/hal+json");
		connection.setRequestProperty( "charset", "utf-8");

        outputStream = new DataOutputStream(connection.getOutputStream());
        outputStream.writeBytes(twoHyphens + boundary + lineEnd);

        String connstr = null;
        connstr = "Content-Disposition: form-data; name=\"attachment\";filename=\""
                + pathToOurFile + "\"" + lineEnd;
        //out.println("Connstr: " + connstr + "<br>");

        outputStream.writeBytes(connstr);
        outputStream.writeBytes(lineEnd);

        bytesAvailable = fileInputStream.available();
        bufferSize = Math.min(bytesAvailable, maxBufferSize);
        buffer = new byte[bufferSize];

        // Read file
        bytesRead = fileInputStream.read(buffer, 0, bufferSize);
        //out.println("Image length: " + bytesAvailable + "<br>");
        try {
            while (bytesRead > 0) {
                try {
                    outputStream.write(buffer, 0, bufferSize);
                } catch (OutOfMemoryError e) {
                    e.printStackTrace();
                    response = "outofmemoryerror";
                    return response;
                }
                bytesAvailable = fileInputStream.available();
                bufferSize = Math.min(bytesAvailable, maxBufferSize);
                bytesRead = fileInputStream.read(buffer, 0, bufferSize);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response = "error - file";
            return response;
        }
        outputStream.writeBytes(lineEnd);
		
		// Upload POST Data
        Iterator<String> keys = parmas.keySet().iterator();
        while (keys.hasNext()) {
			
			String key = keys.next();
            String value = parmas.get(key);
			
			//out.println(key + ": " + value);

            outputStream.writeBytes(twoHyphens + boundary + lineEnd);
            outputStream.writeBytes("Content-Disposition: form-data; name=\"" + key + "\"" + lineEnd);
            outputStream.writeBytes("Content-Type: text/plain" + lineEnd);
            outputStream.writeBytes(lineEnd);
            outputStream.writeBytes(value);
            outputStream.writeBytes(lineEnd);
        }
		
        outputStream.writeBytes(twoHyphens + boundary + twoHyphens
                + lineEnd);
				
				
		BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream(), StandardCharsets.UTF_8));
		StringBuffer strBuff = new StringBuffer();
 	 
		String inputLine;
		while ((inputLine = in.readLine()) != null) 
			strBuff.append(inputLine);
		in.close();
		
/*			
        // Responses from the server (code and message)
        int serverResponseCode = connection.getResponseCode();

        String serverResponseMessage = connection.getResponseMessage();
        out.println("Server Response Code: " + serverResponseCode + "<br>");
        out.println("Server Response Message: " + serverResponseMessage + "<br>");

        if (serverResponseCode == 200) {
            response = "true";
        }
*/
		//Set return response
		response = strBuff.toString();

        String CDate = null;
        Date serverTime = new Date(connection.getDate());
        try {
            CDate = df.format(serverTime);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Date Exception: " +  e.getMessage() + " Parse Exception" + "<br>");
        }
        System.out.println("Server Response Time:" + CDate  + "<br>");

        filename = CDate
                + filename.substring(filename.lastIndexOf("."),
                        filename.length());
        System.out.println("File Name in Server : " + filename + "<br>");

        fileInputStream.close();
        outputStream.flush();
        outputStream.close();
        outputStream = null;
    } catch (Exception ex) {
        // Exception handling
        response = "error - Send file Exception: " + ex.getMessage() + "";
        ex.printStackTrace();
    }
    return response;
}
%>

<%
	
	//Local
	String urlString  = "https://gateway.sandbox.tapngo.com.hk/paymentApi/create/batch/HKQR";

	//Server
	//String urlString  = "http://localhost:8080/paymentApi/create/batch/HKQR";

	HashMap<String, String> params = new HashMap<String, String>();

    String saveDirectory = application.getRealPath("/upload");
    
    // Check that we have a file upload request
    boolean isMultipart = ServletFileUpload.isMultipartContent(request);
	//For debug only
    //out.println("isMultipart="+isMultipart+"<br>");
    
    // Create a factory for disk-based file items
    FileItemFactory factory = new DiskFileItemFactory();
 
    // Create a new file upload handler
    ServletFileUpload upload = new ServletFileUpload(factory);

    //Create a progress listener
    ProgressListener progressListener = new ProgressListener(){
       private long megaBytes = -1;
       public void update(long pBytesRead, long pContentLength, int pItems) {
           long mBytes = pBytesRead / 1000000;
           if (megaBytes == mBytes) {
               return;
           }
           megaBytes = mBytes;
           System.out.println("We are currently reading item " + pItems);
           if (pContentLength == -1) {
               System.out.println("So far, " + pBytesRead + " bytes have been read.");
           } else {
               System.out.println("So far, " + pBytesRead + " of " + pContentLength
                                  + " bytes have been read.");
           }
       }
    };
    upload.setProgressListener(progressListener);
    
    // Parse the request
    List /* FileItem */ items = upload.parseRequest(request);
    
    // Process the uploaded items
    Iterator iter = items.iterator(); 
    while (iter.hasNext()) {
        FileItem item = (FileItem) iter.next();

        if (item.isFormField()) {
            // Process a regular form field
            //processFormField(item);
            String name = item.getFieldName();
            String value = item.getString();
            value = new String(value.getBytes("UTF-8"), "ISO-8859-1");
            //out.println(name + "=" + value+"<br>");
			
			if ("accessToken".equals(name)) {
				params.put("accessToken", value);
			}
			
        } else {
            // Process a file upload
            //processUploadedFile(item);
            String fieldName = item.getFieldName();
            String fileName = item.getName();
            String contentType = item.getContentType();
            boolean isInMemory = item.isInMemory();
            long sizeInBytes = item.getSize();
			
			//For Debug only
            //out.println("fieldName="+fieldName+"<br>");
            //out.println("fileName="+fileName+"<br>");
            //out.println("contentType="+contentType+"<br>");
            //out.println("isInMemory="+isInMemory+"<br>");
            //out.println("sizeInBytes="+sizeInBytes+"<br>");
			
            if (fileName != null && !"".equals(fileName)) {
                fileName= FilenameUtils.getName(fileName);
                //out.println("fileName saved="+fileName+"<br>");
                File uploadedFile = new File(saveDirectory, fileName);
                item.write(uploadedFile);
            }
			
			out.println("Result:<br><textarea cols='130' rows='20'>" + sendFileToServer(out, params, saveDirectory + "/" + fileName, urlString) + "</textarea>");
        }
    }                
	
%>
