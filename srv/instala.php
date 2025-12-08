<?php
  $paquete=$_POST["paquete"];
  $resultado=shell_exec("apk add " . $paquete); // Esto es una vulnerabilidad enorme, pues si alguien pasa el nombre de paquete como "paquete; (cosa maliciosa)" puede ejecutar comandos arbitrarios.
  echo str_replace("\n","<br>",$resultado);
?>

<br>

<a href="/">Volver al sitio principal</a>
