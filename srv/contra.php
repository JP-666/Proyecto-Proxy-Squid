<?php


session_start();

if (!isset($_SESSION['admin_user'])) die("Acceso denegado");

$nc = $_POST['contra'] ?? null;
$log = $_POST['salir'] ?? null;


$db = new mysqli("127.0.0.1", "urouter", "controuter", "router");
$newHash = password_hash($nc, PASSWORD_BCRYPT);
$sql = "UPDATE datoslogin SET contrahash = \"$newHash\" WHERE usuario = \"admin\";";
$db->query($sql);

echo "OK: Contraseña actualizada.";

if ($log == "salir") {
	session_destroy();
}

?>
