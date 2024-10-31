for path in "$@"; do
    
    if [ -d "$path" ]; then
        echo "Processing directory: $path"
        find "$path" -type f | while read -r file; do
            line_count=$(wc -l < "$file")
            if [ "$line_count" -eq 0 ]; then
                echo "$file has 0 lines."
            elif [ "$line_count" -eq 1 ]; then
                echo "$file has 1 line."
            else
                echo "$file has more than 1 line."
            fi
        done

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

    else
        echo "Warning: $path is not a valid file or directory."
    fi
done

