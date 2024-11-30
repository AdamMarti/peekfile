#Fastacanscript

#0. We begin defining our variables as input from the command line 

folderX=$1 #This is the folder where to find the fa/fasta files
N=$2 #This is the number of lines

#1. We take care of not putting input into folderX or N from the terminal, setting the default values. 
if [[ -z $folderX ]] then 
#Check el tema de si li dones el número de línies pero no la ruta. En eixe cas, seria, si $1= integer, fes que $1 = pwd i que $2 passe a ser eixe integer. O directament posar un codi que explique com funciona el programa. 
	echo
	echo "You did not provide any directory. Setting directory to the current directory."
	folderX=$pwd 
elif [[  ! -d $folderX ]] then 
	echo 
	echo "Your input directory was not a directory, try again." #Stop if the directory does not exist.
	exit 1
elif [[ -d $folderX && ! -r $folderX  ]] then
	echo "Your input directory is a directory, but it does not have read permissions." #Stop if the current folder does not have file permissions. 
	exit 1
else 
	echo
	echo "You choose $folderX as directory, which is valid. Continue processing..."
	folderX=$1 
fi

if [[ -z $N  ]] then #With this regular expression, we only accept number that contain digits from 0 to 9 as input for N. No decimal, no word-character or others are accepted as an input for N.
	echo "Number of lines set to 1 because no number of lines was provided."
	N="1"
elif ! [[ $N =~ ^[0-9]*$ ]] then 
	echo "Number of lines set to 1 because no valid input was provided."
	N="1"
else 
	echo "Number of lines set to $2."
	N=$2 
	
fi

MainFun=$(find $folderX -type f -name "*.fa" -or -name "*.fasta")

#ACÍ FALTA CONSIDERAR/DIFERENCIAR ENTRE: FITXERS SENSE PERMISS, FITXERS BUITS, FITXERS  QUE TINGUEN L'EXTENSIÓ FA/FASTA PERÒ QUE SIGUEN BINARIS. Aquests últims te'ls hauria de traure. 

#for i in $MainFun; do
#	if [[ $i -

#2. Tell me how many fa/fasta files there are in the directory and how many unique fasta IDs. 
echo
echo ================================================GENERAL REPORT==============================================================
echo
echo NUMBER OF FILES  
if [[ $(echo $MainFun | wc -w) -eq 1 ]] then
	echo "There is 1 fasta file in this directory."
elif [[ $(echo $MainFun | wc -w) -eq 0 ]] then
	echo "There are none fa/fasta files in this directory."
	exit 1
else
	echo "There are $(echo $MainFun | wc -w) fa/fasta files in this directory."
fi

echo

echo UNIQUE FASTA IDs

IdCounts=$(find $folderX -type f -name "*.fa" -or -name "*.fasta" | while read files ; do
	awk '/^>.*/ {print $0}' $files #We interpret the ID as the whole line after the ">" symbol
	done | sort | uniq | wc -l)

if [[ $(echo $IdCounts) -eq 0 && $(echo $MainFun) -eq 1 ]] then
	echo "There are no fasta IDs in the file of this directory."
	
#elif [[ $(echo $IdCounts) -eq 0 && $(echo $MainFun) -gt 1 ]] then
	echo "There are no fasta IDs in the files of this directory."
	
#elif [[ $(echo $IdCounts) -eq 1 && $(echo $MainFun) -eq 1 ]] then
	echo "There is 1 fasta ID in the file of this directory."

#elif [[ $(echo $IdCounts) -eq 1 && $(echo $MainFun) -gt 1 ]] then
	echo "There is 1 fasta ID in the files of this directory."

else
	echo "There are $(echo $IdCounts) fa/fasta IDs in this directory."
fi
echo
echo
echo ===================================================FILE REPORTS=============================================================
for j in $MainFun; do
Nseq=$(awk '/^>.*/ {print $0}' $j | wc -l)
Seqs=$(grep -vh "^>" $j | grep -o "[a-zA-Z]")
LSeq=$(grep -vh "^>" $j | grep -o "[a-zA-Z]" | wc -l)
echo
echo ==="FILENAME: $j"
echo ==="NUMBER OF SEQUENCES: $Nseq"
	if [[ -h $j ]]
	then
		echo ==="TYPE OF FILE: Symbolic link"
	else
		echo ==="TYPE OF FILE: Not a Symbolic link"
	fi
#Check if the file has protein or nucleotide sequences
Aaslist="D, E, F, H, I, K, L, M, N, P, Q, R, S, V, W, Y"
grep -vh "," $(echo $Aaslist) | grep -o "[*]" | while read line; do 
if 

grep -vh "^>" $j | $(grep -i "$(echo  || g)

echo ==="TYPE OF SEQUENCE"

echo ==="TOTAL CHARACTERS: $LSeq"
echo ==="FILE LINES"
	if [[ $(echo $N) == "0" ]] then
	echo "File lines display skipped."
	break
	elif [[ $(cat $j | wc -l) -lt $((2*$N)) ]] then
		echo "Displaying full content of $j."
		cat $j
	else
		echo "Long file. Displaying only the first and last $N lines of $File".
		head -n $N $j && tail -n $N $j
	fi
echo
echo -----------------------------------------------------------------------------------------------------------------
done


