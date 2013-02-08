<?php
/**
 * Magic Drush Aliases
 * 
 * This will magically add all /sites/ directories within Drupal installations
 * to Drush's alias path setting. This can be used for both single and multisite
 * installations. It will also set the Drupal root and site according to the 
 * current working directory.
 * 
 * @author Christopher Roussel <christopher@impleri.net>
 * @version 0.4 Created on 5 February 2013
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

/**
 * Default Site Regex
 * Use this to define a default site by regular expression. If you are not within
 * a Drupal site folder but are within a Drupal installation, this will magically
 * assign a site which matches the regex as the Drupal URL.
 * Example: You use example.local for testing. Normally, you will have to be in
 * /path/to/drupal/sites/example.local in order for you to use drush without 
 * specifying the example.local site. However, this will allow you to use drush
 * from anywhere within /path/to/drupal without specifying the example.local site
 * unless you are in anoter sites directory (e.g. /path/to/drupal/sites/example.com)
 * @var string
 */
$default_site = '\.local';

// Set other Drush variables here
 // $options['dump-dir'] = $path . '/backups';


// Do not edit below this line

/**
 * Search Site
 * Simple function to recurse through a Drupal installation's sites folder
 * and set all subdirectories as paths that may contain Drush alias files.
 * 
 * @param string $dir The Drupal installation root directory to search
 * @param array $options The Drush $options variable
 */
function _search_site ($dir, &$options, $default_site=false) {
	$sites_dir = $dir . '/sites';
	if (is_dir($sites_dir)) {
		if ($dh = opendir($sites_dir)) {
			$current_path = getcwd();
			while (($site = readdir($dh)) !== false) {
				$site_path = $sites_dir . '/' . $site;
				
				if (!in_array($site, array('all', '.', '..')) && is_dir($site_path)) {
					// test to see if we are in a root with a site that matches the default site regex pattern and set that local site as the Drush URL
					$regex_match = (strpos($site_path, $options['r']) !== false && preg_match('/' . $default_site . '/', $site) == 1);
					if ($regex_match && empty($options['l'])) {
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
	_search_site($path, $options, $default_site);
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
				_search_site($single_root, $options, $default_site);
			}
			closedir($dh);
		}
	}
}

// finally set Drupal site to default if we've got nothing
if (empty($options['l'])) {
	$options['l'] = 'default';
}

