/* TOTAL OF 0 ERRORS WHILE BUILDING METADATA STRUCTURE. */
BEGIN TRANSACTION;
/* TABLE funcionario */
INSERT INTO funcionario ( RG, endereco, nome, cpf, equipe, telefoneCsv, cargo )
	VALUES ( 'Magni dolorem p', 'Sítio de Santos, 38 Biquinhas 49837193 Jesus de da Cruz / PI', 'Renan Alves', '802.897.472-83', 881897, 'Cum labore reprehenderit aspernatur reiciendis ipsa nisi. Nihil modi tenetur accusamus. Dolorem q', 'PILOTO' );
INSERT INTO funcionario ( RG, endereco, nome, cpf, equipe, telefoneCsv, cargo )
	VALUES ( 'Ex quasi reru', 'Residencial Duarte Aguas Claras 76212-283 Peixoto / RN', 'Ana Clara da Rocha', '410.375.016-63', 135948, 'Beatae aspernatur accusamus ducimus quas amet recusandae. Voluptas similique porro quam quis. Possimus magn', 'COPILOTO' );
INSERT INTO funcionario ( RG, endereco, nome, cpf, equipe, telefoneCsv, cargo )
	VALUES ( 'Deleniti maxime d', 'Vila João Gabriel Alves, 13 Pongelupe 62304589 Duarte Paulista / AP', 'Emanuel Teixeira', '758.018.510-27', 440042, 'Odit veritatis quis totam delectus. Dolores temporibus maxime rerum dolorum ullam consequuntur dolores.', 'OPCAMERA' );
INSERT INTO funcionario ( RG, endereco, nome, cpf, equipe, telefoneCsv, cargo )
	VALUES ( 'Molestias temporibus ne', 'Jardim de da Cunha, 239 Nossa Senhora Da Conceição 96409-178 Moura / MA', 'Milena da Mota', '848.666.325-42', 416617, 'Vitae soluta sit vero. Natus voluptates a occaecati quas magni.Quo iste nulla a fugit d', 'ASSISTENTE' );
INSERT INTO funcionario ( RG, endereco, nome, cpf, equipe, telefoneCsv, cargo )
	VALUES ( 'Harum vel expedita ex m', 'Chácara Lopes, 95 Heliopolis 11159-075 Monteiro do Sul / AP', 'Augusto Moraes', '521.032.486-92', 659940, 'Ipsum error unde qui fugiat quod amet. Reiciendis molestiae est quia consequatur dolor. Minima laborum magnam consequuntur.', 'OPCAMERA' );
/* NULL INSERTION FOR ATTRIBUTE equipe AT TABLE funcionario  */
 INSERT INTO funcionario ( RG, endereco, nome, cpf, equipe, telefoneCsv, cargo )
	VALUES ( 'Hic dicta culpa inci', 'Campo de Castro, 88 Serra Do Curral 28017417 da Conceição Grande / AL', 'Dr. Gabriel Cardoso', '867.900.229-67', NULL, 'Quas quos cumque odio quisquam dolorum dolorum. Fuga error tempora.Quidem dolorem voluptatum magni. Dolores a', 'TECNICO' );

/* TABLE tecnico */
INSERT INTO tecnico ( especialidade, cpf )
	VALUES ( 'Deleniti recusandae unde dolor sapiente ex voluptas.', '521.032.486-92' );
INSERT INTO tecnico ( especialidade, cpf )
	VALUES ( 'Debitis molestiae exercitationem distinctio sed iusto. Culpa num', '802.897.472-83' );
INSERT INTO tecnico ( especialidade, cpf )
	VALUES ( 'Quasi excepturi magnam eos quod distinctio. Temporibus distinctio quae recusan', '410.375.016-63' );
INSERT INTO tecnico ( especialidade, cpf )
	VALUES ( 'Distinctio nisi nobis debitis recusandae. Voluptatem explicabo amet ex corporis. Suscipit quam pariatur. Adipisci rerum ', '758.018.510-27' );
INSERT INTO tecnico ( especialidade, cpf )
	VALUES ( 'Laudantium voluptas cupiditate tempora qui sed. Temporibus dolore ex eligendi iusto sint. Reiciendis ', '848.666.325-42' );

/* TABLE copiloto */
INSERT INTO copiloto ( cpf, habilitacao )
	VALUES ( '521.032.486-92', 'Earum tempor' );
INSERT INTO copiloto ( cpf, habilitacao )
	VALUES ( '758.018.510-27', 'Praesentium ' );
INSERT INTO copiloto ( cpf, habilitacao )
	VALUES ( '802.897.472-83', 'Porro porro ' );
INSERT INTO copiloto ( cpf, habilitacao )
	VALUES ( '410.375.016-63', 'Quisquam dis' );
INSERT INTO copiloto ( cpf, habilitacao )
	VALUES ( '848.666.325-42', 'Inventore qu' );

/* TABLE piloto */
INSERT INTO piloto ( cpf, habilitacao )
	VALUES ( '410.375.016-63', 'Impedit ab v' );
INSERT INTO piloto ( cpf, habilitacao )
	VALUES ( '848.666.325-42', 'Dicta tempor' );
INSERT INTO piloto ( cpf, habilitacao )
	VALUES ( '758.018.510-27', 'Quos illum n' );
INSERT INTO piloto ( cpf, habilitacao )
	VALUES ( '521.032.486-92', 'Quia volupta' );
INSERT INTO piloto ( cpf, habilitacao )
	VALUES ( '802.897.472-83', 'Vel qui fugi' );

/* TABLE assistente */
INSERT INTO assistente ( cpf )
	VALUES ( '848.666.325-42' );
INSERT INTO assistente ( cpf )
	VALUES ( '758.018.510-27' );
INSERT INTO assistente ( cpf )
	VALUES ( '410.375.016-63' );
INSERT INTO assistente ( cpf )
	VALUES ( '521.032.486-92' );
INSERT INTO assistente ( cpf )
	VALUES ( '802.897.472-83' );

/* TABLE opCamera */
INSERT INTO opCamera ( inicioCarreira, cpf )
	VALUES ( to_date ('2009-03-06', 'YYYY-MM-DD'), '521.032.486-92' );
INSERT INTO opCamera ( inicioCarreira, cpf )
	VALUES ( to_date ('2015-02-23', 'YYYY-MM-DD'), '802.897.472-83' );
INSERT INTO opCamera ( inicioCarreira, cpf )
	VALUES ( to_date ('2011-02-27', 'YYYY-MM-DD'), '848.666.325-42' );
INSERT INTO opCamera ( inicioCarreira, cpf )
	VALUES ( to_date ('2013-04-15', 'YYYY-MM-DD'), '410.375.016-63' );
INSERT INTO opCamera ( inicioCarreira, cpf )
	VALUES ( to_date ('2009-09-27', 'YYYY-MM-DD'), '758.018.510-27' );

/* TABLE equipamento */
INSERT INTO equipamento ( quantidade, nome, modelo, descricao, tipo, marca )
	VALUES ( 881357, 'Vitória Oliveira', 'Vitae similique ex molestiae. Ipsa maxime sint vero pariatur.V', 'Tempora ex hic optio quibusdam culpa. Iusto adipisci dicta officia placeat', 'DRONE', 'Illum sunt corru' );
INSERT INTO equipamento ( quantidade, nome, modelo, descricao, tipo, marca )
	VALUES ( 111274, 'Breno Almeida', 'Iure quod voluptas nam nemo. Fugit vel eaq', 'Iusto impedit reprehenderit non soluta. Optio fugit dolorem quos nobis minus. Assumenda numquam repellendus accusantium quam. Corrupti dolor unde perspiciatis iste excepturi est', 'DRONE', 'Amet nostrum dolori' );
INSERT INTO equipamento ( quantidade, nome, modelo, descricao, tipo, marca )
	VALUES ( 390177, 'Dra. Beatriz Viana', 'Quis id dolores voluptas laborum saepe. Quibusdam eum nobis quo', 'Ipsum provident tenetur numquam adipisci maxime. Error illo beatae voluptatibus. Inventore odio ex nisi ut iusto optio. Hic officiis mollitia ipsum. Eos veniam iste tempore id', 'CAMERA', 'In doloremque veniam ' );
INSERT INTO equipamento ( quantidade, nome, modelo, descricao, tipo, marca )
	VALUES ( 245677, 'Raul Rocha', 'Tenetur perspiciatis excepturi odit. Quia voluptates ', 'Tenetur expedita dolorem. Ad molestias minus alias perferendis et rem vitae. In id dolorem cum explicabo quasi possimus. Occaecati iusto laboriosam assumenda magnam cum', 'DRONE', 'Explicabo quos susc' );
INSERT INTO equipamento ( quantidade, nome, modelo, descricao, tipo, marca )
	VALUES ( 537545, 'Kamilly Mendes', 'Asperiores quis esse ab quasi corporis. Ven', 'Magni in praesentium accusantium eum aliquid est. Quibusdam ipsam eaque asperiores voluptatibus sapiente animi labore. Illum nemo minima at sit quis nam. Aspernatur recusandae porro corporis', 'CAMERA', 'Consectetur fugit do' );
/* NULL INSERTION FOR ATTRIBUTE descricao AT TABLE equipamento  */
 INSERT INTO equipamento ( quantidade, nome, modelo, descricao, tipo, marca )
	VALUES ( 305404, 'Pedro Henrique Correia', 'Commodi mollitia quibusdam totam. Pariatur perspiciatis do', NULL, 'SONORIZACAO', 'Fugiat at quia perspicia' );
/* NULL INSERTION FOR ATTRIBUTE marca AT TABLE equipamento  */
 INSERT INTO equipamento ( quantidade, nome, modelo, descricao, tipo, marca )
	VALUES ( 832013, 'Emanuelly Nunes', 'Aut repudiandae molestiae vel.Modi assumenda sequi ', 'Blanditiis provident totam consectetur voluptatem explicabo. Odio rerum dolorem nihil possimus. Quod corrupti ipsam. Ullam libero at et adipisci vel', 'CAMERA', NULL );

/* TABLE estruturacao */
INSERT INTO estruturacao ( id )
	VALUES ( 1 );
INSERT INTO estruturacao ( id )
	VALUES ( 5 );
INSERT INTO estruturacao ( id )
	VALUES ( 4 );
INSERT INTO estruturacao ( id )
	VALUES ( 2 );
INSERT INTO estruturacao ( id )
	VALUES ( 3 );

/* TABLE drone */
INSERT INTO drone ( id, fonteAlimentacao, alcanceRemoto, tempoMaxVoo )
	VALUES ( 5, 'Perspiciatis fuga necessitatibus facilis suscipit. Quaerat i', 389526, 144535 );
INSERT INTO drone ( id, fonteAlimentacao, alcanceRemoto, tempoMaxVoo )
	VALUES ( 1, 'Iste voluptas vero enim totam voluptatem volupta', 720107, 784477 );
INSERT INTO drone ( id, fonteAlimentacao, alcanceRemoto, tempoMaxVoo )
	VALUES ( 3, 'Explicabo iusto consequuntur voluptas co', 143751, 226142 );
INSERT INTO drone ( id, fonteAlimentacao, alcanceRemoto, tempoMaxVoo )
	VALUES ( 4, 'Eius nam dolorem velit quia dolorem eligend', 481142, 897048 );
INSERT INTO drone ( id, fonteAlimentacao, alcanceRemoto, tempoMaxVoo )
	VALUES ( 2, 'Consequatur occaecati autem reprehenderit impedit dolor arc', 759673, 540144 );

/* TABLE sonorizacao */
INSERT INTO sonorizacao ( id, potencia, posseEise )
	VALUES ( 3, 705064, TRUE );
INSERT INTO sonorizacao ( id, potencia, posseEise )
	VALUES ( 2, 245722, TRUE );
INSERT INTO sonorizacao ( id, potencia, posseEise )
	VALUES ( 1, 166463, TRUE );
INSERT INTO sonorizacao ( id, potencia, posseEise )
	VALUES ( 4, 531790, TRUE );
INSERT INTO sonorizacao ( id, potencia, posseEise )
	VALUES ( 5, 223539, FALSE );

/* TABLE camera */
INSERT INTO camera ( id, fonteAlimentacao, conectividade, zoomLongoAlcance, resistenteQueda, estabilizadorImagem, certificacaoIP, visaoNoturna )
	VALUES ( 5, 'Corrupti tempore quibusdam quasi fugit esse ', 'Dignissimos accusamus a fugiat ea consequatur omnis. At illo qu', TRUE, TRUE, TRUE, 'IP18I', FALSE );
INSERT INTO camera ( id, fonteAlimentacao, conectividade, zoomLongoAlcance, resistenteQueda, estabilizadorImagem, certificacaoIP, visaoNoturna )
	VALUES ( 2, 'Ex doloribus ipsum cumque distinctio nem', 'Dignissimos reprehenderit illo tempore dign', TRUE, TRUE, FALSE, 'IP37', FALSE );
INSERT INTO camera ( id, fonteAlimentacao, conectividade, zoomLongoAlcance, resistenteQueda, estabilizadorImagem, certificacaoIP, visaoNoturna )
	VALUES ( 3, 'Quaerat quisquam doloribus tenetur veniam illo ali', 'Nesciunt maxime minima sapiente ex mollitia. C', TRUE, FALSE, FALSE, 'IP156', TRUE );
INSERT INTO camera ( id, fonteAlimentacao, conectividade, zoomLongoAlcance, resistenteQueda, estabilizadorImagem, certificacaoIP, visaoNoturna )
	VALUES ( 4, 'Deleniti ipsam omnis magni sunt eveniet. Laboriosam sequi', 'Maxime earum earum itaque voluptates voluptatem porro ', FALSE, FALSE, TRUE, 'IP884y', TRUE );
INSERT INTO camera ( id, fonteAlimentacao, conectividade, zoomLongoAlcance, resistenteQueda, estabilizadorImagem, certificacaoIP, visaoNoturna )
	VALUES ( 1, 'Fugiat modi illum inventore. Nobis dolore repudiandae cu', 'Magnam nemo ducimus itaque sequi voluptatum. Facere maxi', FALSE, TRUE, FALSE, 'IP337', TRUE );

/* TABLE registros */
INSERT INTO registros ( registro, idDrone )
	VALUES ( 'Accusamus', 1 );
INSERT INTO registros ( registro, idDrone )
	VALUES ( 'Placeat d', 3 );
INSERT INTO registros ( registro, idDrone )
	VALUES ( 'Aperiam v', 2 );
INSERT INTO registros ( registro, idDrone )
	VALUES ( 'Dolores e', 1 );
INSERT INTO registros ( registro, idDrone )
	VALUES ( 'Rerum ame', 1 );

/* TABLE cameraAerea */
INSERT INTO cameraAerea ( quantidade, data, drone, camera )
	VALUES ( 767086, to_date ('2002-01-13', 'YYYY-MM-DD'), 3, 1 );
INSERT INTO cameraAerea ( quantidade, data, drone, camera )
	VALUES ( 795989, to_date ('2005-04-22', 'YYYY-MM-DD'), 3, 3 );
INSERT INTO cameraAerea ( quantidade, data, drone, camera )
	VALUES ( 876084, to_date ('2009-05-20', 'YYYY-MM-DD'), 4, 1 );
INSERT INTO cameraAerea ( quantidade, data, drone, camera )
	VALUES ( 893621, to_date ('2012-07-21', 'YYYY-MM-DD'), 5, 4 );
INSERT INTO cameraAerea ( quantidade, data, drone, camera )
	VALUES ( 137935, to_date ('2000-10-28', 'YYYY-MM-DD'), 4, 3 );

/* TABLE musico */
INSERT INTO musico ( nome, cpf )
	VALUES ( 'Natália Moura', '871.947.563-13' );
INSERT INTO musico ( nome, cpf )
	VALUES ( 'Olivia da Rosa', '602.106.862-68' );
INSERT INTO musico ( nome, cpf )
	VALUES ( 'Lívia Santos', '860.871.608-77' );
INSERT INTO musico ( nome, cpf )
	VALUES ( 'Pedro Aragão', '892.919.507-12' );
INSERT INTO musico ( nome, cpf )
	VALUES ( 'Leandro Nascimento', '405.044.018-13' );

/* TABLE banda */
INSERT INTO banda ( dataCriacao, tipo, nome, estiloMusical )
	VALUES ( to_date ('2009-10-01', 'YYYY-MM-DD'), 'CONTRATADA', 'Vinicius Barros', 'Animi omnis dolore tempora debitis nihil. I' );
INSERT INTO banda ( dataCriacao, tipo, nome, estiloMusical )
	VALUES ( to_date ('2006-09-01', 'YYYY-MM-DD'), 'PARTICULAR', 'Pedro Henrique Oliveira', 'Quae aut minus veniam numquam aspernatur dignissimos. Eos di' );
INSERT INTO banda ( dataCriacao, tipo, nome, estiloMusical )
	VALUES ( to_date ('2005-08-27', 'YYYY-MM-DD'), 'PARTICULAR', 'Dra. Sofia Correia', 'Nemo autem numquam sunt odit commodi. Rem ratione' );
INSERT INTO banda ( dataCriacao, tipo, nome, estiloMusical )
	VALUES ( to_date ('2004-04-16', 'YYYY-MM-DD'), 'CONTRATADA', 'Fernanda Nunes', 'Natus voluptates sed dolorum quia. Laboriosam in ' );
INSERT INTO banda ( dataCriacao, tipo, nome, estiloMusical )
	VALUES ( to_date ('2007-10-05', 'YYYY-MM-DD'), 'PARTICULAR', 'Igor Rezende', 'Occaecati illum quas repellendus velit hic. Ducimus commo' );
/* NULL INSERTION FOR ATTRIBUTE estiloMusical AT TABLE banda  */
 INSERT INTO banda ( dataCriacao, tipo, nome, estiloMusical )
	VALUES ( to_date ('2002-03-21', 'YYYY-MM-DD'), 'PARTICULAR', 'Dra. Ana Julia da Cruz', NULL );

/* TABLE compoe */
INSERT INTO compoe ( dataCriacaoBanda, cpfMusico, nomeBanda )
	VALUES ( to_date ('2009-10-01', 'YYYY-MM-DD'), '871.947.563-13', 'Vinicius Barros' );
INSERT INTO compoe ( dataCriacaoBanda, cpfMusico, nomeBanda )
	VALUES ( to_date ('2004-04-16', 'YYYY-MM-DD'), '860.871.608-77', 'Fernanda Nunes' );
INSERT INTO compoe ( dataCriacaoBanda, cpfMusico, nomeBanda )
	VALUES ( to_date ('2006-09-01', 'YYYY-MM-DD'), '892.919.507-12', 'Pedro Henrique Oliveira' );
INSERT INTO compoe ( dataCriacaoBanda, cpfMusico, nomeBanda )
	VALUES ( to_date ('2009-10-01', 'YYYY-MM-DD'), '405.044.018-13', 'Vinicius Barros' );
INSERT INTO compoe ( dataCriacaoBanda, cpfMusico, nomeBanda )
	VALUES ( to_date ('2005-08-27', 'YYYY-MM-DD'), '602.106.862-68', 'Dra. Sofia Correia' );

/* TABLE festaNoCruzeiro */
INSERT INTO festaNoCruzeiro ( dataFim, numeroConvidados, nome, IMO, dataInicio )
	VALUES ( to_date ('2016-04-19', 'YYYY-MM-DD'), 169591, 'Kamilly Santos', 185152, to_date ('2017-11-07', 'YYYY-MM-DD') );
INSERT INTO festaNoCruzeiro ( dataFim, numeroConvidados, nome, IMO, dataInicio )
	VALUES ( to_date ('2005-01-18', 'YYYY-MM-DD'), 847801, 'André Caldeira', 137492, to_date ('2005-05-24', 'YYYY-MM-DD') );
INSERT INTO festaNoCruzeiro ( dataFim, numeroConvidados, nome, IMO, dataInicio )
	VALUES ( to_date ('2001-11-04', 'YYYY-MM-DD'), 888263, 'Luiza Cavalcanti', 196742, to_date ('2003-11-18', 'YYYY-MM-DD') );
INSERT INTO festaNoCruzeiro ( dataFim, numeroConvidados, nome, IMO, dataInicio )
	VALUES ( to_date ('2005-03-26', 'YYYY-MM-DD'), 629591, 'Maria Clara da Luz', 444302, to_date ('2007-05-29', 'YYYY-MM-DD') );
INSERT INTO festaNoCruzeiro ( dataFim, numeroConvidados, nome, IMO, dataInicio )
	VALUES ( to_date ('2009-01-08', 'YYYY-MM-DD'), 181621, 'Sabrina Ferreira', 558403, to_date ('2012-04-22', 'YYYY-MM-DD') );
/* NULL INSERTION FOR ATTRIBUTE dataFim AT TABLE festaNoCruzeiro  */
 INSERT INTO festaNoCruzeiro ( dataFim, numeroConvidados, nome, IMO, dataInicio )
	VALUES ( NULL, 852451, 'Raquel Castro', 858929, to_date ('2007-11-07', 'YYYY-MM-DD') );
/* NULL INSERTION FOR ATTRIBUTE numeroConvidados AT TABLE festaNoCruzeiro  */
 INSERT INTO festaNoCruzeiro ( dataFim, numeroConvidados, nome, IMO, dataInicio )
	VALUES ( to_date ('2003-07-12', 'YYYY-MM-DD'), NULL, 'Dr. Calebe Rocha', 376104, to_date ('2009-01-19', 'YYYY-MM-DD') );

/* TABLE locaisCruzeiro */
INSERT INTO locaisCruzeiro ( local, IMO, dataFesta )
	VALUES ( 'Reiciendis impedit reiciendis blanditiis ut. Laboriosam voluptate beatae necessitatibus. Inventore esse odio ipsam.', 185152, to_date ('2017-11-07', 'YYYY-MM-DD') );
INSERT INTO locaisCruzeiro ( local, IMO, dataFesta )
	VALUES ( 'Corrupti iusto id repudiandae ipsam.Aliquid odit atque reiciendis. Aut error beatae excepturi eaque asperna', 444302, to_date ('2007-05-29', 'YYYY-MM-DD') );
INSERT INTO locaisCruzeiro ( local, IMO, dataFesta )
	VALUES ( 'Aspernatur odio porro itaque aliquam. Quam quis perferendis assumenda blanditii', 558403, to_date ('2012-04-22', 'YYYY-MM-DD') );
INSERT INTO locaisCruzeiro ( local, IMO, dataFesta )
	VALUES ( 'Officiis numquam doloribus excepturi fugiat magnam sed cupiditate.Sunt rem animi labore et', 196742, to_date ('2003-11-18', 'YYYY-MM-DD') );
INSERT INTO locaisCruzeiro ( local, IMO, dataFesta )
	VALUES ( 'Molestiae at possimus consequuntur. Consequuntur ad quia animi aperiam. Aut', 137492, to_date ('2005-05-24', 'YYYY-MM-DD') );

/* TABLE show */
INSERT INTO show ( dataCriacaoBanda, nomeBanda, IMO, dataFesta, data, terminoPrevisto, contrato, horaInicio )
	VALUES ( to_date ('2009-10-01', 'YYYY-MM-DD'), 'Vinicius Barros', 444302, to_date ('2007-05-29', 'YYYY-MM-DD'), to_date ('2011-10-21', 'YYYY-MM-DD'), to_timestamp ('2007-01-17 10:32:04', 'YYYY-MM-DD HH24:MI:SS'), 'Expedita quidem eaque cum quam ipsum illo. Ab tempore maio', '03:26:32' );
INSERT INTO show ( dataCriacaoBanda, nomeBanda, IMO, dataFesta, data, terminoPrevisto, contrato, horaInicio )
	VALUES ( to_date ('2006-09-01', 'YYYY-MM-DD'), 'Pedro Henrique Oliveira', 137492, to_date ('2005-05-24', 'YYYY-MM-DD'), to_date ('2014-05-09', 'YYYY-MM-DD'), to_timestamp ('2011-03-29 21:10:46', 'YYYY-MM-DD HH24:MI:SS'), 'Molestias perferendis itaque porro sunt. Quisq', '15:00:31' );
INSERT INTO show ( dataCriacaoBanda, nomeBanda, IMO, dataFesta, data, terminoPrevisto, contrato, horaInicio )
	VALUES ( to_date ('2004-04-16', 'YYYY-MM-DD'), 'Fernanda Nunes', 185152, to_date ('2017-11-07', 'YYYY-MM-DD'), to_date ('2010-04-05', 'YYYY-MM-DD'), to_timestamp ('2013-05-03 11:37:45', 'YYYY-MM-DD HH24:MI:SS'), 'Quia blanditiis ullam facilis. Alias ipsa', '22:06:00' );
INSERT INTO show ( dataCriacaoBanda, nomeBanda, IMO, dataFesta, data, terminoPrevisto, contrato, horaInicio )
	VALUES ( to_date ('2007-10-05', 'YYYY-MM-DD'), 'Igor Rezende', 196742, to_date ('2003-11-18', 'YYYY-MM-DD'), to_date ('2000-03-20', 'YYYY-MM-DD'), to_timestamp ('2000-03-06 17:03:47', 'YYYY-MM-DD HH24:MI:SS'), 'Vero eaque vero. Beatae amet assumenda rem lauda', '16:47:01' );
INSERT INTO show ( dataCriacaoBanda, nomeBanda, IMO, dataFesta, data, terminoPrevisto, contrato, horaInicio )
	VALUES ( to_date ('2009-10-01', 'YYYY-MM-DD'), 'Vinicius Barros', 137492, to_date ('2005-05-24', 'YYYY-MM-DD'), to_date ('2005-10-17', 'YYYY-MM-DD'), to_timestamp ('2015-06-15 08:10:52', 'YYYY-MM-DD HH24:MI:SS'), 'Provident eligendi ex. Minima ducimus a', '09:28:42' );
/* NULL INSERTION FOR ATTRIBUTE terminoPrevisto AT TABLE show  */
 INSERT INTO show ( dataCriacaoBanda, nomeBanda, IMO, dataFesta, data, terminoPrevisto, contrato, horaInicio )
	VALUES ( to_date ('2005-08-27', 'YYYY-MM-DD'), 'Dra. Sofia Correia', 558403, to_date ('2012-04-22', 'YYYY-MM-DD'), to_date ('2000-08-29', 'YYYY-MM-DD'), NULL, 'Labore laudantium soluta quia tem', '05:20:28' );

/* TABLE showSonorizacao */
INSERT INTO showSonorizacao ( sonorizacaoId, showId )
	VALUES ( 3, 1 );
INSERT INTO showSonorizacao ( sonorizacaoId, showId )
	VALUES ( 4, 5 );
INSERT INTO showSonorizacao ( sonorizacaoId, showId )
	VALUES ( 3, 3 );
INSERT INTO showSonorizacao ( sonorizacaoId, showId )
	VALUES ( 4, 4 );
INSERT INTO showSonorizacao ( sonorizacaoId, showId )
	VALUES ( 1, 3 );

/* TABLE album */
INSERT INTO album ( IMOFesta, dataFesta )
	VALUES ( 137492, to_date ('2005-05-24', 'YYYY-MM-DD') );
INSERT INTO album ( IMOFesta, dataFesta )
	VALUES ( 444302, to_date ('2007-05-29', 'YYYY-MM-DD') );
INSERT INTO album ( IMOFesta, dataFesta )
	VALUES ( 185152, to_date ('2017-11-07', 'YYYY-MM-DD') );
INSERT INTO album ( IMOFesta, dataFesta )
	VALUES ( 196742, to_date ('2003-11-18', 'YYYY-MM-DD') );
INSERT INTO album ( IMOFesta, dataFesta )
	VALUES ( 558403, to_date ('2012-04-22', 'YYYY-MM-DD') );

/* TABLE makingof */
INSERT INTO makingof ( IMOFesta, dataFesta )
	VALUES ( 185152, to_date ('2017-11-07', 'YYYY-MM-DD') );
INSERT INTO makingof ( IMOFesta, dataFesta )
	VALUES ( 196742, to_date ('2003-11-18', 'YYYY-MM-DD') );
INSERT INTO makingof ( IMOFesta, dataFesta )
	VALUES ( 558403, to_date ('2012-04-22', 'YYYY-MM-DD') );
INSERT INTO makingof ( IMOFesta, dataFesta )
	VALUES ( 137492, to_date ('2005-05-24', 'YYYY-MM-DD') );
INSERT INTO makingof ( IMOFesta, dataFesta )
	VALUES ( 444302, to_date ('2007-05-29', 'YYYY-MM-DD') );

/* TABLE opComCamera */
INSERT INTO opComCamera ( tipo, data, cpfOpCamera, camera )
	VALUES ( 'CINEGRAFISTA', to_date ('2013-08-12', 'YYYY-MM-DD'), '521.032.486-92', 14165629 );
INSERT INTO opComCamera ( tipo, data, cpfOpCamera, camera )
	VALUES ( 'CINEGRAFISTA', to_date ('2011-04-06', 'YYYY-MM-DD'), '410.375.016-63', 72521531 );
INSERT INTO opComCamera ( tipo, data, cpfOpCamera, camera )
	VALUES ( 'FOTOGRAFO', to_date ('2009-01-10', 'YYYY-MM-DD'), '848.666.325-42', 47193921 );
INSERT INTO opComCamera ( tipo, data, cpfOpCamera, camera )
	VALUES ( 'PARQUE', to_date ('2007-04-03', 'YYYY-MM-DD'), '521.032.486-92', 33672434 );
INSERT INTO opComCamera ( tipo, data, cpfOpCamera, camera )
	VALUES ( 'PARQUE', to_date ('2005-10-11', 'YYYY-MM-DD'), '802.897.472-83', 84096030 );

/* TABLE fotografoCruzeiro */
INSERT INTO fotografoCruzeiro ( data, categoria, cpfOpCamera, idAlbum )
	VALUES ( to_date ('2013-08-12', 'YYYY-MM-DD'), 'TECNICO', '521.032.486-92', 1 );
INSERT INTO fotografoCruzeiro ( data, categoria, cpfOpCamera, idAlbum )
	VALUES ( to_date ('2005-10-11', 'YYYY-MM-DD'), 'JUNIOR', '802.897.472-83', 4 );
INSERT INTO fotografoCruzeiro ( data, categoria, cpfOpCamera, idAlbum )
	VALUES ( to_date ('2009-01-10', 'YYYY-MM-DD'), 'JUNIOR', '848.666.325-42', 2 );
INSERT INTO fotografoCruzeiro ( data, categoria, cpfOpCamera, idAlbum )
	VALUES ( to_date ('2007-04-03', 'YYYY-MM-DD'), 'TECNICO', '521.032.486-92', 1 );
INSERT INTO fotografoCruzeiro ( data, categoria, cpfOpCamera, idAlbum )
	VALUES ( to_date ('2011-04-06', 'YYYY-MM-DD'), 'JUNIOR', '410.375.016-63', 2 );

/* TABLE cinegrafistaCruzeiro */
INSERT INTO cinegrafistaCruzeiro ( idMakingof, data, cpfOpCamera )
	VALUES ( 2, to_date ('2009-01-10', 'YYYY-MM-DD'), '848.666.325-42' );
INSERT INTO cinegrafistaCruzeiro ( idMakingof, data, cpfOpCamera )
	VALUES ( 2, to_date ('2013-08-12', 'YYYY-MM-DD'), '521.032.486-92' );
INSERT INTO cinegrafistaCruzeiro ( idMakingof, data, cpfOpCamera )
	VALUES ( 2, to_date ('2007-04-03', 'YYYY-MM-DD'), '521.032.486-92' );
INSERT INTO cinegrafistaCruzeiro ( idMakingof, data, cpfOpCamera )
	VALUES ( 1, to_date ('2011-04-06', 'YYYY-MM-DD'), '410.375.016-63' );
INSERT INTO cinegrafistaCruzeiro ( idMakingof, data, cpfOpCamera )
	VALUES ( 1, to_date ('2005-10-11', 'YYYY-MM-DD'), '802.897.472-83' );

/* TABLE parque */
INSERT INTO parque ( cnpj, mapaFilePath, endereco, nome )
	VALUES ( '36.429.550/4707-45', 'Culpa amet eum iure. Molestias voluptatum unde. Commodi nihil facere optio inventore rerum t', 'Setor Calebe Pires, 50 Vila De Sá 45418845 Cardoso do Sul / AP', 'Sr. Pietro Pires' );
INSERT INTO parque ( cnpj, mapaFilePath, endereco, nome )
	VALUES ( '50.599.284/2118-57', 'Reprehenderit sint ullam doloribus natus tenetur. Reiciendis minus corrupti distinctio nostrum voluptas di', 'Lagoa de Campos Boa União 1ª Seção 26586-824 FariasFernandes de Rocha / PI', 'Augusto Melo' );
INSERT INTO parque ( cnpj, mapaFilePath, endereco, nome )
	VALUES ( '93.977.816/1315-92', 'Explicabo ut tempore rem quis. Fuga quas odit dolorum magnam quos eius.Dignissimos ', 'Esplanada Campos, 57 Cônego Pinheiro 2ª Seção 65438-233 Cardoso do Oeste / RR', 'Sophia Fogaça' );
INSERT INTO parque ( cnpj, mapaFilePath, endereco, nome )
	VALUES ( '67.825.840/7266-54', 'Perferendis nesciunt iure eius. Similique autem vitae vel voluptatum repudiandae autem.', 'Recanto da Mata, 62 Cinquentenário 56296414 Cavalcanti / RR', 'Maria Alice Ribeiro' );
INSERT INTO parque ( cnpj, mapaFilePath, endereco, nome )
	VALUES ( '25.700.289/6084-94', 'Alias cum voluptatem alias excepturi impedit praesentium. Eligendi quas nam quas quod. R', 'Loteamento Ana Vitória Melo, 998 Horto 85733-523 Silva / MG', 'Maria Clara Mendes' );

/* TABLE festaNoParque */
INSERT INTO festaNoParque ( dataFim, dataInicio, nome, numeroConvidados, cnpjParque )
	VALUES ( to_date ('2009-05-21', 'YYYY-MM-DD'), to_date ('2017-02-01', 'YYYY-MM-DD'), 'Lucca Caldeira', 732513, '25.700.289/6084-94' );
INSERT INTO festaNoParque ( dataFim, dataInicio, nome, numeroConvidados, cnpjParque )
	VALUES ( to_date ('2003-05-09', 'YYYY-MM-DD'), to_date ('2011-08-19', 'YYYY-MM-DD'), 'Sra. Maysa Rezende', 520071, '25.700.289/6084-94' );
INSERT INTO festaNoParque ( dataFim, dataInicio, nome, numeroConvidados, cnpjParque )
	VALUES ( to_date ('2017-01-12', 'YYYY-MM-DD'), to_date ('2003-11-15', 'YYYY-MM-DD'), 'Ana Lívia Duarte', 127551, '93.977.816/1315-92' );
INSERT INTO festaNoParque ( dataFim, dataInicio, nome, numeroConvidados, cnpjParque )
	VALUES ( to_date ('2010-03-03', 'YYYY-MM-DD'), to_date ('2009-06-27', 'YYYY-MM-DD'), 'Bernardo Nunes', 234835, '93.977.816/1315-92' );
INSERT INTO festaNoParque ( dataFim, dataInicio, nome, numeroConvidados, cnpjParque )
	VALUES ( to_date ('2017-07-07', 'YYYY-MM-DD'), to_date ('2005-07-06', 'YYYY-MM-DD'), 'Srta. Stephany FariasFernandes', 658838, '50.599.284/2118-57' );
/* NULL INSERTION FOR ATTRIBUTE dataFim AT TABLE festaNoParque  */
 INSERT INTO festaNoParque ( dataFim, dataInicio, nome, numeroConvidados, cnpjParque )
	VALUES ( NULL, to_date ('2000-11-21', 'YYYY-MM-DD'), 'Camila Gomes', 289898, '67.825.840/7266-54' );

/* TABLE atracao */
INSERT INTO atracao ( poligono, nome, dataFesta, numero, cnpjParque )
	VALUES ( '{{606238, 121270, 323620}, {744364, 395327, 780816}, {668085, 667888, 750871}, {487110, 237974, 821142}, {360669, 806146, 687333}, {274019, 189979, 187178}, {260487, 577947, 420357}, {870645, 869093, 703832}, {441044, 776873, 826664}, {370798, 605434, 432013}}', 'Enrico Porto', to_date ('2011-08-19', 'YYYY-MM-DD'), 851278, '25.700.289/6084-94' );
INSERT INTO atracao ( poligono, nome, dataFesta, numero, cnpjParque )
	VALUES ( '{{757643, 389423, 664297}, {168147, 377268, 780613}, {778287, 741445, 554550}, {429038, 476701, 240710}, {803872, 369491, 545931}, {759914, 801312, 168072}, {620279, 680519, 183435}, {827948, 771041, 253304}, {749254, 356325, 252655}, {594705, 577878, 367412}}', 'Clara Peixoto', to_date ('2011-08-19', 'YYYY-MM-DD'), 258136, '25.700.289/6084-94' );
INSERT INTO atracao ( poligono, nome, dataFesta, numero, cnpjParque )
	VALUES ( '{{745085, 209963, 623815}, {712143, 688347, 803422}, {896364, 477325, 552769}, {298747, 720515, 276259}, {491891, 491865, 130977}, {894498, 371456, 591462}, {759634, 837159, 194053}, {793308, 463521, 892105}, {588279, 495281, 455281}, {598605, 713761, 873162}}', 'Sr. Luiz Miguel Duarte', to_date ('2011-08-19', 'YYYY-MM-DD'), 438001, '25.700.289/6084-94' );
INSERT INTO atracao ( poligono, nome, dataFesta, numero, cnpjParque )
	VALUES ( '{{691786, 307174, 277072}, {372598, 628020, 360905}, {813353, 671142, 566565}, {784686, 256796, 430222}, {764696, 335009, 662829}, {882071, 640018, 408854}, {828346, 885627, 872080}, {289434, 816652, 651720}, {173638, 630283, 151541}, {285511, 685215, 714011}}', 'Vitor Gabriel da Paz', to_date ('2011-08-19', 'YYYY-MM-DD'), 728360, '25.700.289/6084-94' );
INSERT INTO atracao ( poligono, nome, dataFesta, numero, cnpjParque )
	VALUES ( '{{411796, 298405, 830715}, {597107, 139827, 136637}, {756943, 286538, 433384}, {642120, 115246, 605287}, {236830, 390869, 703816}, {541486, 783313, 550094}, {254539, 310248, 516840}, {685629, 601702, 333184}, {539401, 553722, 777145}, {778449, 223180, 233762}}', 'Raul Vieira', to_date ('2005-07-06', 'YYYY-MM-DD'), 140219, '50.599.284/2118-57' );

/* TABLE opParque */
INSERT INTO opParque ( idCameraSecundaria, cpfAssistente, dataInicioParque, cpfOpCamera, cnpjParque, data )
	VALUES ( 3, '521.032.486-92', to_date ('2017-02-01', 'YYYY-MM-DD'), '410.375.016-63', '25.700.289/6084-94', to_date ('2011-04-06', 'YYYY-MM-DD') );
INSERT INTO opParque ( idCameraSecundaria, cpfAssistente, dataInicioParque, cpfOpCamera, cnpjParque, data )
	VALUES ( 4, '758.018.510-27', to_date ('2009-06-27', 'YYYY-MM-DD'), '521.032.486-92', '93.977.816/1315-92', to_date ('2013-08-12', 'YYYY-MM-DD') );
INSERT INTO opParque ( idCameraSecundaria, cpfAssistente, dataInicioParque, cpfOpCamera, cnpjParque, data )
	VALUES ( 2, '802.897.472-83', to_date ('2011-08-19', 'YYYY-MM-DD'), '410.375.016-63', '25.700.289/6084-94', to_date ('2011-04-06', 'YYYY-MM-DD') );
INSERT INTO opParque ( idCameraSecundaria, cpfAssistente, dataInicioParque, cpfOpCamera, cnpjParque, data )
	VALUES ( 5, '410.375.016-63', to_date ('2005-07-06', 'YYYY-MM-DD'), '521.032.486-92', '50.599.284/2118-57', to_date ('2007-04-03', 'YYYY-MM-DD') );
INSERT INTO opParque ( idCameraSecundaria, cpfAssistente, dataInicioParque, cpfOpCamera, cnpjParque, data )
	VALUES ( 2, '802.897.472-83', to_date ('2003-11-15', 'YYYY-MM-DD'), '521.032.486-92', '93.977.816/1315-92', to_date ('2007-04-03', 'YYYY-MM-DD') );

/* TABLE pontoInstalacao */
INSERT INTO pontoInstalacao ( fonteAlimentacao, conectividade, coordenadas, cnpjParque, contatoAgua, descricao, iluminacao )
	VALUES ( 'Similique vitae labor', 'Quisquam quae ea quib', '{872854, 752782, 623227}', '50.599.284/2118-57', TRUE, 'Minus praesentium fuga suscipit vitae illo velit. Beatae accusamus quas error cumque pariatur possimus. Id reiciendis quibusdam ', 'BAIXA' );
INSERT INTO pontoInstalacao ( fonteAlimentacao, conectividade, coordenadas, cnpjParque, contatoAgua, descricao, iluminacao )
	VALUES ( 'Praesentium optio nobis ac', 'Dolore consequuntur odit in.', '{750789, 398175, 595019}', '50.599.284/2118-57', FALSE, 'Sequi in assumenda nostrum. Provident occaecati maxime ducimus deleniti accusantium illo voluptatem.', 'ALTA' );
INSERT INTO pontoInstalacao ( fonteAlimentacao, conectividade, coordenadas, cnpjParque, contatoAgua, descricao, iluminacao )
	VALUES ( 'Tempora minus ducimus', 'Deleniti fugiat fac', '{280092, 732411, 523497}', '36.429.550/4707-45', FALSE, 'At eos vitae. Reprehenderit rem doloremque dolorem suscipit voluptatibus. Adipisci corrupti quidem quam tempora facere dolore ac', 'BAIXA' );
INSERT INTO pontoInstalacao ( fonteAlimentacao, conectividade, coordenadas, cnpjParque, contatoAgua, descricao, iluminacao )
	VALUES ( 'Sed dolore incidu', 'Et aut laborum necessita', '{626484, 260759, 374446}', '67.825.840/7266-54', TRUE, 'Velit fuga commodi labore est nulla earum. Facere alias quod odio tempora nisi nisi. Et corporis vero tempore.', 'ALTA' );
INSERT INTO pontoInstalacao ( fonteAlimentacao, conectividade, coordenadas, cnpjParque, contatoAgua, descricao, iluminacao )
	VALUES ( 'Veniam molestias ', 'Neque ipsa expedita cu', '{180120, 555124, 105759}', '36.429.550/4707-45', FALSE, 'Laudantium dicta debitis repudiandae debitis. Necessitatibus praesentium quas ducimus dolor adipisci magni. Eum consectetur dolo', 'ALTA' );
/* NULL INSERTION FOR ATTRIBUTE fonteAlimentacao AT TABLE pontoInstalacao  */
 INSERT INTO pontoInstalacao ( fonteAlimentacao, conectividade, coordenadas, cnpjParque, contatoAgua, descricao, iluminacao )
	VALUES ( NULL, 'Nisi temporibus facere co', '{136357, 488953, 303150}', '36.429.550/4707-45', FALSE, 'Exercitationem quod et unde reprehenderit. Tempora earum blanditiis vitae. Placeat accusantium sapiente sit rem distinctio eum.', 'ALTA' );
/* NULL INSERTION FOR ATTRIBUTE conectividade AT TABLE pontoInstalacao  */
 INSERT INTO pontoInstalacao ( fonteAlimentacao, conectividade, coordenadas, cnpjParque, contatoAgua, descricao, iluminacao )
	VALUES ( 'Odit error corporis rerum. ', NULL, '{724763, 150621, 205910}', '93.977.816/1315-92', TRUE, 'Alias doloribus esse. Odio assumenda occaecati consequuntur consequuntur modi eveniet. Dignissimos blanditiis cumque velit. Offi', 'BAIXA' );
/* NULL INSERTION FOR ATTRIBUTE contatoAgua AT TABLE pontoInstalacao  */
 INSERT INTO pontoInstalacao ( fonteAlimentacao, conectividade, coordenadas, cnpjParque, contatoAgua, descricao, iluminacao )
	VALUES ( 'Minus neque nemo aliquid asper', 'Odio amet excepturi repe', '{221672, 377041, 796486}', '36.429.550/4707-45', NULL, 'Recusandae consectetur modi impedit. Veritatis aperiam delectus libero dicta. Dolores culpa accusamus. Quam commodi consequuntur', 'MEDIA' );
/* NULL INSERTION FOR ATTRIBUTE descricao AT TABLE pontoInstalacao  */
 INSERT INTO pontoInstalacao ( fonteAlimentacao, conectividade, coordenadas, cnpjParque, contatoAgua, descricao, iluminacao )
	VALUES ( 'Error quidem amet alias at. ', 'Itaque sunt culpa occaecati dig', '{721165, 676929, 838890}', '67.825.840/7266-54', FALSE, NULL, 'MEDIA' );
/* NULL INSERTION FOR ATTRIBUTE iluminacao AT TABLE pontoInstalacao  */
 INSERT INTO pontoInstalacao ( fonteAlimentacao, conectividade, coordenadas, cnpjParque, contatoAgua, descricao, iluminacao )
	VALUES ( 'Nemo tenetur saepe eli', 'Unde provident molesti', '{406590, 554817, 824486}', '50.599.284/2118-57', TRUE, 'Molestias repudiandae accusantium vero neque rem. Similique neque sunt perferendis doloremque minus blanditiis earum.', NULL );

/* TABLE pontoCamera */
INSERT INTO pontoCamera ( quantidade, coordenadas, idCamera, data, cnpjParque )
	VALUES ( 309653, '{626484, 260759, 374446}', 4, to_date ('2006-02-22', 'YYYY-MM-DD'), '67.825.840/7266-54' );
INSERT INTO pontoCamera ( quantidade, coordenadas, idCamera, data, cnpjParque )
	VALUES ( 775950, '{872854, 752782, 623227}', 3, to_date ('2014-03-22', 'YYYY-MM-DD'), '50.599.284/2118-57' );
INSERT INTO pontoCamera ( quantidade, coordenadas, idCamera, data, cnpjParque )
	VALUES ( 745937, '{872854, 752782, 623227}', 5, to_date ('2008-05-21', 'YYYY-MM-DD'), '50.599.284/2118-57' );
INSERT INTO pontoCamera ( quantidade, coordenadas, idCamera, data, cnpjParque )
	VALUES ( 420276, '{750789, 398175, 595019}', 2, to_date ('2011-08-26', 'YYYY-MM-DD'), '50.599.284/2118-57' );
INSERT INTO pontoCamera ( quantidade, coordenadas, idCamera, data, cnpjParque )
	VALUES ( 303289, '{750789, 398175, 595019}', 3, to_date ('2003-10-07', 'YYYY-MM-DD'), '50.599.284/2118-57' );

/* TABLE pontoEstrutura */
INSERT INTO pontoEstrutura ( quantidade, idEstruturacao, coordenadas, data, cnpjParque )
	VALUES ( 275402, 1, '{750789, 398175, 595019}', to_date ('2002-09-04', 'YYYY-MM-DD'), '50.599.284/2118-57' );
INSERT INTO pontoEstrutura ( quantidade, idEstruturacao, coordenadas, data, cnpjParque )
	VALUES ( 559427, 5, '{280092, 732411, 523497}', to_date ('2006-03-26', 'YYYY-MM-DD'), '36.429.550/4707-45' );
INSERT INTO pontoEstrutura ( quantidade, idEstruturacao, coordenadas, data, cnpjParque )
	VALUES ( 202546, 3, '{626484, 260759, 374446}', to_date ('2007-06-11', 'YYYY-MM-DD'), '67.825.840/7266-54' );
INSERT INTO pontoEstrutura ( quantidade, idEstruturacao, coordenadas, data, cnpjParque )
	VALUES ( 364132, 4, '{180120, 555124, 105759}', to_date ('2016-09-06', 'YYYY-MM-DD'), '36.429.550/4707-45' );
INSERT INTO pontoEstrutura ( quantidade, idEstruturacao, coordenadas, data, cnpjParque )
	VALUES ( 652983, 4, '{180120, 555124, 105759}', to_date ('2010-11-19', 'YYYY-MM-DD'), '36.429.550/4707-45' );

/* TABLE pontoSom */
INSERT INTO pontoSom ( quantidade, coordenadas, numeroGrafo, cnpjParque, idSonorizacao, data )
	VALUES ( 518447, '{872854, 752782, 623227}', 394330, '50.599.284/2118-57', 3, to_date ('2015-07-04', 'YYYY-MM-DD') );
INSERT INTO pontoSom ( quantidade, coordenadas, numeroGrafo, cnpjParque, idSonorizacao, data )
	VALUES ( 566315, '{280092, 732411, 523497}', 720963, '36.429.550/4707-45', 2, to_date ('2009-04-26', 'YYYY-MM-DD') );
INSERT INTO pontoSom ( quantidade, coordenadas, numeroGrafo, cnpjParque, idSonorizacao, data )
	VALUES ( 606725, '{750789, 398175, 595019}', 596045, '50.599.284/2118-57', 2, to_date ('2008-03-14', 'YYYY-MM-DD') );
INSERT INTO pontoSom ( quantidade, coordenadas, numeroGrafo, cnpjParque, idSonorizacao, data )
	VALUES ( 162104, '{872854, 752782, 623227}', 776750, '50.599.284/2118-57', 3, to_date ('2009-05-11', 'YYYY-MM-DD') );
INSERT INTO pontoSom ( quantidade, coordenadas, numeroGrafo, cnpjParque, idSonorizacao, data )
	VALUES ( 388838, '{180120, 555124, 105759}', 178308, '36.429.550/4707-45', 3, to_date ('2003-04-08', 'YYYY-MM-DD') );
/* NULL INSERTION FOR ATTRIBUTE numeroGrafo AT TABLE pontoSom  */
 INSERT INTO pontoSom ( quantidade, coordenadas, numeroGrafo, cnpjParque, idSonorizacao, data )
	VALUES ( 496222, '{872854, 752782, 623227}', NULL, '50.599.284/2118-57', 3, to_date ('2014-09-04', 'YYYY-MM-DD') );
/* NULL INSERTION FOR ATTRIBUTE data AT TABLE pontoSom  */
 INSERT INTO pontoSom ( quantidade, coordenadas, numeroGrafo, cnpjParque, idSonorizacao, data )
	VALUES ( 222766, '{626484, 260759, 374446}', 178573, '67.825.840/7266-54', 2, NULL );

/* TABLE opera */
INSERT INTO opera ( cpfPiloto, dataFesta, idDrone, cnpjParque )
	VALUES ( '758.018.510-27', to_date ('2011-08-19', 'YYYY-MM-DD'), 83355194, '25.700.289/6084-94' );
INSERT INTO opera ( cpfPiloto, dataFesta, idDrone, cnpjParque )
	VALUES ( '802.897.472-83', to_date ('2003-11-15', 'YYYY-MM-DD'), 79344498, '93.977.816/1315-92' );
INSERT INTO opera ( cpfPiloto, dataFesta, idDrone, cnpjParque )
	VALUES ( '758.018.510-27', to_date ('2003-11-15', 'YYYY-MM-DD'), 85605026, '93.977.816/1315-92' );
INSERT INTO opera ( cpfPiloto, dataFesta, idDrone, cnpjParque )
	VALUES ( '848.666.325-42', to_date ('2009-06-27', 'YYYY-MM-DD'), 12434146, '93.977.816/1315-92' );
INSERT INTO opera ( cpfPiloto, dataFesta, idDrone, cnpjParque )
	VALUES ( '521.032.486-92', to_date ('2017-02-01', 'YYYY-MM-DD'), 48585485, '25.700.289/6084-94' );

/* TABLE auxilia */
INSERT INTO auxilia ( cpfPiloto, dataFesta, cpfCopiloto, cnpjParque )
	VALUES ( '848.666.325-42', to_date ('2009-06-27', 'YYYY-MM-DD'), '521.032.486-92', '93.977.816/1315-92' );
INSERT INTO auxilia ( cpfPiloto, dataFesta, cpfCopiloto, cnpjParque )
	VALUES ( '758.018.510-27', to_date ('2011-08-19', 'YYYY-MM-DD'), '848.666.325-42', '25.700.289/6084-94' );
INSERT INTO auxilia ( cpfPiloto, dataFesta, cpfCopiloto, cnpjParque )
	VALUES ( '758.018.510-27', to_date ('2005-07-06', 'YYYY-MM-DD'), '802.897.472-83', '50.599.284/2118-57' );
INSERT INTO auxilia ( cpfPiloto, dataFesta, cpfCopiloto, cnpjParque )
	VALUES ( '758.018.510-27', to_date ('2009-06-27', 'YYYY-MM-DD'), '758.018.510-27', '93.977.816/1315-92' );
INSERT INTO auxilia ( cpfPiloto, dataFesta, cpfCopiloto, cnpjParque )
	VALUES ( '802.897.472-83', to_date ('2003-11-15', 'YYYY-MM-DD'), '410.375.016-63', '93.977.816/1315-92' );

/* TABLE manutencao */
INSERT INTO manutencao ( cpfTecnico, data, idEquipamento )
	VALUES ( '848.666.325-42', to_date ('2004-08-22', 'YYYY-MM-DD'), 1 );
INSERT INTO manutencao ( cpfTecnico, data, idEquipamento )
	VALUES ( '848.666.325-42', to_date ('2006-07-16', 'YYYY-MM-DD'), 5 );
INSERT INTO manutencao ( cpfTecnico, data, idEquipamento )
	VALUES ( '410.375.016-63', to_date ('2004-03-24', 'YYYY-MM-DD'), 2 );
INSERT INTO manutencao ( cpfTecnico, data, idEquipamento )
	VALUES ( '521.032.486-92', to_date ('2008-07-24', 'YYYY-MM-DD'), 3 );
INSERT INTO manutencao ( cpfTecnico, data, idEquipamento )
	VALUES ( '848.666.325-42', to_date ('2013-02-29', 'YYYY-MM-DD'), 4 );

/* TABLE NUMBER TOTAL: 36 */
ROLLBACK;
