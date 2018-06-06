#!/bin/bash

# Usage: ./wannaCry.sh BEGIN_NUM_INSERTS END_NUM_INSERTS NUM_LOOPS

BEGIN_NUM_INSERTS=${1:-1}
END_NUM_INSERTS=${2:-500}
NUM_LOOPS=${3:-100}
OUTPUT_FILENAME=errors.txt

echo -n > $OUTPUT_FILENAME

# Realiza um teste exaustivo
for i in `seq $BEGIN_NUM_INSERTS $END_NUM_INSERTS`; 
do
	for j in `seq 1 $NUM_LOOPS`;
	do	
		echo "Progress: $i $j"		
		`python3 bllshtMyDatabase.py schemas.sql $i > insert.sql` >> OUTPUT_FILENAME
	done
done

echo "Results:"
cat $OUTPUT_FILENAME | sort | uniq -c | sort -k1 -n