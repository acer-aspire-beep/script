#!/bin/bash

all_disks_info=$(df -h)

mariadb_service="mariadb"

php_service="php7.2-fpm"

apache_service="apache2"

ram=$(free -m | awk 'NR==2{print $3}')

total_ram=$(free -m | awk 'NR==2{print $2}')

ram_percent=$((ram * 100 / total_ram))

cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')


mysql_s="$(systemctl is-active mariadb.service)"

apache2_s="$(systemctl is-active apache2.service)"

phpfpm_s="$(systemctl is-active php7.2-fpm)"

disk_space="$(df -H |grep sdb1| awk '{print $5}'| cut -c 1-2)"

vaxt="$(date)"

host="$(hostname)"


non_work_s=""

for service in $mariadb_service $php_service $apache_service
do
    status=$(systemctl is-active $service)
    echo "$service status: $status"
    if ["$service" = "active" ];then
        echo "Servislerin Herbiri Aktivdir" | mail -s "FYI" cemil.tapdiqov@gmail.com
    else
        echo "Kargolux islemir" | mail -s "FYI" cemil.tapdiqov@gmail.com
    fi
     if [ "$mysql_s" = "active" ]; then
        echo "Mysql Isleyir"
     else
        `systemctl restart mariadb`
     fi
     if [ "$apache2_s" = "active" ]; then
        echo "Web Server Isleyir"
        #non_work_s+="$service "
     else
        `systemctl restart apache2`
     fi
     if [ "$phpfpm_s" = "active" ]; then
        echo "Php_Fpm isleyir"
    else
        `systemctl restart php7.2-fpm`
     fi
done

echo "islemyen service: $non_work_s"

if [ -n "$non_work_s"];
then
    systemctl restart $non_work_s
    echo "Service Restart edildi: $non_work_s"
else
    echo "Servislerin Hamisi isleyir"
fi


if [ $disk_space > 90 ]
then
echo -e "Diskin Faizi.\nHostun Adi:$host \nDisk Tutumunun Faizi: $disk_space \nIndiki Vaxt:$vaxt \nDisk space artir!"  | mail -s "FYI" cemil.tapdiqov@gmail.com
else
echo -e "Diskin faizi.\nHostun Adi:$host \nDisk Tutumunun Faizi: $disk_space" | mail -s "FYI" cemil.tapdiqov@gmail.com
fi

echo "CPU istifadesi: $cpu_usage%" | mail -s "FYI" cemil.tapdiqov@gmail.com
echo "RAM istifadesi: $ram MB / $total_ram MB \nRAM istifadesi faizi: $ram_percent%" | mail -s "FYI" cemil.tapdiqov@gmail.com
echo "$all_disks_info" | mail -s "FYI" cemil.tapdiqov@gmail.com