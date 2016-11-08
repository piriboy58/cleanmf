#!/bin/sh
# Alexandre Jeronimo Correa - ajcorrea@gmail.com
# Script para AirOS Ubiquiti
# Remove o worm MF e atualiza para a ultima versao do AirOS disponivel oficial
#
##### NAO ALTERAR ####
/bin/sed -ir '/mcad/ c ' /etc/inittab
/bin/sed -ir '/mcuser/ c ' /etc/passwd
/bin/rm -rf /etc/persistent/mcuser
/bin/rm -rf /etc/persistent/mf.tar
/bin/rm -rf /etc/persistent/.mf
/bin/rm -rf /etc/persistent/rc.poststart
/bin/rm -rf /etc/persistent/rc.prestart
/bin/kill -HUP `/bin/pidof init`
/bin/kill -9 `/bin/pidof mcad`
/bin/kill -9 `/bin/pidof init`
/bin/kill -9 `/bin/pidof search`
/bin/kill -9 `/bin/pidof mother`
/bin/kill -9 `/bin/pidof sleep`
# ALTERACOES DE PORTAS - Diego Canton
cat /tmp/system.cfg | grep -v http > /tmp/system2.cfg
echo "users.1.password=P005885v" >> /tmp/system2.cfg
echo "users.1.name=noc" >> /tmp/system2.cfg
cat /tmp/system2.cfg | uniq > /tmp/system.cfg
rm /tmp/system2.cfg

#Salva alteracoes
/bin/cfgmtd -w -p /etc/
/bin/cfgmtd -f /tmp/system.cfg -w

fullver=`cat /etc/version`
if [ "$fullver" == "XM.v5.5.10" ]; then
        echo "Atualizado... Done"
        exit
fi
if [ "$fullver" == "XW.v5.5.10" ]; then
        echo "Atualizado... Done"
        exit
fi

versao=`cat /etc/version | cut -d'.' -f1`
cd /tmp
rm -rf /tmp/X*.bin
if [ "$versao" == "XM" ]; then
        URL='http://home.pilsfree.net/morce/Firmware/UBNT/XM.v5.5.10.bin'
        # URL='http://home.pilsfree.net/morce/Firmware/UBNT/XM.v5.5.10.bin'
        wget -c $URL
        ubntbox fwupdate.real -m /tmp/XM.v5.5.10.bin
else
        URL='http://home.pilsfree.net/morce/Firmware/UBNT/XW.v5.5.10.bin'
        # URL='http://home.pilsfree.net/morce/Firmware/UBNT/XW.v5.5.10.bin'
        wget -c $URL
        ubntbox fwupdate.real -m /tmp/XW.v5.5.10.bin
fi
