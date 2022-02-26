<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap" %>
<%@page import="java.util.ArrayList" %>
<%@ include file = "_accountSettings.jsp" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Test Download Transaction History</title>
</head>
<body>

<h1>Test Download Transaction History</h1>
<form action="testDownloadTxnHistoryBackEnd.jsp" method="post">
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
    <label>startDate:</label><input type="text" name="startDate" value="20190101000000"/><br>
    <label>endDate:</label><input type="text" name="endDate" value="20190301235959"/><br>
	<label>merTradeNo: </label><input type="text" name="merTradeNo" value=""/><br>
	<label>End-to-End Id: </label><input type="text" name="e2EId" value=""/><br>
    <p><input type="submit" value="Query Batch HKQR job status"/></p>
</form>

</body>
</html>