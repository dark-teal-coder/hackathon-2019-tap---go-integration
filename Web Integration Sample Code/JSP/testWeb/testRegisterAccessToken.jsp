<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "_accountSettings.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Test Register Access Token</title>
</head>
<body>

<h1>Test Register Access Token</h1>
<form action="testRegisterAccessTokenBackEnd.jsp" method="post">
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
	<p><input type="submit" value="Register Access Token"/></p>
</form>

</body>
</html>