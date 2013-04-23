<?php

$conf['endpoint']['local'] = 'http://lofd.tw.rpi.edu/sparql';
$conf['home'] = '/var/www/lodspeakr/';
$conf['basedir'] = 'http://lofd.tw.rpi.edu/';
$conf['debug'] = false;

$conf['ns']['local']   = 'http://lofd.tw.rpi.edu';

// Cherry-picked components (see https://github.com/alangrafu/lodspeakr/wiki/Reuse-cherry-picked-components-from-other-repositories)
//$conf['components']['services'][] = '/home/lofd/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/services/namedGraphs';
$conf['components']['services'][] = '/home/lofd/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/services/graph';

$conf['mirror_external_uris'] = false;

//Variables in  can be used to store user info.
//For examples, 'title' will be used in the header
//(you can forget about all conventions and use your own as well)
$lodspk['title'] = 'LODSPeaKr';
?>
