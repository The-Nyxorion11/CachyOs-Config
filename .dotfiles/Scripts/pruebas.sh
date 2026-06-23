#!/bin/bash

# Ocultar el cursor para que no parpadee
tput civis
# Al salir con Ctrl+C, restaurar el cursor y limpiar pantalla
trap 'tput cnorm; clear; exit' INT

# Opciones del menú
opciones=("Ver Hora" "Ver Memoria" "Ver Disco" "Salir")
seleccionado=0

# Función para dibujar el tablero y los botones
dibujar_menu() {
    clear
    echo "=================================================="
    echo "         TABLERO INTERACTIVO CON BOTONES          "
    echo "=================================================="
    echo "  Usa las flechas [↑] [↓] y presiona [Enter]"
    echo "=================================================="
    echo ""

    # Dibujar los botones dinámicamente
    for i in "${!opciones[@]}"; do
        if [ $i -eq $seleccionado ]; then
            # Botón seleccionado: Fondo blanco, texto negro (Invertido)
            echo -e "   \e[7m > [ ${opciones[$i]} ] < \e[0m"
        else
            # Botón normal
            echo "     [ ${opciones[$i]} ]"
        fi
    done
    echo ""
    echo "=================================================="
}

# Bucle principal de interacción
while true; do
    dibujar_menu

    # Leer un solo carácter del teclado de forma silenciosa (-s -n1)
    read -rsn1 tecla

    # Detectar secuencias de escape de las flechas del teclado
    if [[ $tecla == $'\x1b' ]]; then
        read -rsn2 -t 0.1 tecla_flecha
        if [[ $techa_flecha == "[A" ]]; then # Flecha Arriba
            ((seleccionado--))
            [ $seleccionado -lt 0 ] && seleccionado=$((${#opciones[@]} - 1))
        elif [[ $techa_flecha == "[B" ]]; then # Flecha Abajo
            ((seleccionado++))
            [ $seleccionado -ge ${#opciones[@]} ] && seleccionado=0
        fi
    # Detectar si presiona Enter (cadena vacía)
    elif [[ $tecla == "" ]]; then
        clear
        echo "=== RESULTADO ==="
        case $seleccionado in
            0) echo "⏱️ Hora actual: $(date '+%H:%M:%S')" ;;
            1) echo "💾 Memoria RAM disponible:"; free -h ;;
            2) echo "💽 Espacio en disco:"; df -h / ;;
            3) tput cnorm; clear; exit 0 ;;
        esac
        echo "================="
        echo "Presiona cualquier tecla para volver al menú..."
        read -rsn1
    fi
done
