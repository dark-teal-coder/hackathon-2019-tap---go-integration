<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "_accountSettings.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Test Download Batch HKQR</title>

</head>
<body>

<h1>Test Download Batch HKQR</h1>
<form action="testDownloadBatchGenHKQRBackEnd.jsp" method="post">
	<label>Merchant Name: </label>
	<select name="merchantName">
	<%
		int i=0;
		for (HashMap account : accountList) {
	%>	
			<option value="<%=i++%>"><%=account.get("merchantName")%></option>
	<%
		}
	%>
	</select><br>
	<label>AccessToken:</label><input type="text" name="accessToken" ><br>
	<label>ticketNo:</label><input type="text" name="ticketNo" /><br>
	<p><input type="submit" value="Query Batch HKQR job status"/></p>
</form>

</body>
</html>