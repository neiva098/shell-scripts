function fatal() {
    echo "[-] Error: $@" 1>&2
    exit 1
}

screens=$(xrandr -q | grep " connected" | awk '{print $1}')
screen_name="not selected"
selected="#"

for i in $screens; do
    :
    echo "Digite selecionar para selecionar a tela: $i"
    read selected
    if [ "$selected" == "selecionar" ]; then
        echo "$i selecionada"
        screen_name="$i"
        break
    fi
done

if [[ "$screen_name" == "not selected" ]]; then
    fatal "tela não selecionada"
fi

return=$(xrandr --verbose | grep rightness | awk '{ print $2 }')
min_max=(${return[0]})
old_brightness=${min_max[1]}

incr=0.25

new_brightness=$old_brightness

option="#"

while [[ "$option" != "exit" && "$option" != "save" ]]; do
    echo "Digite + para aumentar o brilho ou - para diminuir o brilho, show para imprimir o valor atual do brilho save para aplicar e exit para cancelar"
    read option

    case $option in
    +)
        new_brightness=$(echo "scale=2; $new_brightness + $incr" | bc)
        xrandr --output "$screen_name" --brightness $new_brightness
        ;;
    -)
        new_brightness=$(echo "scale=2; $new_brightness - $incr" | bc)
        xrandr --output "$screen_name" --brightness "$new_brightness"
        ;;
    show) echo "O brilho é $new_brightness" ;;
    *) continue ;;
    esac
done

if [ $option == "save" ]; then
    echo "Brilho salvo"
else
    xrandr --output "$screen_name" --brightness "$old_brightness"
    echo "Brilho não foi salvo"
fi
