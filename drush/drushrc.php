<?php
/**
 * Drush RC File
 *
 * @author Christopher Roussel <christopher@impleri.net>
 * @version 0.5
 * @created 5 February 2013
 * @updated 10 September 2013
 * @license http://creativecommons.org/licenses/CC0/1.0/ CC0
 */

// Set other Drush variables here
$options['dump-dir'] = $path . '/backups';
$options['shell-aliases']['ca'] = 'cache-clear all';
$options['shell-aliases']['sup'] = 'pm-update --security-only';

/**
 * Base Root Path
 * 
 * This is the path to your Drupal installation(s). In the case 
 * of a single Drupal installation, this should be that path. 
 * In the case of multiple Drupal installations, this should be 
 * the directory in which all the Drupal installations are found.
 * @var array (default: /var/www/vhosts)
 */
$path = false;

/**
 * Local Site Regex
 * 
 * Use this to define a default site by regular expression. If you
 * are not within a Drupal site folder but are within a Drupal 
 * installation, this will magically assign a site which matches 
 * the regex as the Drupal URL.
 * 
 * Example: You use local.example.com for testing. Normally, you
 * will have to be in /path/to/drupal/sites/local.example.com in
 * order for you to use drush without specifying the 
 * local.example.com site. However, this will allow you to use drush
 * from anywhere within /path/to/drupal without specifying the
 * local.example.com site unless you are in another sites directory
 * (e.g. /path/to/drupal/sites/staging.example.com)
 * @var string (default: (\.lan|\.local|local\.))
 */
$local = false;

// do not edit below this line

require(__DIR__ . '/magic_aliases.php');
$magic_aliases = new \impleri\drush\DrushMagicAliases($options, $path, $local);
