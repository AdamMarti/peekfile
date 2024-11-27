#Fastacanscript

#0. We begin defining our variables as input from the command line 
folderX=$1 #This is the folder where to find the fa/fasta files
N=$2 #This is the number of lines

#1. We take care of not putting input into folderX or N from the terminal, setting the default values. 

if [[ -z $folderX ]] 
then 
	folderX=$pwd  ####FALTA CONSIDERAR QUÈ PASSA SI LI DONES UN DIRECTORI QUE NO EXISTEIX 
else 
	folderX=$1 
fi

if [[ -z $N ]] #ACÍ FALTA CONSIDERAR QUÈ OCORRE SI NO LI DONES UN NOMBRE 
then 
	N=0
else 
	folderX=$2 
fi

#We will still define another variable given that this piece of code will be used many times

MainFun=$(find $folderX -type f -name "*.fa" -or -name "*.fasta")

#2. Tell me how many fa/fasta files there are in the directory and how many unique fasta IDs. 
echo =============================================GENERAL REPORT=======================================================
echo
#FALTA POSAR BÉ LA CONCORDÀNCIA DE GÈNERE I NOMBRE ( 1 O MÉS DE 1)
echo NUMBER OF FILES  
if [[ $MainFun -eq 1 ]]
then
	echo "There is 1 fasta file in this directory."
elif [[ $MainFun -eq 0 ]]
	echo "There are none fa/fasta files in this directory."
else
	echo "There are $(find $folderX -type f -name "*.fa" -or -name "*.fasta") fa/fasta files in this directory."
fi

echo
#FALTA POSAR BÉ LA CONCORDÀNCIA DE GÈNERE I NOMBRE ( 1 O MÉS DE 1)



echo UNIQUE FASTA IDs




IdCounts=$(find $folderX -type f -name "*.fa" -or -name "*.fasta" | while read i; do
	awk '/^>.*/ {print $0}' $i #We interpret the ID as the whole line after the ">" symbol
	done | sort | uniq | wc -l)
echo "There are $IdCounts unique fa/fasta IDs found in the different fa/fasta files in this directory". 
echo
echo
echo ================================================FILE REPORTS=======================================================
for j in $(find $folderX -type f -name "*.fa" -or -name "*.fasta"); do
Nseq=$(awk '/^>.*/ {print $0}' $j | wc -l)
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
echo ==="TOTAL CHARACTERS: $LSeq"
echo 
echo --------------------------------------------- File separator ------------------------------------------------------
done

