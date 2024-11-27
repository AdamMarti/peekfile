#Fastacanscript

#0. We begin defining our variables as input from the command line 

folderX=$1 #This is the folder where to find the fa/fasta files
N=$2 #This is the number of lines

#1. We take care of not putting input into folderX or N from the terminal, setting the default values. 

if [[ -z $folderX ]] 
then 
	folderX=$pwd 
else 
	folderX=$1 
fi

if [[ -z $N ]] 
then 
	N=0 
else 
	folderX=$2 
fi

#2. We do the find
find $folderX -type f -name "*.fa" -or -name "*.fasta"
