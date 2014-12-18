<?php

namespace impleri\drush;

class generator.class
{
    private $indent = 4;

    private $defaults = array();

    private $data = array(
        'dev' => array(),
        'stage' => array(),
        'live' => array()
    );

    public function __construct ($config)
    {
        $this->defaults = require(__DIR__ . '/generator.config.php');

        // handle default settings
        $replacements = array(
            'SHORT' => $config['short'],
            'LONG' => $config['long']
        );

        foreach ($this->defaults as $key => $item) {
            $replace = array_merge($replacements, $this->defaults);
            $this->defaults[$key] = str_replace(array_keys($replace), array_values($replace), $item);
        }

        $this->build($config);
    }

    public function __toString()
    {
        return $this->render();
    }

    private function build ($config)
    {
        foreach ($this->data as $alias => &$data) {
            $root_key = 'path_' . $alias;
            $data['root'] = (isset($config[$root_key])) ? $config[$root_key] : $this->defaults[$root_key];

            $uri_key = 'site_' . $alias;
            $data['uri'] = (isset($config[$uri_key])) ? $config[$uri_key] : $this->defaults[$uri_key];

            $host_key = 'host_' . $alias;
            $data['remote-host'] = (isset($config[$host_key])) ? $config[$host_key] : $this->defaults[$host_key];

            $user_key = 'user_' . $alias;
            $data['remote-user'] = (isset($config[$user_key])) ? $config[$user_key] : $this->defaults[$user_key];

            $data['path-aliases'] = array();

            $dump_key = 'dump_' . $alias;
            $data['path-aliases']['%dump-dir'] = (isset($config[$dump_key])) ? $config[$dump_key] : $this->defaults[$dump_key];

            $data['path-aliases']['%files'] = $data['root'] . '/sites/' . $data['uri'] . '/files';
        }
    }

    private function render()
    {
        $output = array();
        $output[] = '<?php';
        $output[] = '// Aliases for ' . $this->data['live']['uri'];
        $output[] = '';

        foreach ($this->data as $alias => $array) {
            $output[] = sprintf('$aliases["%s"] = array(', $alias);
            $recursed = $this->recursiveRender($array, 1);
            $output = array_merge($output, $recursed);
            $output[] = ');';
            $output[] = '';
        }

        $output[] = '';

        return implode("\n", $output);
    }

    private function recursiveRender ($array, $depth=1)
    {
        $indent = str_repeat(' ', $depth*$this->indent);
        $output = array();
        foreach ($array as $key => $val) {
            if (is_array($val)) {
                $recursed = recursive_render($val, $depth+1);
                $output[] = $indent . "'" . $key . "' => array(";
                $output = array_merge($output, $recursed);
                $output[] = $indent . '),';
            } else {
                $output[] = $indent . "'" . $key . "' => '" . $val . "',";
            }
        }

        return $output;
    }
}

// generate PHP file

print($output);
