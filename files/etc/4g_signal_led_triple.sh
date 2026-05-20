#!/bin/sh

QMI_DEV="/dev/cdc-wdm0"

LED1="white:signal1"
LED2="white:signal2"
LED3="white:signal3"

led_off_all() {
    echo "none" > /sys/class/leds/${LED1}/trigger
    echo "0" > /sys/class/leds/${LED1}/brightness
    echo "none" > /sys/class/leds/${LED2}/trigger
    echo "0" > /sys/class/leds/${LED2}/brightness
    echo "none" > /sys/class/leds/${LED3}/trigger
    echo "0" > /sys/class/leds/${LED3}/brightness
}

led_1() {
    echo "none" > /sys/class/leds/${LED1}/trigger
    echo "1" > /sys/class/leds/${LED1}/brightness
    echo "none" > /sys/class/leds/${LED2}/trigger
    echo "0" > /sys/class/leds/${LED2}/brightness
    echo "none" > /sys/class/leds/${LED3}/trigger
    echo "0" > /sys/class/leds/${LED3}/brightness
}

led_2() {
    echo "none" > /sys/class/leds/${LED1}/trigger
    echo "1" > /sys/class/leds/${LED1}/brightness
    echo "none" > /sys/class/leds/${LED2}/trigger
    echo "1" > /sys/class/leds/${LED2}/brightness
    echo "none" > /sys/class/leds/${LED3}/trigger
    echo "0" > /sys/class/leds/${LED3}/brightness
}

led_3() {
    echo "none" > /sys/class/leds/${LED1}/trigger
    echo "1" > /sys/class/leds/${LED1}/brightness
    echo "none" > /sys/class/leds/${LED2}/trigger
    echo "1" > /sys/class/leds/${LED2}/brightness
    echo "none" > /sys/class/leds/${LED3}/trigger
    echo "1" > /sys/class/leds/${LED3}/brightness
}

set_leds_by_rssi() {
    case "$1" in
        -120|-119|-118|-117|-116|-115|-114|-113|-112|-111|-110|-109|-108|-107|-106|-105|-104|-103|-102|-101|-100|-99|-98|-97|-96|-95|-94|-93|-92|-91|-90|-89|-88|-87|-86|-85|-84)
            led_1
            ;;
        -83|-82|-81|-80|-79|-78|-77|-76|-75|-74|-73|-72|-71|-70|-69|-68|-67|-66|-65)
            led_2
            ;;
        -64|-63|-62|-61|-60|-59|-58|-57|-56|-55|-54|-53|-52|-51|-50|-49|-48|-47|-46|-45|-44|-43|-42|-41|-40|-39|-38|-37|-36|-35|-34|-33|-32|-31|-30)
            led_3
            ;;
        *)
            led_off_all
            ;;
    esac
}

led_off_all

while true; do
    info="$(uqmi -d ${QMI_DEV} --get-signal-info 2>/dev/null)"
    RSSI="$(echo "$info" | sed -n 's/.*"rssi":[[:space:]]*\([-0-9.]*\).*/\1/p' | cut -d. -f1)"

    if [ -z "$RSSI" ]; then
        led_off_all
    else
        set_leds_by_rssi "$RSSI"
    fi

    sleep 5
done

