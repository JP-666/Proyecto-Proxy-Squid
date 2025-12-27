<?php
session_start();
if (!isset($_SESSION['admin_user'])) {
	die("Acceso denegado: No estás logueado. <a href=\"index.php\">Volver al inicio</a>");
}

if (isset($_GET['file']) && isset($_GET['user'])) {
	$user = basename($_GET['user']);
	$file = basename($_GET['file']);
	header('Content-Description: File Transfer');
	header('Content-Type: application/json');
	header('Content-Disposition: attachment; filename="' . $file . '"');
	header('Expires: 0');
	header('Cache-Control: must-revalidate');
	header('Pragma: public');
	$u_arg = escapeshellarg($user);
	$f_arg = escapeshellarg($file);
	$comando = "sudo /usr/bin/leerweb.sh $u_arg LEER $f_arg";
	passthru($comando); // En vez de shell_exec... Parece que esto es marginalmente mas rapido. NO pasa a una variable.
	exit;
} else {
	echo "Me has pasado todos los parametros que necesitaba??";
}
?>
