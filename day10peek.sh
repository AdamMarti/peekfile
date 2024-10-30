if [[ -z "$2" ]]; then 
    lines=3   #I had to do it this way because I first tried to do it like 
    # $2 = 3 but it gave me error because I could not assign 3 to $2. 
else
    lines=$2  
fi

line_count=$(wc -l < "$1") #Chat also offered me this solution for the problems with the brackets. 

#I chose on purpose to use single brackets because of the 2 * lines operation 
if [ "$line_count" -le $(( 2 * lines )) ]; then
    cat "$1"
    echo "This file only has $line_count lines, so we printed all of it."
else 
    echo "The first $lines lines are:"
    head -n "$lines" "$1"
    echo "The last $lines lines are:"
    tail -n "$lines" "$1"
fi






