<?php

return array(
	'site_live' => '{SHORT}.com',
	'site_stage' => 'staging.{live_site}',
	'site_dev' => '{SHORT}.mysandbox.com',
	'path_root' => '/var/www/vhosts/{live_site}/',
	'path_live' => '{path_root}/httpdocs',
	'path_stage' => '{path_root}/staging',
	'path_dev' => '/var/www/vhosts/mysandbox.com/{SHORT}',
	'host_live' => 'myhost.com',
	'host_stage' => 'myhost.com',
	'host_dev' => 'mysandbox.com',
	'user_live' => 'liveuser',
	'user_stage' => 'liveuser',
	'user_dev' => 'devuser',
	'dump_live' => '',
	'dump_stage' => '',
	'dump_dev' => ''
);
