<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap" %>
<%@page import="java.util.ArrayList" %>
<%@ include file = "_accountSettings.jsp" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<body>
<h1>Test Recurrent Payment</h1>
<form action="testRecurrentPaymentBackEnd.jsp" method="post">
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
	<label>Total Price: </label><input type="text" name="totalPrice" value="0.01" /><br>
	<label>Remark: </label><input type="text" name="remark" value="remark" /><br>
	<label>Payment Type: R</label><input type="hidden" name="paymentType" value="R" /><br>
	<label>Language: </label><select name="lang">
	<option value="en">EN</option>
	<option value="zh">ZH</option>
	</select><br>
	<label>Currency: HKD</label><input type="hidden" name="currency" value="HKD" /><br>
	<label>Recurrent Token: </label><input type="text" name="recurrentToken" value="" /><br>
	<label>Remark:</label>
	<br>
	<label>Merchant can send recurrent payment requests by the recurrent token.</label><br>
	<p><input type="submit" value="Pay by Tap &amp GO"/></p>
</form>
</html>
</body>