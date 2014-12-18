<?php

$settings = (isset($_SERVER['argv'][1])) ? $_SERVER['argv'][1] : false;

// nothing to do here
if (!$settings) {
	return;
}

// if path is not to a php file, add the default file name
if (substr($settings, -4) != '.php') {
	if (substr($settings, -1) != '/') {
		$settings .= '/';
	}
	$settings .= 'generator.settings.php';
}

if (!file_exists($settings)) {
	// throw error if settings do not exist
	die('Unable to load settings file from ' . $settings);
}

$config = require($settings);
require(__DIR__ . '/generator.class.php');

$generator = new \impleri\drush\AliasesGenerator($config);
print($generator);
