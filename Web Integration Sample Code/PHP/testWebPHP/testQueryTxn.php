<?php include '_accountSettings.php' ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Test Query Payment Status</title>
</head>
<body>
<h1>Test Query Payment Status</h1>
<form action="testQueryTxnBackEnd.php" method="post">
<label>Merchant Name: </label>
<select name="merchantName">

<?php $i = 0; ?>
<?php foreach($accountList as $account){ ?>
	<option value="<?php echo $i++; ?>"><?php echo $account["merchantName"]; ?></option>
<?php } ?>

</select><br>
<label>Merchant Trade No:</label><input type="text" name="merTradeNo" value="Test123456" /><br>
<p><input type="submit" value="Query Transaction"/></p>
</form>
</html>
</body>