#!/bin/sh
# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL Channel
# ###########################################
#
# Command: wget https://raw.githubusercontent.com/emil237/channel-nagi/main/installer.sh -qO - | /bin/sh
#
# ###########################################

###########################################
# Configure where we can find things here #
TMPDIR='/tmp'
PACKAGE='astra-sm'
MY_URL='https://raw.githubusercontent.com/emil237/channel-nagi/main'
VERSION=$(wget $MY_URL/version -qO- | cut -d "=" -f2-)
BINPATH=/usr/bin
ETCPATH=/etc
ASTRAPATH=${ETCPATH}/astra
BBCPMT=${BINPATH}/bbc_pmt_starter.sh
BBCPY=${BINPATH}/bbc_pmt_v6.py
BBCENIGMA=${BINPATH}/enigma2_pre_start.sh
SYSCONF=${ETCPATH}/sysctl.conf
ASTRACONF=${ASTRAPATH}/astra.conf
ABERTISBIN=${ASTRAPATH}/scripts/abertis
CONFIGpmttmp=${TMPDIR}/bbc_pmt_v6/bbc_pmt_starter.sh
CONFIGpytmp=${TMPDIR}/bbc_pmt_v6/bbc_pmt_v6.py
CONFIGentmp=${TMPDIR}/bbc_pmt_v6/enigma2_pre_start.sh
CONFIGsysctltmp=${TMPDIR}/${PACKAGE}/sysctl.conf
CONFIGastratmp=${TMPDIR}/${PACKAGE}/astra.conf
CONFIGabertistmp=${TMPDIR}/${PACKAGE}/abertis
if [ -f /etc/opkg/opkg.conf ]; then
STATUS='/var/lib/opkg/status'
OSTYPE='Opensource'
OPKG='opkg update'
OPKGINSTAL='opkg install'
fi
rm -rf /etc/enigma2/lamedb
rm -rf /etc/enigma2/*list
rm -rf /etc/enigma2/*.tv
rm -rf /etc/enigma2/*.radio
rm -rf /etc/tuxbox/*.xml
install() {
if grep -qs "Package: $1" $STATUS; then
echo
else
$OPKG >/dev/null 2>&1
echo "   >>>>   Need to install $1   <<<<"
echo
$OPKGINSTAL "$1"
sleep 1
clear
fi
}
if [ $OSTYPE = "Opensource" ]; then
for i in dvbsnoop $PACKAGE; do
install $i
done
fi
case $(uname -m) in
armv7l*) plarform="arm" ;;
mips*) plarform="mips" ;;
esac
rm -rf ${ASTRACONF} ${SYSCONF}
rm -rf ${TMPDIR}/channels_backup_by_nagi-new_fullsat.tar.gz astra-* bbc_pmt_v6*
echo
set -e
echo "Downloading And Insallling Channel Please Wait ......"
wget $MY_URL/channels_backup_by_nagi-new_fullsat.tar.gz -qP $TMPDIR
tar -zxf $TMPDIR/channels_backup_by_nagi-new_fullsat.tar.gz -C /
sleep 5
set +e
echo
echo "   >>>>   Reloading Services - Please Wait   <<<<"
wget -qO - http://127.0.0.1/web/servicelistreload?mode=0 >/dev/null 2>&1
sleep 2
echo
echo "---------------------------------------------"
cd /tmp
set -e
if which dpkg > /dev/null 2>&1; then
wget "https://github.com/emil237/channel-nagi/raw/main/astra-mips.tar.gz"
wait
tar -xzf astra-mips.tar.gz  -C /
wait
chmod 755 /etc/astra/astra.conf
chmod 755 /etc/astra/abertis
chmod 755 /etc/astra/sysctl.conf
chmod 755 /etc/astra/scripts/abertis
chmod 755 /etc/astra/scripts/astra
chmod 755 /etc/init.d/astra-sm
chmod 755 /usr/bin/bbc_pmt_v6.py
chmod 755 /usr/bin/bbc_pmt_starter.sh
chmod 755 /usr/bin/enigma2_pre_start.sh
rm -f astra-mips.tar.gz
else
wget "https://github.com/emil237/channel-nagi/raw/main/astra-arm.tar.gz"
wait
tar -xzf astra-arm.tar.gz  -C /
wait
cd ..
set +e
rm -f /tmp/astra-arm.tar.gz
chmod 755 /etc/astra/astra.conf
chmod 755 /etc/astra/abertis
chmod 755 /etc/astra/sysctl.conf
chmod 755 /etc/astra/scripts/abertis
chmod 755 /etc/astra/scripts/astra
chmod 755 /etc/init.d/astra-sm
chmod 755 /usr/bin/bbc_pmt_v6.py
chmod 755 /usr/bin/bbc_pmt_starter.sh
chmod 755 /usr/bin/enigma2_pre_start.sh
fi
rm -rf ${TMPDIR}/channels_backup_by_nagi-new_fullsat.tar.gz
sync
echo ""
echo "*********************************************************"
echo "#       Channel And Config INSTALLED SUCCESSFULLY       #"
echo "   UPLOADED Script BY  >>>>   EMIL_NABIL "
sleep 4;
echo '========================================================================================================================='
echo "#                    ${VERSION}                         #"
echo "*********************************************************"
echo "#           your Device will RESTART Now                #"
echo "*********************************************************"
sleep 2
if [ $OSTYPE = "Opensource" ]; then
init 6
else
systemctl restart enigma2
fi
exit 0




