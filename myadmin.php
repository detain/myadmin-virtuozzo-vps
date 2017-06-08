<?php
/* TODO:
 - service type, category, and services  adding
 - dealing with the SERVICE_TYPES_virtuozzo define
 - add way to call/hook into install/uninstall
*/
return [
	'name' => 'Virtuozzo Vps',
	'description' => 'Allows selling of Virtuozzo Server and VPS License Types.  More info at https://www.netenberg.com/virtuozzo.php',
	'help' => 'It provides more than one million end users the ability to quickly install dozens of the leading open source content management systems into their web space.  	Must have a pre-existing cPanel license with cPanelDirect to purchase a virtuozzo license. Allow 10 minutes for activation.',
	'module' => 'licenses',
	'author' => 'detain@interserver.net',
	'home' => 'https://github.com/detain/myadmin-virtuozzo-vps',
	'repo' => 'https://github.com/detain/myadmin-virtuozzo-vps',
	'version' => '1.0.0',
	'type' => 'licenses',
	'hooks' => [
		'function.requirements' => ['Detain\MyAdminVirtuozzo\Plugin', 'Requirements'],
		'licenses.settings' => ['Detain\MyAdminVirtuozzo\Plugin', 'Settings'],
		'licenses.activate' => ['Detain\MyAdminVirtuozzo\Plugin', 'Activate'],
		'licenses.change_ip' => ['Detain\MyAdminVirtuozzo\Plugin', 'ChangeIp'],
		'ui.menu' => ['Detain\MyAdminVirtuozzo\Plugin', 'Menu']
	],
];
