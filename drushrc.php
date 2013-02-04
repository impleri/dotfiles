<?php
/**
 * Magic Drush Aliases
 * 
 * This will magically add all /sites/ directories within Drupal installations
 * to Drush's alias path setting. This can be used for both single and multisite
 * installations.
 * 
 * @author Christopher Roussel <christopher@impleri.net>
 * @version 0.3 Created on 2 February 2013
 * @license CC0
 * @license http://creativecommons.org/licenses/CC0/1.0/
 */
 
/**
 * Base Root Path
 * This is the path to your Drupal installation(s). In the case of a single
 * Drupal installation, this should be that path. In the case of multiple Drupal
 * installations, this should be the directory in which all the Drupal
 * installations are found.
 * @var string
 */
$path = '/var/www/vhosts';

// Set other Drush variables here
// $options['dump-dir'] = '~/.drush/backups';


// Do not edit below this line

/**
 * Search Site
 * Simple function to recurse through a Drupal installation's sites folder
 * and set all subdirectories as paths that may contain Drush alias files.
 * 
 * @param string $dir The Drupal installation root directory to search
 * @param array $options The Drush $options variable
 */
function _search_site ($dir, &$options) {
	$sites_dir = $dir . '/sites';
	if (is_dir($sites_dir)) {
		if ($dh = opendir($sites_dir)) {
			$current_path = getcwd();
			while (($site = readdir($dh)) !== false) {
				$site_path = $sites_dir . '/' . $site;
				
				if ($site != 'all' && is_dir($site_path)) {
					// test to see if we are in this site directory and set the Drush URL
					if (strpos($current_path, $site_path) !== false) {
						$options['l'] = $site;
					}
				
					// add the alias path
					$options['alias-path'][] = $site_path;
				}
			}
			closedir($dh);
		}
	}
}

// check to see if we're in a multisite to save time
if (is_dir($path . '/sites')) {
	$options['r'] = $path;

	// add aliases
	_search_site($path, $options);
}

// otherwise go the long way
else {
	if (is_dir($path)) {
		if ($dh = opendir($path)) {
			$current_path = getcwd();
			while (($dir = readdir($dh)) !== false) {
				// test to see if we are in this site directory and set the Drush root
				$single_root = $path . '/' . $dir;
				if (strpos($current_path, $single_root) !== false) {
					$options['r'] = $single_root;
				}
				
				// add aliases
				_search_site($single_root, $options);
			}
			closedir($dh);
		}
	}
}

