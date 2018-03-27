#!/bin/bash

# Matches any supported programming language which uses the "// *Comment here*" format
DOUBLESLASH_REGEXP=".*\.c[cs]?|.*\.h|.*\.java|.*\js"

# Matches .lisp files, which denote comments with a semicolon (;)
LISP_REGEX=".*\.lisp"

# Matches any supported file type which uses the "# *Comment here* format.
HASH_REGEX=".*\.sh|.*\.py|.gitignore"

#This function prepends the signature text and comments it appropriately. The first argument should be the regular expression
function sign(){
    		cat $1 > tempsigbody.txt

		if [[ $1 =~ $DOUBLESLASH_REGEXP ]]; then
		    # Add a double-slash (//) to all lines which do not start with a tilde (~)
		    sed -e "s/^/\/\/ /g" -e "s/^\/\/\s\?[~]\s\?//g" signature.txt > tempmodsig.txt
		elif [[ $1 =~ $LISP_REGEX ]]; then
		    # Add a semicolon (;) to all lines which do not start with a tilde (~)
		    sed -e "s/^/\;/g" -e "s/^\;\s\?[~]\s\?//g"  signature.txt > tempmodsig.txt
		elif [[ $1 =~ $HASH_REGEX ]];then
		    # Add a hash symbol (#) to all lines which do not start with a tilde (~)		    
		    sed -e "s/^/\# /g" -e "s/^\#\s\?[~]\s\?//g" signature.txt > tempmodsig.txt
		else
		    # Remove leading tilde (~) from all applicable lines and sign without commenting.
		    sed -e "s/^\s\?[~]\s\?//g" signature.txt > tempmodsig.txt
		fi
		
		eval cat tempmodsig.txt tempsigbody.txt > "$file"
		rm tempsigbody.txt tempmodsig.txt
		return
}

# Perform signature on each argument passed.
for file in "$@"; do
    if [ -f $file ]; then
	if [ -f signature.txt ]; then
	   sign $file
	else
	    # The user has not created a signature yet.
	    echo "You have not created a signature yet! Please write a signature in the current directory into a file named 'signature.txt'. "
	    echo "This script will automatically attempt to format the signature as a comment in the language of your file. "
	    echo "Files without recognizable extensions will have the signature prepended in plaintext"
	fi
    else
	# The current file does not exist.
	echo "Could not find file: $file"
    fi
done

