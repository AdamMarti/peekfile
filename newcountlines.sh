for path in "$@"; do
    

    elif [ -f "$path" ]; then
        echo "Processing file: $path"
        line_count=$(wc -l < "$path")
        if [ "$line_count" -eq 0 ]; then
            echo "$path has 0 lines."
        elif [ "$line_count" -eq 1 ]; then
            echo "$path has 1 line."
        else
            echo "$path has more than 1 line."
        fi

    fi
done

