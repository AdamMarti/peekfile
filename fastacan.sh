#Fastacanscript

# We begin defining our variables as input from the command line 

folderX=$1 #This is the folder where to find the fa/fasta files
N=$2 #This is the number of lines

#We also write some instructions of use that will be printed in case of error.

Instructions="This script work as follows: first you write fcan.sh, then you specify the folder where you want to search for fa/fasta files and in second place you specify the number of lines you are looking for to be printed. If you do not provide them, the folder will be set to the working directory, and the number of lines to 1."

#1. Cases where no input input for folderX or N from the terminal is specified are considered on the following section, setting the default values. The instructions of use of the script are also printed. 

if [[ -z $folderX ]]; then 
		echo
		echo "You did not provide any directory. Setting directory to the current directory."
			folderX=$pwd 
		echo $Instructions
	elif [[  ! -d $folderX ]]; then 
		echo 
		echo "Your input directory was not an existing directory, try again." #Stop if the directory does not exist.
			echo $Instructions
			exit 1 #From now on, this exit code is applied to stop the execution of the script when necessary
	elif [[ -d $folderX && ! -r $folderX  ]]; then
		echo "Your input directory is a directory, but it does not have read permissions." #Stop if the current folder hasn't got file permissions. 
		echo $Instructions
		exit 1
	else 
		echo
		echo "You choose $folderX as directory, which is valid. Continue processing..."
			folderX=$1 
fi

if [[ -z $N  ]]; then 
		echo "Number of lines set to 1 because no number of lines was provided."
		N="1"
		echo $Instructions
	elif ! [[ $N =~ ^[0-9]*$ ]]; then #With this regular expression, we only accept number that contain digits from 0 to 9 as input for N. No decimal, no word-character or others are accepted as an input for N.
		echo "Number of lines set to 1 because no valid input was provided."
		N="1"
		echo $Instructions
	else 
		echo "Number of lines set to $2."
		N=$2 
	
fi

MainFun=$(find $folderX -type f -name "*.fa" -or -name "*.fasta") #We define this function to not write this command every now and then.

##Now comes the section for analyzing the different features for each file. However, there could be cases where the file has a termination of fa or fasta, but some issues happen: not being able to read the file because of lacking permissions, the file being empty or the file having a fa/fasta ending but not being actually a fasta file, file being hidden and being a binary file. This files are excluded from the analysis, with only the filename being printed. 

Empty=0
Hidden=0
NoText=0

echo
echo ================================================FILE PREPROCESSING================================================
echo 
echo "A file called numberoflines_inputfolder_.preprocessing.txt will have been created know in your current directory. You can take a look to see the complete list of not analyzed files."
for i in $MainFun; do
	if [[ ! -s $i ]]; then
		echo "$i is an empty file. It is excluded from further analysis." >> "$N$FolderX.preprocessing.txt"
		Empty=$((  Empty + 1))
	elif [[ ! -r $i ]]; then
		echo "$i is a file without reading permissions. It is excluded from further analysis." >> "$N$FolderX.preprocessing.txt"
	elif [[ $(echo "$i" | grep -cE '/\..+') -gt 0 ]]; then
    		echo "echo $i is a hidden file. No further analysis is done." >> "$N$FolderX.preprocessing.txt"
    		Hidden=$(( Hidden + 1))
	elif [[ $(file $i | grep -ci "text") -eq 0 ]]; then
		echo " $i has a fa/fasta ending on the filename, but it is not actually a text file, so no further analysis is done." >> "$NFolderX.preprocessing.txt"
		NoText=$(( NoText + 1))
	else
		echo "No issues with $i. Proceeding to analysis." >> "$N$FolderX.preprocessing.txt"
	fi
done 

echo "Empty files: $Empty" >> "$N$FolderX.preprocessing.txt"
echo "Hidden files: $Hidden" >> "$N$FolderX.preprocessing.txt"
echo "No text files: $NoText" >> "$N$FolderX.preprocessing.txt"
NFiles=$(( $(echo $MainFun | wc -w) - Empty - Hidden - NoText ))
echo "Valid files: $NFiles" >> "$N$FolderX.preprocessing.txt"
#I know it looks weird to append every time. But if not done like this and done by putting the for loop in a parenthesis and redirecting the output to the file, it did not calculate correctly the number of files.
#A section of General Report is encoded as follows: 
echo
echo ===================================================GENERAL REPORT==================================================
echo
echo "NUMBER OF FILES"  
if [[ $(echo $NFiles) -eq 1 ]]; then
		echo "There is 1 fasta file in this directory."
	elif [[ $(echo $NFiles) -eq 0 ]]; then
		echo "There are none fa/fasta files in this directory."
		exit 1 
	else
		echo "There are $(echo $NFiles) fa/fasta files in this directory."
fi
echo
echo "UNIQUE FASTA IDs"
IdCounts=$(find $folderX -type f -name "*.fa" -or -name "*.fasta" | while read files ; do
	awk '/^>.*/ {print $0}' $files #We interpret the ID as the whole line after the ">" symbol
	done | sort | uniq | wc -l)		
#Now comes a subsection for considering the matching between the number and the singular/plural.
if [[ $(echo $IdCounts) -eq 0 && $(echo $NFiles) -eq 1 ]]; then
		echo "There are no fasta IDs in the file of this directory."
	
	elif [[ $(echo $IdCounts) -eq 0 && $(echo $NFiles) -gt 1 ]]; then
		echo "There are no fasta IDs in the files of this directory."
	
	elif [[ $(echo $IdCounts) -eq 1 && $(echo $NFiles) -eq 1 ]]; then
		echo "There is 1 fasta ID in the file of this directory."

	elif [[ $(echo $IdCounts) -eq 1 && $(echo $NFiles) -gt 1 ]]; then
		echo "There is 1 fasta ID in the files of this directory."

	else
		echo "There are $(echo $IdCounts) fa/fasta IDs in this directory."
fi

#Now comes the section for analyzing the different features for each file. However, there could be cases where the file has a termination of fa or fasta, but some issues happen: not being able to read the file because of lacking permissions, the file being empty or the file having a fa/fasta ending but not being actually a fasta file, file being hidden and being a binary file. This files are excluded from the analysis, with only the filename being printed. 
echo
echo
echo ===================================================FILE REPORTS====================================================
echo
(for j in $MainFun; do
	Nseq=$(awk '/^>.*/ {print $0}' $j | wc -l)
	Seqs=$(grep -vh "^>" $j | grep -o "[a-zA-Z]")
	LSeq=$(grep -vh "^>" $j | grep -o "[a-zA-Z]" | wc -l)

	echo ==="FILENAME: $j"

	if [[ ! -s $j ]]; then
			echo "$j is an empty file. No further analysis is done."
		elif [[ ! -r $j ]]; then
			echo "$j is a file without reading permissions. No further analysis for this file is done unless you change them."
		elif [[ $(echo $j | grep -cE '/\..+') -gt 0 ]]; then
    			echo "$j is a hidden file. No further analysis is done." #Encountering a count for ./ can be expected for example if you work on the current directory. However, if there is more than one, it must be a hidden file or a file in a hidden folder. 
    		elif [[ $(file $j | grep -ci "text") -eq 0 ]]; then
			echo " $j has a fa/fasta ending on the filename, but it is not actually a text file, so no further analysis is done."
	 #What the file function does is tell you what type of file you've got. For regular text files as fa/fasta files, it appears some output like ASCII text, or UTF8 text. This text word is not present in other files, so if the file is not a text file, the result of the grep will be 0.

#Now comes the part of the analysis of the normal fa/fasta files
		else
			echo ==="NUMBER OF SEQUENCES: $Nseq"
				if [[ -h $j ]] 
				then  #this expression checks whether the file is a symbolic link or not
		
						echo ==="TYPE OF FILE: Symbolic link"
					else
						echo ==="TYPE OF FILE: Not a Symbolic link"

				fi
				if [[ $(grep -vh "^>" $j | grep -i [^a,c,t,g,u,n] | wc -l ) -gt 0 ]]; then  #the regular expression used on the second grep ensures that only nucleotide characters can be nucleotides. U has been added for the very rare case where you could have RNA instead of DNA or cDNA. N has been added because some times this nucleotide appears for representing an unknown nucleotide in the sequence. 
						echo ==="TYPE OF SEQUENCE: Protein"
					else
						echo ==="TYPE OF SEQUENCE: Probably Nucleotide. To be sure, check manually."
				fi
#Note: there could be a very strange case where you actually have a fa/fasta files with protein sequences that are all Alanines, Cysteines, Threonines, Asparagines and/or Glycines. It is very unlikely to happen to have different sequences in a protein fa/fasta file all of them with only this aas, but this case cannot be differentiated because the characters used for a nt sequence and a protein sequence would literally be the same, and not "stop codon ending" or "ATG" at the beginning or other features can be generally assumed for nucleotides. The same could if the code was buildid centered for proteins: although an entire protein sequence may start by M (ATG-encoded), there are some exceptions to these and also, if the different protein sequences come for example from an alignment of a certain domain, these sequences may not be starting by M almost never. 

	echo ==="TOTAL CHARACTERS: $LSeq"
	echo ==="FILE LINES"
		if [[ $(echo $N) == "0" ]]; then
			echo "File lines display skipped."
		elif [[ $(cat $j | wc -l) -lt $((2*$N)) ]]; then
			echo "Displaying full content of $j."
			cat $j
		else
			echo "Long file. Displaying only the first and last $N lines of $File".
			echo "FIRST $N LINES:"
			head -n $N $j
			echo "..."
			echo "LAST $N LINES:"
			tail -n $N $j
		fi
fi
echo
echo "----------------------------------------------------------------------------------------------------------------------"
echo
done) 2> err.txt #Standard error is redirected as to not see innecessary information on the screen. 
echo ===================================================END OF REPORT========================================================

