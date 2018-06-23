# How to use
First things first, you must install python libraries dependencies. All libraries used are listed on "requirements.txt" file and can be given to pip3 as argument with the -r flag in order to install then all. After that, just run bllshtMyDatabase.py, giving a .sql as first argument containing all the CREATE TABLE commands. You may also give a optional parameter, choosing how many instances of each table must be created.
```
pip3 install -r requirements.txt
python3 bllshtMyDatabase.py <.sql with all CREATE TABLE> [Number of instances for each table]
```

# Python version used
This program was made and tested with Python version 3.5.2 and pip3 version 10.0.1.

# BEFORE USING
- Read the "[IMPORTANT NOTES](#important-notes)" section @ the end of this README.
- Verify the "[SUPPORTED DATA TYPES](#supported-data-types)" section @ the middle of this README.

# Configuration and customization
You may easily configure script parameters just changing values inside the src/configme.py. There you will find classes named "fakeDataHandler" and "scriptConfig", which keeps all configurable parameters of bllshtMyDatabase.py supported by script.

Supported script configuration parameters are:
```python
# Inside src/configme.py
class scriptConfig:
	BEGIN_TRANSACTION=True
	ROLLBACK_AT_END=False
	GEN_NULL_VALUES=True
	VARCHAR_DEFSIZE=10
	GEN_RANDOM_CHARS=False
	MAX_REAL=1.0e+5-1
	MIN_REAL=-1.0e+5
	PRECISION_REAL=2
	MAX_MONEY=1.0e+5-1
	MIN_MONEY=0
	PRECISION_MONEY=2
	MAX_SMALLINT=2**(8*2-1)-1
	MIN_SMALLINT=-2**(8*2-1)
	MAX_INT=900000
	MIN_INT=100000
	MAX_BIGINT=90000000
	MIN_BIGINT=10000000
	MIN_YEAR=2000
	MAX_YEAR=2018

class fakeDataHandler:
	# Check "faker" module documentation @ https://github.com/joke2k/faker
	fake=Faker(locale='your_locale_here')

	# Configure right here your data generation custom functions
	specialDataFuncs={
		'generic_column_name1': function_that_generate_values,
		'generic_column_name2': {
			'table_1_that_contains_that_column': gen_func, 
			'another_table_with_that_column': different_function
			'DEFAULT': function_that_gens_for_any_other_table_with_that_column},
		'nome': {'equipamento': fake.name, 'DEFAULT': fake.name},
		'RG': fake.ssn,
		'nomeBanda': fake.name,
		'endereco': fake.address,
		'endereco': fake.address,
		'descricao': fake.text,
		'telefone': fake.phone_number,
	}
```

# Sample Input file
Here's a very simple exaple of which a generic input file should contains in order to script work with, alongside it's correspondent output. You can verify it's exactly input/output pair inside ``examples'' directory.
```sql
/* myDatabase.sql */

CREATE TABLE person(
	nome VARCHAR(60) NOT NULL,
	cpf CHAR(14),
	CONSTRAINT pk_person
		PRIMARY KEY (cpf),
	CONSTRAINT ck_person
		CHECK (cpf ~ '^[0-9]{3}\.[0-9]{3}\.[0-9]{3}\-[0-9]{2}$')
);

CREATE TABLE worker(
	cpf CHAR(14),
	jobsDone SMALLINT,
	piecesMan INTEGER,
	balance REAL,
	
	CONSTRAINT pk_worker
		PRIMARY KEY (cpf),
	CONSTRAINT fk_worker
		FOREIGN KEY (cpf)
		REFERENCES person
		ON DELETE CASCADE
);
```

# Output
```sql
/* TOTAL OF 0 ERRORS WHILE BUILDING METADATA STRUCTURE. */
BEGIN TRANSACTION;
/* TABLE person */
INSERT INTO person ( nome, cpf )
	VALUES ( 'Yuri Freitas', '599.402.555-21' );
INSERT INTO person ( nome, cpf )
	VALUES ( 'Renan Pires', '251.294.595-31' );
INSERT INTO person ( nome, cpf )
	VALUES ( 'Stella Oliveira', '285.729.562-94' );
INSERT INTO person ( nome, cpf )
	VALUES ( 'Augusto da Cruz', '417.098.902-20' );
INSERT INTO person ( nome, cpf )
	VALUES ( 'Natália Silveira', '962.279.030-44' );

/* TABLE worker */
INSERT INTO worker ( piecesMan, cpf, balance, jobsDone )
	VALUES ( 666902, '599.402.555-21', -4415.68, 27040 );
INSERT INTO worker ( piecesMan, cpf, balance, jobsDone )
	VALUES ( 483492, '251.294.595-31', 25913.85, -2655 );
INSERT INTO worker ( piecesMan, cpf, balance, jobsDone )
	VALUES ( 260278, '285.729.562-94', -35650.75, 61589 );
INSERT INTO worker ( piecesMan, cpf, balance, jobsDone )
	VALUES ( 809750, '962.279.030-44', -32507.94, 7754 );
INSERT INTO worker ( piecesMan, cpf, balance, jobsDone )
	VALUES ( 512768, '417.098.902-20', 18558.09, -43713 );

/* TABLE NUMBER TOTAL: 2 */
ROLLBACK;
```

Note: Check out "examples/biggerOutputExample.sql" to get a idea of a bigger program output from a much more complex database.

# Supported Data Types
The program supports the following PostgreSQL data types:
- SMALLINT/INT2
- INTEGER/INT/INT4
- BIGINT/INT8
- REAL/FLOAT8
- MONEY
- SMALLSERIAL/SERIAL2
- SERIAL/SERIAL4
- BIGSERIAL/SERIAL8
- BOOLEAN/BOOL
- VARCHAR/VARCHAR2/TEXT/CHARACTER VARYING
- CHAR/CHARACTER
- DATE
- TIME
- TIMESTAMP
- BIT
- VARBIT/BIT VARYING
- INET

# IMPORTANT NOTES
- Every table with SERIAL or BIGSERIAL column types must be brand-new (i.e. the autoincrementing counter must be currently on 1) in order to FOREIGN KEYS pointing to SERIAL/BIGSERIAL columns work,
- For security, the default configuration of this script is to both start a TRANSACTION at the start of each output file and ROLLBACK at the end. Change this configuration inside the scriptConfig class (within bllshtMyDatabase.py file).
- The script are mainly CASE SENSITIVE. Table names with mixed cases ARE NOT treated equally through the code.
- The script DO NOT support 'NOT' PostgreSQL keyword.

# Known bugs
Check out opened issues in this github repository.
