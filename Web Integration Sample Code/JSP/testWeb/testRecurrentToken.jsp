<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "_accountSettings.jsp" %>
<html>
<body>
<h1>Test Request for Recurrent Token</h1>
<form action="testPaymentBackEnd.jsp" method="post">
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
	<br>
	<label>Remark: R - Recurrent</label>
	<br>
	<label>It is used to get a customer's authorized payment token such that merchant can send recurrent payment requests.<br>
	Upon successful authorization, Tap &amp; Go returns a token to Merchant Web/Mobile App.</label>
	<p><input type="submit" value="Request Recurrent Token"/></p>
</form>
</html>
</body>