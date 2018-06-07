#!/bin/bash

# Usage: ./wannaCry.sh BEGIN_NUM_INSERTS END_NUM_INSERTS NUM_LOOPS

# Variáveis de Ambiente

# RANGES
BEGIN_NUM_INSERTS=${1:-1}
END_NUM_INSERTS=${2:-500}
NUM_LOOPS=${3:-100}

# FILENAMES
OUTPUT=errors.txt
#CLEAN_OUTPUT=cleanErrors.txt

# PATHS
DATABASE_SCHEMA_PATH=../examples/myDatabase.sql
PROGRAM_PATH=../bllshtMyDatabase.py

# Limpa o arquivo de output
echo -n > $OUTPUT

# Limpa o diretório dump
rm -rf dump && mkdir dump

# Realiza um teste exaustivo
for i in `seq $BEGIN_NUM_INSERTS $END_NUM_INSERTS`; 
do
	for j in `seq 1 $NUM_LOOPS`;
	do			
		echo -ne "Progress: [$i $j]\r"
		`python3 $PROGRAM_PATH $DATABASE_SCHEMA_PATH $i > ./dump/insert$i$j.sql` >> $OUTPUT
		#egrep "DELETE|ROLLBACK|CREATE|DROP|COMMIT|BEGIN|ALTER|INSERT" -v $OUTPUT > $CLEAN_OUTPUT
	done
done

# Imprime os resultados
#echo "Cleaned Outputs:"
#cat $CLEAN_OUTPUT
echo "Original Results:"
cat $OUTPUT | sort | uniq -c | sort -k1 -n
echo "Check ./dump/ for generated inserts."