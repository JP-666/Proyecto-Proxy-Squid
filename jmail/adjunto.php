// He copiado casi todo el codigo de otra cosa

<?php
session_start();

if (!isset($_SESSION['admin_user'])) die("Acceso denegado");

if (isset($_GET['file']) && isset($_GET['user']) && isset($_GET['name'])) {
	$user = basename($_GET['user']);
	$file = basename($_GET['file']); // El .json
	$adjunto_name = basename($_GET['name']); // El nombre original del adjunto
	header('Content-Description: File Transfer');
	header('Content-Type: application/octet-stream');
	header('Content-Disposition: attachment; filename="' . $adjunto_name . '"');
	header('Expires: 0');
	header('Cache-Control: must-revalidate');
	header('Pragma: public');
	$u_arg = escapeshellarg($user);
	$f_arg = escapeshellarg($file);
	$comando = "sudo /usr/bin/leerweb.sh $u_arg ADJUNTO $f_arg";
	passthru($comando);
	exit;
}
?>
