<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Tap &amp; Go Integration</title>
</head>
<body>
<h1>Tap &amp; Go Integration</h1>
<table border="0" width="80%">
<tr><td><b>Payment</b></td></tr>
<tr><td>
<p><b>- Single Payment</b><br>
<input type="button" value="Payment" onclick="window.open('./testPayment.jsp','_blank');"/></p>
<p><b>- Recurrent Payment</b><br>
<input type="button" value="Request Recurrent Token" onclick="window.open('./testRecurrentToken.jsp','_blank');" />
<input type="button" value="Recurrent Payment" onclick="window.open('./testRecurrentPayment.jsp','_blank');" />
<input type="button" value="Invalidate Recurrent Token" onclick="window.open('./testInvalidateRecurrentToken.jsp','_blank');" />
</p>
<p><b>- Query Transaction Status</b><br>
<input type="button" value="Query Transaction" onclick="window.open('./testQueryTxn.jsp','_blank');" /></p>
</tr></td>
<tr><td>&nbsp;</td></tr>
<tr><td><b>Bill Payment HKQR</b></td></tr>
<tr><td><p><b>- Register Access Token for generate HKQR</b><br>
<input type="button" value="Register Access Token" onclick="window.open('./testRegisterAccessToken.jsp','_blank');" /></p>
<p><b>- Single generate HKQR</b><br>
<input type="button" value="Single generate HKQR" onclick="window.open('./testSingleGenHKQR.jsp','_blank');" /></p>
<p><b>- Batch generate HKQR</b><br>
<input type="button" value="Batch generate HKQR" onclick="window.open('./testBatchGenHKQR.jsp','_blank');" /></p>
<p><b>- Query Batch Generate HKQR Job Status</b><br>
<input type="button" value="Query Batch Generate HKQR Job Status" onclick="window.open('./testQueryBatchHKQRStatus.jsp','_blank');" /></p>
<p><b>- Download Batch Generate HKQR</b><br>
<input type="button" value="Download Batch Generate HKQR" onclick="window.open('./testDownloadBatchGenHKQR.jsp','_blank');" /></p>
</tr></td>
<tr><td>&nbsp;</td></tr>
<tr><td><b>Query Transaction History</b></td></tr>
<tr><td><p><b>- Register Access Token for download/query transaction history</b><br>
<input type="button" value="Register Access Token" onclick="window.open('./testRegisterAccessToken.jsp','_blank');" /></p>
<p><b>- Query Transaction History</b><br>
<input type="button" value="Query Transaction History" onclick="window.open('./testQueryTxnHistory.jsp','_blank');" /></p>
<p><b>- Download transaction History</b><br>
<input type="button" value="Download transaction History" onclick="window.open('./testDownloadTxnHistory.jsp','_blank');" /></p>
</td></tr>
</body>
</html>