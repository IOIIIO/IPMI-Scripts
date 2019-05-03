#!/bin/sh

# As this will be running as a cronjob we need to set the PATH's
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:

# Set the location of the file we will be dumping the IPMITOOL output to.
IPMIOUT="/tmp/ipmi-logger/ipmiout-dl320-g6"

GRAPHITE_HOST="<GRAPHITE-HOST-IP>"

# Pull the data we want from the HP machine, Via IPMITOOL
/usr/bin/ipmitool -I lanplus -H <TARGET-IP> -U <TARGET_IPMI_USERNAME> -P <TARGET_IPMI_PASSWORD> sdr elist full > ${IPMIOUT}

# Select what we are sending to Graphite
FAN_1="$(grep "Fan 1" ${IPMIOUT} | awk ' {print $10} ')"
FAN_2="$(grep "Fan 2" ${IPMIOUT} | awk ' {print $10} ')"
FAN_3="$(grep "Fan 3" ${IPMIOUT} | awk ' {print $10} ')"
FAN_4="$(grep "Fan 4" ${IPMIOUT} | awk ' {print $10} ')"
FAN_5="$(grep "Fan 5" ${IPMIOUT} | awk ' {print $10} ')"
FAN_6="$(grep "Fan 6" ${IPMIOUT} | awk ' {print $10} ')"
FAN_7="$(grep "Fan 7" ${IPMIOUT} | awk ' {print $10} ')"
AMBI_TEMP_1="$(grep -w "Temp 1" ${IPMIOUT} | awk ' {print $10} ')"
CPU1_TEMP="$(grep -w "Temp 2" ${IPMIOUT} | awk ' {print $10} ')"
CPU2_TEMP="$(grep -w "Temp 3" ${IPMIOUT} | awk ' {print $10} ')"
MEM_ZONE_1="$(grep -w "Temp 4" ${IPMIOUT} | awk ' {print $10} ')"
MEM_ZONE_2="$(grep -w "Temp 5" ${IPMIOUT} | awk ' {print $10} ')"
MEM_ZONE_3="$(grep -w "Temp 6" ${IPMIOUT} | awk ' {print $10} ')"
MEM_ZONE_4="$(grep -w "Temp 7" ${IPMIOUT} | awk ' {print $10} ')"
MEM_ZONE_5="$(grep -w "Temp 8" ${IPMIOUT} | awk ' {print $10} ')"
MEM_ZONE_6="$(grep -w "Temp 9" ${IPMIOUT} | awk ' {print $10} ')"
MEM_ZONE_7="$(grep -w "Temp 10" ${IPMIOUT} | awk ' {print $10} ')"
MEM_ZONE_8="$(grep -w "Temp 11" ${IPMIOUT} | awk ' {print $10} ')"
MEM_ZONE_9="$(grep -w "Temp 12" ${IPMIOUT} | awk ' {print $10} ')"
MEM_ZONE_10="$(grep -w "Temp 13" ${IPMIOUT} | awk ' {print $10} ')"
MEM_ZONE_11="$(grep -w "Temp 14" ${IPMIOUT} | awk ' {print $10} ')"
MEM_ZONE_12="$(grep -w "Temp 15" ${IPMIOUT} | awk ' {print $10} ')"
SYS_ZONE_1="$(grep -w "Temp 16" ${IPMIOUT} | awk ' {print $10} ')"
SYS_ZONE_2="$(grep -w "Temp 17" ${IPMIOUT} | awk ' {print $10} ')"
SYS_ZONE_3="$(grep -w "Temp 18" ${IPMIOUT} | awk ' {print $10} ')"
SYS_ZONE_4="$(grep -w "Temp 19" ${IPMIOUT} | awk ' {print $10} ')"
SYS_ZONE_5="$(grep -w "Temp 20" ${IPMIOUT} | awk ' {print $10} ')"
SYS_ZONE_6="$(grep -w "Temp 21" ${IPMIOUT} | awk ' {print $10} ')"
SYS_ZONE_7="$(grep -w "Temp 22" ${IPMIOUT} | awk ' {print $10} ')"
SYS_ZONE_8="$(grep -w "Temp 23" ${IPMIOUT} | awk ' {print $10} ')"
SYS_ZONE_9="$(grep -w "Temp 24" ${IPMIOUT} | awk ' {print $10} ')"
AMBI_TEMP_2="$(grep -w "Temp 25" ${IPMIOUT} | awk ' {print $10} ')"
SYS_ZONE_10="$(grep -w "Temp 26" ${IPMIOUT} | awk ' {print $10} ')"
SYS_ZONE_11="$(grep -w "Temp 27" ${IPMIOUT} | awk ' {print $10} ')"
SYS_ZONE_12="$(grep -w "Temp 28" ${IPMIOUT} | awk ' {print $10} ')"
STOR_ZONE="$(grep -w "Temp 29" ${IPMIOUT} | awk ' {print $10} ')"
AMBI_ZONE_3="$(grep -w "Temp 30" ${IPMIOUT} | awk ' {print $10} ')"
AMBI_ZONE_4="$(grep -w "Temp 31" ${IPMIOUT} | awk ' {print $10} ')"

# Magic time. Detect losses etc.
PSU_PRESENCE="$(grep "Power Supply 1" ${IPMIOUT} | awk ' {print $11} ')"
if [ ${PSU_PRESENCE} = 'Presence' ]; then
    PSU_PRES="1"
else
    PSU_PRES="0"
fi
FANS="$(grep "Fans" ${IPMIOUT} | awk ' {print $9} ')"
if [ ${FANS} = 'Redundancy' ]; then
    FAN_REDUN="0"
else
    FAN_REDUN="1"
fi

# Sent to Graphite
echo "dl320-g6.FAN.BLOCK_1 ${FAN_1}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.FAN.BLOCK_2 ${FAN_2}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.FAN.BLOCK_3 ${FAN_3}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.FAN.BLOCK_4 ${FAN_4}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.FAN.BLOCK_5 ${FAN_5}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.FAN.BLOCK_6 ${FAN_6}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.FAN.BLOCK_7 ${FAN_7}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.FAN.REDUN ${FAN_REDUN}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.AMBI.1 ${AMBI_TEMP_1}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.AMBI.2 ${AMBI_TEMP_2}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.AMBI.3 ${AMBI_TEMP_3}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.AMBI.4 ${AMBI_TEMP_4}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.CPU.1 ${CPU1_TEMP}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.CPU.2 ${CPU2_TEMP}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.MEM_ZONE.1 ${MEM_ZONE_1}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.MEM_ZONE.2 ${MEM_ZONE_2}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.MEM_ZONE.3 ${MEM_ZONE_3}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.MEM_ZONE.4 ${MEM_ZONE_4}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.MEM_ZONE.5 ${MEM_ZONE_5}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.MEM_ZONE.6 ${MEM_ZONE_6}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.MEM_ZONE.7 ${MEM_ZONE_7}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.MEM_ZONE.8 ${MEM_ZONE_8}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.MEM_ZONE.9 ${MEM_ZONE_9}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.MEM_ZONE.10 ${MEM_ZONE_10}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.MEM_ZONE.11 ${MEM_ZONE_11}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.MEM_ZONE.12 ${MEM_ZONE_12}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.SYS_ZONE.1 ${SYS_ZONE_1}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.SYS_ZONE.2 ${SYS_ZONE_2}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.SYS_ZONE.3 ${SYS_ZONE_3}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.SYS_ZONE.4 ${SYS_ZONE_4}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.SYS_ZONE.5 ${SYS_ZONE_5}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.SYS_ZONE.6 ${SYS_ZONE_6}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.SYS_ZONE.7 ${SYS_ZONE_7}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.SYS_ZONE.8 ${SYS_ZONE_8}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.SYS_ZONE.9 ${SYS_ZONE_9}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.SYS_ZONE.10 ${SYS_ZONE_10}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.SYS_ZONE.11 ${SYS_ZONE_11}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.SYS_ZONE.12 ${SYS_ZONE_12}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.TEMP.STOR_ZONE ${STOR_ZONE}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.PSU.PRES ${PSU_PRES}" | nc -q0 ${GRAPHITE_HOST} 2003
rm -rf ${IPMIOUT}

exit