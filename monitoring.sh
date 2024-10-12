#!/bin/bash

# Tu script debe siempre mostrar la siguiente información via wall cada 10 minutos:
# • La arquitectura de tu sistema operativo y su versión de kernel.
# • El número de núcleos físicos.
# • El número de núcleos virtuales.
# • La memoria RAM disponible actualmente en tu servidor y su porcentaje de uso.
# • La memoria disponible actualmente en tu servidor y su utilización como un porcentaje.
# • El porcentaje actual de uso de tus núcleos.
# • La fecha y hora del último reinicio.
# • Si LVM está activo o no.
# • El número de conexiones activas.
# • El número de usuarios del servidor.
# • La dirección IPv4 de tu servidor y su MAC (Media Access Control)
# • El número de comandos ejecutados con sudo.

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
disk_total=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_total += $2} END {print ("%.1fGb", disk_total)}')
disk_percent=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_used += $3} {disk_total += $2} END {printf("(%.2f%%)\n", disk_used/disk_total*100)}')

# Porcentaje actual de uso de tus núcleos
cpu_load=$(vmstat 1 2 | tail -1 | awk '{printf ("%.1f%%\n", 100-$15)}')

# Fecha y hora del último reinicio
last_boot=$(who -b | awk '/system/ {print $3, $4}')

# Si LVM está activo o no
lvm_status=$(lsblk | grep "lvm" | wc -l)
