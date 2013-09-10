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
 * @version 0.5
 * @created 5 February 2013
 * @updated 10 September 2013
 * @license http://creativecommons.org/licenses/CC0/1.0/ CC0
 */

namespace impleri\drush;

class DrushMagicAliases
{
	/**
	 * Base Root Path
	 * @var array
	 */
	private $path = array(
		'/var/www/vhosts'
	);

	/**
	 * Local Site Regex
	 * 
	 * Default local site regular expression.
	 * @var string
	 */
	private $local = '(\.lan|\.local|local\.)';

	/**
	 * Drush options array
	 * @var array
	 */
	public $options = array();

	/**
	 * Current Drupal installation root
	 * @var string
	 */
	private $root = '';

	/**
	 * Current Drupal site
	 * @var string
	 */
	private $site = '';

	/**
	 * Current working directory
	 * @var string
	 */
	private $cwd = '';

	
	/**
	 * Constructor
	 * @param  array $options Drush options
	 */
	public function __construct (&$options, $path = false, $local = false)
	{
		$this->options = &$options;
		$this->cwd = getcwd();

		if ($path) {
			$this->path = $path;
		}

		if ($local) {
			$this->local = $local;
		}

		$this->load();
	}

	/**
	 * Loader
	 *
	 * Loops through paths provided and searches them for Drupal installations.
	 */
	public function load ()
	{
		foreach ($this->path as $path) {
			// check to see if path is a single Drupal installation root
			if (is_dir($path . '/sites')) {
				$this->searchRoot($path);
			}
			else {
				$this->processDir($path);
			}
		}
	}

	/**
	 * Process Directory
	 *
	 * Given a $path, this method will check each subdirectory 
	 * (non-recursively) for a Drupal installation.
	 * @param  string $path Directory path to process
	 */
	protected function processDir ($path)
	{
  		if (is_dir($path)) {
    		if ($path_handler = opendir($path)) {
		    	while (($dir = readdir($path_handler)) !== false) {
       				$this->searchRoot($path . '/' . $dir);
      			}
      			closedir($path_handler);
    		}
  		}
	}

	/**
	 * Search Root
	 * 
	 * Simple function to recurse through a Drupal installation's sites 
	 * folder and set all subdirectories as paths that may contain 
	 * Drush alias files.
	 *
	 * @param string $dir The Drupal installation root directory to search
	 * @param array $options The Drush $options variable
	 */
	protected function searchRoot ($dir)
	{
		// test to see if we are in this Drupal installation
		if (strpos($this->cwd, $dir) !== false) {
        	$this->root = $this->options['r'] = $dir;
        }

		// Try to read the sites subdirectory if it exists
	    $sites_dir = $dir . '/sites';
	  	if (is_dir($sites_dir)) {
	    	if ($sites_handler = opendir($sites_dir)) {

	      		// loop through all sites in the Drupal installation
	      		while (($this->site = readdir($sites_handler)) !== false) {
	      			// set the site path as an alias path for drush
	      			$site_path = $sites_dir . '/' . $this->site;

	      			// ensure we're hitting actual Drupal sites which do exist
	      			if (!in_array($this->site, array('all', '.', '..')) && is_dir($site_path)) {
	      				$this->options['alias-path'][] = $site_path;

	      				// if site matches the local root regex, set it for drush
	        			if ($this->searchSite($site_path)) {
	        				$this->options['l'] = $this->site;
	        			}
	        		}
	      		}
	      		closedir($sites_handler);
	    	}
	  	}
	}

	/**
	 * Search Site
	 * Tests to see if the given site matches the current working directory.
	 *
	 * @param string $dir The Drupal site directory to test
	 * @param string $local The regex for the local site
	 * @param string $root The drush installaion root path
	 * @param boolean $empty_l Whether or not the drush `l` option is empty
	 * @return boolean True if the site tested is the current local site for drush
	 */
	protected function searchSite ($path)
	{
		$match = false;

	    // Are we somewhere under a Drupal site (e.g. sites/staging.example.com)
	    $site_match = (strpos($this->cwd, $path) !== false);

	    // Are we somewhere under a Drupal installation
	    $root_match = (strpos($path, $this->root) !== false);

	    // Does the indexed Drupal installation have a matching local site
	    // , $this->local, $options['r'], ))
	    $local_match = (preg_match('/' . $this->local . '/', $this->site) == 1);

	    // If we are under an explicit Drupal site OR if we are in a Drupal root that has a local site and site is not explicitly passed to drush
	    if ($site_match || ($root_match && $local_match && empty($this->options['l']))) {
	      	$match = true;
	   	}

	    return $match;
	}
}
