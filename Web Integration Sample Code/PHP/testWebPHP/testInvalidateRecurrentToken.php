<?php include '_accountSettings.php' ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<body>
<h1>Test Payment</h1>
<form action="testInvalidateRecurrentTokenBackEnd.php" method="post">
	<label>Merchant Name: </label>
	<select name="merchantName">

	<?php $i = 0; ?>
	<?php foreach($accountList as $account){ ?>
		<option value="<?php echo $i++; ?>"><?php echo $account["merchantName"]; ?></option>
	<?php } ?>

	</select>
	<br>
	<label>Total Price:</label><input type="text" name="totalPrice" value="0.01" /><br>
	<label>Recurrent Token: </label><input type="text" name="recurrentToken" value="" /><br>
	<p><input type="submit" value="Invalidate Recurrent Token"/></p>
</form>
</html>
</body>