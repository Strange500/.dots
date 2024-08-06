#/bin/bash

DIR=$1


for file in $(find "$DIR" -type f -links 1); do
	rm $file
	echo "$file" deleted
done
