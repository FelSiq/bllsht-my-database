N TRANSACTION;
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

