<?php include '_accountSettings.php' ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Test Download Batch HKQR</title>

</head>
<body>

<h1>Test Download Batch HKQR</h1>
<form action="testDownloadBatchGenHKQRBackEnd.php" method="post">
	<label>Merchant Name: </label>
	<select name="merchantName">
	<?php $i = 0; ?>
	<?php foreach($accountList as $account){ ?>
		<option value="<?php echo $i++; ?>"><?php echo $account["merchantName"]; ?></option>
	<?php } ?>

	</select>
	<br>
	<label>AccessToken:</label><input type="text" name="accessToken" ><br>
	<label>ticketNo:</label><input type="text" name="ticketNo" /><br>
	<p><input type="submit" value="Download Batch HKQR"/></p>
</form>

</body>
</html>