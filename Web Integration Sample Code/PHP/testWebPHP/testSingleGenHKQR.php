<?php include '_accountSettings.php' ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Test Single Gen HKQR</title>

</head>
<body>

<h1>Test Single Gen HKQR</h1>
<form action="https://gateway.sandbox.tapngo.com.hk/paymentApi/create/hkqr" method="post">
	<label>AccessToken:</label><input type="text" name="accessToken" ><br>
	<label>Amount:</label><input type="text" name="amount" /><br>
	<label>WithFPSId:</label>
	<select name="withFPSId" style="width:100px">
    	<option>Y</option>
         <option>N</option>
         </select>
         <br>
	<label>BillReference:</label><input type="text" name="billReference" /><br>
	<label>QrFormat:</label><select name="qrFormat" style="width:100px">
                            	<option>S</option>
                                 <option>I</option>
                                 </select>
                                 <br>
	<p><input type="submit" value="Single Gen HKQR"/></p>
</form>

</body>
</html>