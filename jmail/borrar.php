<?php
session_start();
if (!isset($_SESSION['admin_user'])) {
	die("Acceso denegado: No estás logueado. <a href=\"index.php\">Volver al inicio</a>");
}

if (isset($_GET['file']) && isset($_GET['user'])) {
	$user = basename($_GET['user']);
	$file = basename($_GET['file']);
	$u_arg = escapeshellarg($user);
	$f_arg = escapeshellarg($file);
	$comando = "sudo /usr/bin/leerweb.sh $u_arg BORRAR $f_arg";
	passthru($comando);
	exit;
} else {
	echo "Me has pasado todos los parametros que necesitaba??";
}
?>
