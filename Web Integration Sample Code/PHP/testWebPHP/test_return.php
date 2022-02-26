<!DOCTYPE html>
<html>
<body>
<h2>Return page</h2>
<?php
foreach ($_REQUEST as $name => $value) {
    echo "<p>$name: $value<p/>";
}
//var_dump($_REQUEST);
?>
</body>
</html>