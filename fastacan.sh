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

#2. Tell me how many fa/fasta files there are in the directory and how many unique fasta IDs. 
echo =============================================GENERAL REPORT=======================================================
echo
echo NUMBER OF FILES 
echo "There are $(find $folderX -type f -name "*.fa" -or -name "*.fasta" | wc -l) fasta files in this directory."
echo
echo UNIQUE FASTA IDs
IdCounts=$(find $folderX -type f -name "*.fa" -or -name "*.fasta" | while read i; do
	awk '/^>.*/ {print $0}' $i #We interpret the ID as the whole line after the ">" symbol
	done | sort | uniq | wc -l)
echo "There are $IdCounts unique fa/fasta IDs found in the different fa/fasta files in $i". 

