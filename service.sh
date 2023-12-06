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
