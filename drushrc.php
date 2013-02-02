<?php
/**
 * Magic Drush Aliases
 * 
 * This will magically add all /sites/ directories within Drupal installations
 * to Drush's alias path setting. This can be used for mutlisite installations
 * or with multiple single-site installations.
 * 
 * @author Christopher Roussel <christopher@impleri.net>
 * @version 0.2 Created on 2 February 2013
 * @license CC0
 * @license http://creativecommons.org/licenses/CC0/1.0/
 */
 
/**
 * Multisite example:
 * You use Drupal Multisite for many different locations. Drupal is installed at
 * /var/www/vhosts/drupal. The settings below will look at every sites directory
 * except /all and set each as an alias path. That way, Site-specific Drush aliases 
 * can live in sites/example.com, sites/default.net, and sites/somewhere.org. Each
 * sites folder can be a separate git repo without knowing the existence of other
 * sites (great for separate development projects within the same organisation!).
 * Additionally, this will also check the current path and set the Drupal site URL 
 * if you are working within a specific site (to save having to use the @ alias or
 * the -l options in Drush).
 *
 * Multiple single-site example:
 * You use individual Drupal installations for many different locations. Most 
 * directories within /var/www/vhosts are separate Drupal installations (e.g. 
 * /var/www/vhosts/example.com and /var/www/vhosts/somewhere.org). By setting
 * $multi_root to false, the below script will recurse through each directory
 * within /var/www/vhosts and check for a sites directory and then act similar
 * to the Multisite example above by recursing through each directory within /sites/
 * and adding them to Drush's site alias. This is so you can use Multisite for
 * development purposes (e.g. a development, staging, and production site).
 * Additionally, this will check the current path and set the Drupal root and 
 * site URL if you are working within a specific directory (again, to save having
 * to use the @ alias, -l option, and -r option in Drush).
 */

/**
 * Base Root Path
 * This is the directory **ABOVE** the Drupal installation root
 * @var string
 */
$path = '/var/www/vhosts';

/**
 * Multisite Root Path
 * The directory to the multisite Drupal installation
 * Set to false to recurse through directories within $path (above)
 * @var string|boolean
 */
$multi_root = $path . '/drupal';

// Set other Drush variables here

/**
 * Drush DB Dump Directory
 * This is the Drush dump directory
 * For simplicity's sake, this should be outside of the drupal installation root
 * @var string
 */
$options['dump-dir'] = $path . '/backup';


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

// add multisite folders to alias path
if ($multi_root) {
	$options['r'] = $multi_root;

	// add aliases
	_search_site($multi_root, $options);
}

// add multi single-install folders to alias path
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
				_search_site($site_root, $options);
			}
			closedir($dh);
		}
	}
}

