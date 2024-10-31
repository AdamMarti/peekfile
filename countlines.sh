findfiles=$(find $1 -type f)
for var in $findfiles; do
    if [[ $(wc -l < "$var") -eq 0 ]]; then
        echo "$var has 0 lines"
    elif [[ $(wc -l < "$var") -eq 1 ]]; then
        echo "$var has 1 line"
    else
        echo "$var has more than 1 line."
    fi
done



