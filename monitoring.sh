#!/bin/bash

# Arquitectura del sistema operativo y su versión de kernel
architecture=$(uname -a)

# Número de núcleos físicos
cpu_physical=$(grep "physical id" /proc/cpuinfo | wc -l)

# Número de núcleos virtuales
cpu_virtual=$(grep "processor" /proc/cpuinfo | wc -l)

# Memoria RAM disponible actualmente en tu servidor y su porcentaje de uso
memory_used=$(free --mega | awk '/Mem/ {print $3}')
memory_total=$(free --mega | awk '/Mem/ {print $2}')
memory_percent=$(free --mega | awk '/Mem/ {printf("(%.2f%%)\n", $3/$2*100)}')

# Memoria disponible actualmente en tu servidor y su utilización como un porcentaje
disk_used=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_used += $3} END {print disk_used}')
disk_total=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_total += $2} END {printf ("%.1fGb", disk_total/1024)}')
disk_percent=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_used += $3} {disk_total += $2} END {printf("(%.2f%%)\n", disk_used/disk_total*100)}')

# Porcentaje actual de uso de tus núcleos
cpu_load=$(vmstat 1 2 | tail -1 | awk '{printf ("%.1f%%\n", 100-$15)}')

# Fecha y hora del último reinicio
last_boot=$(who -b | awk '/system/ {print $3, $4}')

# Si LVM está activo o no
lvm_use=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo "yes"; else echo "no"; fi)

# Número de conexiones activas TCP
tcp_connections=$(ss -ta | grep "ESTAB" | wc -l)

# Número de usuarios del servidor
user_log=$(users | wc -w)

# Dirección IPv4 de tu servidor y su MAC (Media Access Control)
network_ip=$(hostname -I)
network_mac=$(ip link | awk '/link\/ether/ {print $2}')

# Número de comandos ejecutados con sudo
sudo_commands=$(journalctl -q _COMM=sudo | grep COMMAND | wc -l)

wall "	#Architecture: $architecture
	#CPU physical: $cpu_physical
	#vCPU: $cpu_virtual
	#Memory Usage: $memory_used/${memory_total}MB $memory_percent
	#Disk Usage: $disk_used/$disk_total $disk_percent
	#CPU Load: $cpu_load
	#Last boot: $last_boot
	#LVM use: $lvm_use
	#TCP Connections: $tcp_connections ESTABLISHED
	#User log: $user_log
	#Network: IP ${network_ip}($network_mac)
	#Sudo: $sudo_commands cmd"
