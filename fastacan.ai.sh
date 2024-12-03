#!/bin/bash

# ASCII Art Title
echo "================================================="
echo "          Fcan: Your Fasta Reporter of Trust      "
echo "================================================="
echo

# Variables for inputs and defaults
folderX=${1:-$(pwd)} # First argument specifies the folder; defaults to the current directory if not provided
N=${2:-1} # Second argument specifies the number of lines to display; defaults to 1

instructions="Usage: fastacan.sh [folder] [number of lines to display]
If no folder is specified, the current directory is used. 
If no line number is provided, the default is 1."

# Validate inputs
if [[ ! -d $folderX ]]; then
    echo "Invalid directory: $folderX"
    echo "$instructions"
    exit 1 # Exit if the provided folder does not exist
elif [[ ! -r $folderX ]]; then
    echo "Directory exists but lacks read permissions: $folderX"
    exit 1 # Exit if the folder exists but cannot be read
fi

if ! [[ $N =~ ^[0-9]+$ ]]; then # Regular expression `^[0-9]+$` ensures N contains only digits
    echo "Invalid line number: $N. Defaulting to 1."
    N=1
fi

# Initialize counters for excluded files
Empty=0
Hidden=0
NoText=0

# Locate fasta/fa files
MainFun=$(find "$folderX" -type f \( -name "*.fa" -or -name "*.fasta" \)) # Finds all `.fa` or `.fasta` files recursively

# Preprocessing file
preprocessing_file="$folderX"_preprocessing.txt
echo "Preprocessing report written to $preprocessing_file"
> "$preprocessing_file" # Create or overwrite the preprocessing report file

# Analyze each file
for i in $MainFun; do
    if [[ ! -s $i ]]; then
        # Check if the file is empty (`-s` tests if the file has non-zero size)
        echo "$i is an empty file. Excluded." >> "$preprocessing_file"
        ((Empty++)) # Increment the empty file counter
    elif [[ ! -r $i ]]; then
        # Check if the file is not readable (`-r` tests read permissions)
        echo "$i lacks read permissions. Excluded." >> "$preprocessing_file"
    elif [[ $(basename "$i") == .* ]]; then
        # Check if the file is hidden; `basename` gets the filename, and `.*` matches names starting with a dot
        echo "$i is a hidden file. Excluded." >> "$preprocessing_file"
        ((Hidden++)) # Increment the hidden file counter
    elif ! file "$i" | grep -qi "text"; then
        # Check if the file is not a text file; `file` identifies file type, `grep -qi` checks for "text" case-insensitively
        echo "$i is not a text file. Excluded." >> "$preprocessing_file"
        ((NoText++)) # Increment the non-text file counter
    else
        echo "$i passed preprocessing checks." >> "$preprocessing_file"
    fi
done

# Summary of excluded files
echo "Empty files: $Empty" >> "$preprocessing_file"
echo "Hidden files: $Hidden" >> "$preprocessing_file"
echo "Non-text files: $NoText" >> "$preprocessing_file"

# Count valid files
NFiles=$(( $(echo "$MainFun" | wc -w) - Empty - Hidden - NoText )) # Total files minus excluded files
echo "Valid files: $NFiles" >> "$preprocessing_file"

# General report
echo
echo "================================================="
echo "                 GENERAL REPORT                  "
echo "================================================="
echo "Number of files:"
echo "$NFiles fa/fasta files in directory."
echo

# Unique FASTA IDs
IdCounts=$(find "$folderX" -type f \( -name "*.fa" -or -name "*.fasta" \) | awk '/^>/ {print $0}' | sort -u | wc -l)
# `^>` matches lines starting with `>`, representing FASTA headers; `sort -u` removes duplicates

echo "Unique FASTA IDs: $IdCounts"
echo

# File-specific analysis
echo "================================================="
echo "                 FILE REPORTS                    "
echo "================================================="

for j in $MainFun; do
    # Skip excluded files
    if [[ ! -s $j || ! -r $j || $(basename "$j") == .* || ! $(file "$j" | grep -qi "text") ]]; then
        continue
    fi

    # Count sequences and characters
    Nseq=$(awk '/^>/ {print $0}' "$j" | wc -l) # Count lines starting with `>`, indicating sequences
    LSeq=$(grep -v "^>" "$j" | tr -d '\n' | wc -m) # Remove line breaks and count characters

    echo "File: $j"
    echo "Number of sequences: $Nseq"
    echo "Total characters: $LSeq"
    
    if [[ -h $j ]]; then
        # Check if the file is a symbolic link (`-h` tests for symlinks)
        echo "Type: Symbolic link"
    else
        echo "Type: Regular file"
    fi

    if grep -qv "^[ACGTUNacgtun-]*$" "$j"; then
        # `^[ACGTUNacgtun-]*$` matches only nucleotide characters and gaps
        echo "Type of sequence: Protein"
    else
        echo "Type of sequence: Nucleotide"
    fi

    if [[ $N -eq 0 ]]; then
        # Skip content display if N is 0
        echo "File content display skipped."
    elif [[ $(wc -l < "$j") -le $((2 * N)) ]]; then
        # If the file has ≤2N lines, display the full content
        echo "Displaying full content of $j:"
        cat "$j"
    else
        # Display the first and last N lines for long files
        echo "Displaying first and last $N lines of $j:"
        head -n $N "$j"
        echo "..."
        tail -n $N "$j"
    fi
    echo "-------------------------------------------------"
done

echo "================================================="
echo "                   END OF REPORT                 "
echo "================================================="

