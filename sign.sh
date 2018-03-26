#!/bin/bash

# Matches any supported programming language which uses the "// *Comment here*" format
DOUBLESLASH_REGEXP=".*\.c[cs]?|.*\.h|.*\.java|.*\js"

# Matches .lisp files, which denote comments with a semicolon (;)
LISP_REGEX=".*\.lisp"

# Matches any supported file type which uses the "# *Comment here* format.
HASH_REGEX=".*\.sh|.*\.py|.gitignore"





if [ -f $1 ]; then
   if [ -f signature.txt ];
   then
       if [[ $1 =~ $DOUBLESLASH_REGEXP ]];
       then
	   # If the file is found to fit a format which typically uses '//' to indicate comments,
	   # a // is automatically prepended to each line of the signature before insertion
	   
	   cat $1 > tempsigbody.txt
	   sed -e "s/^/\/\/ /g" signature.txt > tempmodsig.txt
           eval cat tempmodsig.txt tempsigbody.txt > "$1"
           rm tempsigbody.txt tempmodsig.txt
	   
       elif [[ $1 =~ $LISP_REGEX ]];
       then
	   # If the file is found to fit a format which typically uses ';' to indicate comments,
	   # a ; is automatically prepended to each line of the signature before insertion
	   
           cat $1 > tempsigbody.txt
	   sed -e "s/^/\;/g" signature.txt > tempmodsig.txt
           eval cat tempmodsig.txt tempsigbody.txt > "$1"
           rm tempsigbody.txt tempmodsig.txt
	   
       elif [[ $1 =~ $HASH_REGEX ]];
       then
	   # If the file is found to fit a format which typically uses '#' to indicate comments,
	   # a # is automatically prepended to each line of the signature before insertion
	   
           cat $1 > tempsigbody.txt
	   sed -e "s/^/\# /g" signature.txt > tempmodsig.txt
           eval cat tempmodsig.txt tempsigbody.txt > "$1"
           rm tempsigbody.txt tempmodsig.txt
	   
       else
	   # If no outstanding file types are detected, prepend signature without modification.
	   
	   cat $1 > tempsigbody.txt
	   eval cat signature.txt tempsigbody.txt > "$1"
	   rm tempsigbody.txt
	   
       fi
   else
       echo "You have not created a signature yet! Please write a signature in the current directory into a file named 'signature.txt'. "
       echo "This script will automatically attempt to format the signature as a comment in the language of your file. "
       echo "Files without recognizable extensions will have the signature prepended in plaintext"
   fi
else
    echo "Could not find file: $1"
fi
