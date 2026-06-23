permiso=true
permisoExtra=true

while true; do
    carga=$(cat /sys/class/power_supply/BAT1/capacity)

    if [ $carga -ge 80 ] && [ $permiso == "true" ]; then
        notify-send "Bateria al $carga%!!!" "Batería al $carga%, desconectar"
        permiso=false
    fi

    if [ $carga -le 10 ] && [ $permiso == "true" ]; then
        notify-send "Bateria al $carga%!!!" "Batería al $carga%, Conectar"
        permiso=false
    fi

    if [ $carga -ge 85 ] && [ $permisoExtra == "true" ]; then
        notify-send -u critical "Bateria al $carga%!!!" "Batería al $carga%, desconectar"
        permisoExtra=false
    fi

    if [ $carga -le 5 ] && [ $permisoExtra == "true" ]; then
        notify-send -u critical "Bateria al $carga%!!!" "Batería al $carga%, Conectar"
        permisoExtra=false
    fi

    if [ $carga -gt 10 ] && [ $carga -lt 80 ]; then
        permiso=true
    fi

    if [ $carga -gt 5 ] && [ $carga -lt 85 ]; then
        permisoExtra=true
    fi


    sleep 60  
done