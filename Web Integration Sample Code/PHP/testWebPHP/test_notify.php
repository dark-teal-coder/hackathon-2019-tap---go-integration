<!DOCTYPE html>
<html>
<body>

<h1>Notify page</h1>

<?php
foreach ($_REQUEST as $name => $value) {
    echo "<p>$name: $value<p/>";
}
//var_dump($_REQUEST);
?>

</body>
</html>