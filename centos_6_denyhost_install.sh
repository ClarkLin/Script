#bin/sh

wget http://bm.jacashop.com/download/DenyHosts-2.6.tar.gz
tar -xzvf DenyHosts-2.6.tar.gz
cd DenyHosts-2.6
python setup.py install
cd /usr/share/denyhosts/
cp daemon-control-dist daemon-control
chown root daemon-control
chmod 700 daemon-control
grep -v "^#" denyhosts.cfg-dist > denyhosts.cfg
sed -i 's/PURGE_DENY\ \=/PURGE_DENY\ \=\ 10080m/' denyhosts.cfg
sed -i 's/DENY_THRESHOLD_INVALID\ \=\ 3/DENY_THRESHOLD_INVALID\ \=\ 5/' denyhosts.cfg
sed -i 's/HOSTNAME_LOOKUP=NO/HOSTNAME_LOOKUP=YES/' denyhosts.cfg
RESULT=`cat /etc/rc.local | grep /usr/share/denyhosts/daemon-control`
if [[ -z $RESULT ]]; then
	echo "/usr/share/denyhosts/daemon-control start" >> /etc/rc.local
fi
/usr/share/denyhosts/daemon-control start
