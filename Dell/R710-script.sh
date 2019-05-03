#!/bin/sh

# As this will be running as a cronjob we need to set the PATH's
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:

# Set the location of the file we will be dumping the IPMITOOL output to.
IPMIOUT="/tmp/ipmi-logger/ipmiout-r710"

GRAPHITE_HOST="<GRAPHITE-HOST-IP>"

# Pull the data we want from the HP machine, Via IPMITOOL
/usr/bin/ipmitool -I lanplus -H <TARGET-IP> -U <TARGET_IPMI_USERNAME> -P <TARGET_IPMI_PASSWORD> sdr elist full > ${IPMIOUT}
/usr/bin/ipmitool -I lanplus -H <TARGET-IP> -U <TARGET_IPMI_USERNAME> -P <TARGET_IPMI_PASSWORD> sensors > ${IPMIOUT}-1

# Select what we are sending to Graphite
FAN_1="$(grep "FAN 1" ${IPMIOUT} | awk ' {print $11} ')"
FAN_2="$(grep "FAN 2" ${IPMIOUT} | awk ' {print $11} ')"
FAN_3="$(grep "FAN 3" ${IPMIOUT} | awk ' {print $11} ')"
FAN_4="$(grep "FAN 4" ${IPMIOUT} | awk ' {print $11} ')"
FAN_5="$(grep "FAN 5" ${IPMIOUT} | awk ' {print $11} ')"
AMBI_TEMP="$(grep -w "Ambient Temp" ${IPMIOUT} | awk ' {print $10} ')"
PLAN_TEMP="$(grep -w "Planar Temp" ${IPMIOUT} | awk ' {print $10} ')"
POWER_METER="$(grep -w "System Level" ${IPMIOUT} | awk ' {print $10} ')"
VOLT1="$(grep -w "96h" ${IPMIOUT} | awk ' {print $9} ')"
VOLT2="$(grep -w "97h" ${IPMIOUT} | awk ' {print $9} ')"
AMP1="$(grep -w "94h" ${IPMIOUT} | awk ' {print $9} ')"
AMP2="$(grep -w "95h" ${IPMIOUT} | awk ' {print $9} ')"
TEMP1="$(grep -w "01h" ${IPMIOUT} | awk ' {print $9} ')"
TEMP2="$(grep -w "02h" ${IPMIOUT} | awk ' {print $9} ')"
TEMP3="$(grep -w "05h" ${IPMIOUT} | awk ' {print $9} ')"
TEMP4="$(grep -w "06h" ${IPMIOUT} | awk ' {print $9} ')"
TEMP5="$(grep -w "0Ah" ${IPMIOUT} | awk ' {print $9} ')"
TEMP6="$(grep -w "0Bh" ${IPMIOUT} | awk ' {print $9} ')"
TEMP7="$(grep -w "0Ch" ${IPMIOUT} | awk ' {print $9} ')"

WATT1="$(echo '${VOLT1}*${AMP1}' | bc)"
WATT2="$(echo '${VOLT2}*${AMP2}' | bc)"

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
echo "dl320-g6.FAN.RPM_1 ${FAN_1}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.FAN.RPM_2 ${FAN_2}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.FAN.RPM_3 ${FAN_3}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.FAN.RPM_4 ${FAN_4}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.FAN.RPM_5 ${FAN_5}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.FAN.REDUN ${FAN_REDUN}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.AMBI1_TEMP ${AMBI_TEMP_1}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.AMBI2_TEMP ${AMBI_TEMP_2}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.AMBI3_TEMP ${AMBI_TEMP_3}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.AMBI4_TEMP ${AMBI_TEMP_4}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.CPU1_TEMP ${CPU1_TEMP}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.CPU2_TEMP ${CPU2_TEMP}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.MEM_ZONE_1 ${MEM_ZONE_1}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.MEM_ZONE_2 ${MEM_ZONE_2}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.MEM_ZONE_3 ${MEM_ZONE_3}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.MEM_ZONE_4 ${MEM_ZONE_4}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.MEM_ZONE_5 ${MEM_ZONE_5}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.MEM_ZONE_6 ${MEM_ZONE_6}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.MEM_ZONE_7 ${MEM_ZONE_7}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.MEM_ZONE_8 ${MEM_ZONE_8}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.MEM_ZONE_9 ${MEM_ZONE_9}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.MEM_ZONE_10 ${MEM_ZONE_10}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.MEM_ZONE_11 ${MEM_ZONE_11}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.MEM_ZONE_12 ${MEM_ZONE_12}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.SYS_ZONE_1 ${SYS_ZONE_1}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.SYS_ZONE_2 ${SYS_ZONE_2}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.SYS_ZONE_3 ${SYS_ZONE_3}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.SYS_ZONE_4 ${SYS_ZONE_4}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.SYS_ZONE_5 ${SYS_ZONE_5}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.SYS_ZONE_6 ${SYS_ZONE_6}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.SYS_ZONE_7 ${SYS_ZONE_7}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.SYS_ZONE_8 ${SYS_ZONE_8}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.SYS_ZONE_9 ${SYS_ZONE_9}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.SYS_ZONE_10 ${SYS_ZONE_10}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.SYS_ZONE_11 ${SYS_ZONE_11}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.SYS_ZONE_12 ${SYS_ZONE_12}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.STOR_ZONE ${STOR_ZONE}" | nc -q0 ${GRAPHITE_HOST} 2003
echo "dl320-g6.PSU.PRES ${PSU_PRES}" | nc -q0 ${GRAPHITE_HOST} 2003
rm -rf ${IPMIOUT}

exit