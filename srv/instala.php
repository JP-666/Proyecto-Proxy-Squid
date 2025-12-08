<?php
$paquete=$_POST["paquete"];
$resultado=shell_exec("apk add " . $paquete);
echo str_replace("\n","<br>",$resultado);
?>

<br>

<a href="/">Volver al sitio principal</a>
