<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap" %>
<%@page import="java.util.ArrayList" %>
<%@ include file = "_accountSettings.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<body>
<h1>Test Payment</h1>
<form action="testInvalidateRecurrentTokenBackEnd.jsp" method="post">
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
	<label>Total Price:</label><input type="text" name="totalPrice" value="0.01" /><br>
	<label>Recurrent Token: </label><input type="text" name="recurrentToken" value="" /><br>
	<p><input type="submit" value="Invalidate Recurrent Token"/></p>
</form>
</html>
</body>