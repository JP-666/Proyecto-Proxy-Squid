<?php
if (filter_var($_POST["nuevaip"], FILTER_VALIDATE_IP)) {
  $IP = $_POST["nuevaip"];
  echo "Procesando tu solicitud... Por favor espera mientras el router se reinicia";
  shell_exec("/srv/act.sh $IP  &");
} else {
  echo "Invalido!!";
}
