# How to use
Just run bllshtMyDatabase.py, giving a .sql as first argument containing all the CREATE TABLE commands. You may also give a optional parameter, choosing how many instances of each table must be created.
```
python bllshtMyDatabase.py <.sql with all CREATE TABLE> [Number of instances for each table]
```

# BEFORE USING
- Read the "[IMPORTANT NOTES](#important-notes)" section @ the end of this README.
- Verify the "[SUPPORTED DATA TYPES](#supported-data-types)" section @ the middle of this README.

# Configuration and customization
You may easily change script parameters just changing values inside the ``scriptConfig'' class inside bllshtMyDatabase.py file.
Supported script configuration parameters are:
```
class scriptConfig:
        BEGIN_TRANSACTION=True
        ROLLBACK_AT_END=True
        GEN_NULL_VALUES=True
        VARCHAR_DEFSIZE=10
        genRandomChars=False
        A set of extreme values
        MAX_REAL=1.0e+5-1
        MIN_REAL=-1.0e+5
        REAL_PRECISION=2
        MAX_INT=2**(8*4)-1
        MAX_INT=-2**(8*4)
        MAX_BIGINT=2**(8*8)-1
        MAX_BIGINT=-2**(8*8)
        MIN_YEAR=1900
        MAX_YEAR=2050
```
# Sample Input file
```
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
```
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
- SMALLINT
- INTEGER
- BIGINT
- REAL
- DATE
- SERIAL
- BIGSERIAL
- TYPE
- BOOLEAN
- VARCHAR
- CHAR
- TIME
- TIMESTAMP

# IMPORTANT NOTES
- Every table with SERIAL or BIGSERIAL column types must be brand-new (i.e. the autoincrementing counter must be currently on 1) in order to FOREIGN KEYS pointing to SERIAL/BIGSERIAL columns work,
- For security, the default configuration of this script is to both start a TRANSACTION at the start of each output file and ROLLBACK at the end. Change this configuration inside the scriptConfig class (within bllshtMyDatabase.py file).
- The script are mainly CASE SENSITIVE. Table names with mixed cases ARE NOT treated equally through the code.
- The script DO NOT support 'NOT' PostgreSQL keyword.
