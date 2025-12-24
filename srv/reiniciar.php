<?php

// Esto reinicia el sistema

session_start();

if (!isset($_SESSION['admin_user'])) die("No has iniciado sesion en el router");

echo "<p>Se esta reiniciando el sistema</p>";
shell_exec("sudo /sbin/reboot"); // Tenemos que tener sudo

?>
