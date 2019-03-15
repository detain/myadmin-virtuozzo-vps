{assign var=vps_os value=$vps_os|replace:'.tar.gz':''}
{assign var=ram value=$settings['slice_ram'] * $vps_slices}
{assign var=hd value=(($settings['slice_hd'] * $vps_slices) + $settings['additional_hd']) * 1024}
{assign var=cpus value=$vps_slices}
{if in_array($vps_custid, [2773, 8, 2304])}
{assign var=cpuunits value=1500 * 1.5 * $vps_slices}
{else}
{assign var=cpuunits value=1500 * $vps_slices}
{/if}
function iprogress() {
  curl --connect-timeout 60 --max-time 240 -k -d action=install_progress -d progress=$1 -d server={$vps_id} 'https://myvps2.interserver.net/vps_queue.php' < /dev/null > /dev/null 2>&1;
}
iprogress 10 &
prlctl create {$vzid} --vmtype ct --ostemplate {$vps_os};
iprogress 60 &
prlctl set {$vzid} --userpasswd root:{$rootpass};
prlctl set {$vzid} --swappages 1G --memsize {$ram}M;
prlctl set {$vzid} --hostname {$hostname};
prlctl set {$vzid} --device-add net --type routed --ipadd {$ip} --nameserver 8.8.8.8;
iprogress 70 &
prlctl set {$vzid} --cpus {$cpus};
prlctl set {$vzid} --cpuunits {$cpuunits};
prlctl set {$vzid} --device-set hdd0 --size {$hd};
iprogress 80 &
prlctl set {$vzid} --onboot yes ;
ports=" $(prlctl list -a -i |grep "Remote display:.*port=" |sed s#"^.*port=\([0-9]*\) .*$"#"\1"#g) ";
start=5901;
found=0;
while [ $found -eq 0 ]; do
  if [ "$(echo "$ports" | grep "$start")" = "" ]; then
	found=$start;
  else
	start=$(($start + 1));
  fi;
done;
prlctl set {$vzid} --vnc-mode manual --vnc-port $start --vnc-nopasswd --vnc-address 127.0.0.1;
iprogress 90 &
prlctl start {$vzid};
iprogress 100 &
