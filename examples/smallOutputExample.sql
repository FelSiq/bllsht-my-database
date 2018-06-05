/* TOTAL OF 0 ERRORS WHILE BUILDING METADATA STRUCTURE. */
BEGIN TRANSACTION;
/* TABLE person */
INSERT INTO person ( nome, cpf )
	VALUES ( 'Breno FariasFernandes', '436.483.654-01' );
INSERT INTO person ( nome, cpf )
	VALUES ( 'Stella Jesus', '785.913.204-18' );
INSERT INTO person ( nome, cpf )
	VALUES ( 'Pedro Dias', '087.612.600-33' );
INSERT INTO person ( nome, cpf )
	VALUES ( 'Dra. Maria Vitória Duarte', '175.436.273-97' );
INSERT INTO person ( nome, cpf )
	VALUES ( 'João Miguel Santos', '950.224.092-86' );

/* TABLE worker */
INSERT INTO worker ( cpf, jobsDone )
	VALUES ( '175.436.273-97', 622876 );
INSERT INTO worker ( cpf, jobsDone )
	VALUES ( '087.612.600-33', 894328 );
INSERT INTO worker ( cpf, jobsDone )
	VALUES ( '785.913.204-18', 125995 );
INSERT INTO worker ( cpf, jobsDone )
	VALUES ( '436.483.654-01', 281552 );
INSERT INTO worker ( cpf, jobsDone )
	VALUES ( '950.224.092-86', 587790 );

/* TABLE NUMBER TOTAL: 2 */
ROLLBACK;
