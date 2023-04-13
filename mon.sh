#!/bin/bash
curl="curl -sfkL"
sec="_username=$OMD_USERNAME&_secret=$OMD_SECRET"
arg="request_format=python&output_format=json"
host="http://$MONITOR_DOMAIN/$OMD_SITE/check_mk/webapi.py?$sec&$arg"

_add_host(){
	hostname=$1
	group=$2
	ip=$3
	action="add_host"
	host_info='request={"hostname":"'$hostname'","folder":"'$group'","attributes":{"ipaddress":"'$ip'","site":"'$OMD_SITE'","tag_agent":"cmk-agent"}}'
	$curl "$host&action=$action" -d $host_info
}
_monitor_activate() {
	_site=$1
	sec="_username=$OMD_USERNAME&_secret=$OMD_SECRET"
	su - $OMD_SITE -c "touch /omd/sites/$OMD_SITE/etc/check_mk/main.mk"
	action="activate_changes"
	host_info='request={"sites":["'$OMD_SITE'"]}'
	$curl "$host&action=$action" -d $host_info | jq
	su - $OMD_SITE -c "rm /omd/sites/$OMD_SITE/etc/check_mk/main.mk"
}

refresh_monitors() {
	su - $OMD_SITE -c "touch /omd/sites/$OMD_SITE/etc/check_mk/main.mk"
	su - $OMD_SITE -c 'cmk -v -II --flush;cmk -R'
	su - $OMD_SITE -c "rm /omd/sites/$OMD_SITE/etc/check_mk/main.mk"
}
$@
