<?php include '_accountSettings.php' ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Test Register Access Token</title>
</head>
<body>

<h1>Test Register Access Token</h1>
<form action="testRegisterAccessTokenBackEnd.php" method="post">
	<label>Merchant Name: </label>
	<select name="merchantName">
    <?php $i = 0; ?>
    <?php foreach($accountList as $account){ ?>
        <option value="<?php echo $i++; ?>"><?php echo $account["merchantName"]; ?></option>
    <?php } ?>
	</select><br>
	<p><input type="submit" value="Register Access Token"/></p>
</form>

</body>
</html>