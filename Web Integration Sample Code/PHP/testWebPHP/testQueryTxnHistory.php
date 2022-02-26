<?php include '_accountSettings.php' ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Test Query Transaction History</title>
</head>
<body>

<h1>Test Query Transaction History</h1>
<form action="testQueryTxnHistoryBackEnd.php" method="post">
    <label>Merchant Name: </label>
	<select name="merchantName">

	<?php $i = 0; ?>
	<?php foreach($accountList as $account){ ?>
		<option value="<?php echo $i++; ?>"><?php echo $account["merchantName"]; ?></option>
	<?php } ?>

	</select>
	<br>
	<label>AccessToken: </label><input type="text" name="accessToken" ><br>
    <label>startDate: </label><input type="text" name="startDate" value="20190101000000"/><label> (Format: yyyymmddhhmmss)</label><br>
    <label>endDate: </label><input type="text" name="endDate" value="20190201235959"/><label> (Format: yyyymmddhhmmss)</label><br>
	<label>merTradeNo: </label><input type="text" name="merTradeNo" value=""/><br>
	<label>End-to-End Id: </label><input type="text" name="e2EId" value=""/><br>
    <p><input type="submit" value="Query Transaction History"/></p>
</form>

</body>
</html>