<?php 

// Variables are stored in /etc/apache2/envvars
$file = '/etc/apache2/envvars';

echo file_get_contents($file);

echo '<pre>'.print_r($_ENV, true).'</pre>';

// Try our other file too
$file = '/tmp/addl-settings';

echo file_get_contents($file);

//phpinfo(); 
?>
