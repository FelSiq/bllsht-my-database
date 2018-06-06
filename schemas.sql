BEGIN TRANSACTION;

/* TABELA 1 */
CREATE TABLE funcionario(
	cpf CHAR(14),
	nome VARCHAR(128) NOT NULL,
	RG VARCHAR(24) NOT NULL,
	endereco VARCHAR(128) NOT NULL,
	cargo VARCHAR(10) NOT NULL,
	equipe INTEGER,
	telefoneCsv VARCHAR(128) NOT NULL,
	CONSTRAINT pk_funcionario
		PRIMARY KEY (cpf),
	CONSTRAINT ck1_funcionario
		CHECK ( cpf ~ '^[0-9]{3}\.[0-9]{3}\.[0-9]{3}\-[0-9]{2}$' ),
	CONSTRAINT ck2_funcionario 
		CHECK ( upper(cargo) IN ('PILOTO', 'COPILOTO', 'ASSISTENTE', 'TECNICO', 'OPCAMERA') )
);


/* TABELA 2 */
CREATE TABLE tecnico(
	cpf CHAR(14),
	especialidade VARCHAR(128) NOT NULL,
	CONSTRAINT pk_tecnico
		PRIMARY KEY (cpf),
	CONSTRAINT fk_tecnico
		FOREIGN KEY (cpf)
		REFERENCES funcionario
		ON DELETE CASCADE
);

/* TABELA 3 */
CREATE TABLE copiloto(
	cpf CHAR(14),
	habilitacao CHAR(12) NOT NULL, /* Exemplo: PP-224511425 (anac) */
	CONSTRAINT pk_copiloto
		PRIMARY KEY(cpf),
	CONSTRAINT un_copiloto
		UNIQUE (habilitacao),
	CONSTRAINT fk_copiloto
		FOREIGN KEY (cpf)
		REFERENCES funcionario
		ON DELETE CASCADE
);

/* TABELA 4 */
CREATE TABLE piloto(
	cpf CHAR(14),
	habilitacao CHAR(12) NOT NULL, /* Exemplo: PP-224511425 (anac) */
	CONSTRAINT pk_piloto
		PRIMARY KEY(cpf),
	CONSTRAINT un_piloto
		UNIQUE (habilitacao),
	CONSTRAINT fk_piloto
		FOREIGN KEY (cpf)
		REFERENCES funcionario
		ON DELETE CASCADE
);

/* TABELA 5 */
CREATE TABLE assistente(
	cpf CHAR(14),
	CONSTRAINT pk_assistente
		PRIMARY KEY(cpf),
	CONSTRAINT fk_assistente
		FOREIGN KEY (cpf)
		REFERENCES funcionario
		ON DELETE CASCADE
);

/* TABELA 6 */
CREATE TABLE opCamera (
	cpf CHAR(14),
	inicioCarreira DATE NOT NULL,
	CONSTRAINT pk_opCamera
		PRIMARY KEY (cpf),
	CONSTRAINT fk_opCamera
		FOREIGN KEY (cpf)
		REFERENCES funcionario
		ON DELETE CASCADE
);


/* TABELA 7 */
CREATE TABLE equipamento (
	id BIGSERIAL,
	modelo VARCHAR(64) NOT NULL,
	nome VARCHAR(128) NOT NULL,
	quantidade INTEGER NOT NULL,
	marca VARCHAR(32),
	descricao VARCHAR,
	tipo CHAR(12) NOT NULL,
	CONSTRAINT pk_equipamento
		PRIMARY KEY(id),
	CONSTRAINT un_equipamento
		UNIQUE (modelo, nome),
	CONSTRAINT ck_equipamento
		CHECK ( upper(tipo) IN ('DRONE', 'CAMERA', 'ESTRUTURACAO', 'SONORIZACAO') )
);

/* TABELA 8 */
CREATE TABLE estruturacao (
	id BIGINT,
	CONSTRAINT pk_estruturacao
		PRIMARY KEY (id),
	CONSTRAINT fk_estruturacao
		FOREIGN KEY (id)
		REFERENCES equipamento
		ON DELETE CASCADE
);

/* TABELA 9 */
CREATE TABLE drone (
	id BIGINT,
	fonteAlimentacao VARCHAR(64),
	tempoMaxVoo INTEGER, /* em minutos */
	alcanceRemoto INTEGER, /* em metros */
	CONSTRAINT pk_drone
		PRIMARY KEY (id),
	CONSTRAINT fk_drone
		FOREIGN KEY (id)
		REFERENCES equipamento
		ON DELETE CASCADE
);

/* TABELA 10 */
CREATE TABLE sonorizacao (
	id BIGINT,
	potencia INTEGER, /* em watts */
	posseEise BOOLEAN NOT NULL,
	CONSTRAINT pk_sonorizacao
		PRIMARY KEY (id),
	CONSTRAINT fk_sonorizacao
		FOREIGN KEY (id)
		REFERENCES equipamento
		ON DELETE CASCADE
);

/* TABELA 11 */
CREATE TABLE camera (
	id BIGINT,
	fonteAlimentacao VARCHAR(64),
	certificacaoIP VARCHAR(6), /* Pode ser: IP29K, IP291K, IP29 */
	resistenteQueda BOOLEAN DEFAULT FALSE,
	visaoNoturna BOOLEAN DEFAULT FALSE,
	zoomLongoAlcance BOOLEAN DEFAULT FALSE,
	estabilizadorImagem BOOLEAN DEFAULT FALSE,
	conectividade VARCHAR(64),
	CONSTRAINT pk_camera
		PRIMARY KEY (id),
	CONSTRAINT fk_camera
		FOREIGN KEY (id)
		REFERENCES equipamento
		ON DELETE CASCADE,
	CONSTRAINT ck_camera
		/* Deve ter 2 ou 3 dígitos em sequencia e talvez terminar com uma letra */
		CHECK ( certificacaoIP ~ '^IP[0-9]{2,3}[a-zA-Z]{0,1}$' )
);

/* TABELA 12 */
CREATE TABLE registros (
	idDrone BIGINT,
	registro CHAR(9), /* São 9 dígitos pela SISANT */ 
	CONSTRAINT pk_registros
		PRIMARY KEY (registro),
	CONSTRAINT fk_registros
		FOREIGN KEY (idDrone)
		REFERENCES drone
		ON DELETE RESTRICT /* O usuário deve retirar os registros antes de deletar um drone. */
);

/* TABELA 13 */
CREATE TABLE cameraAerea (
	camera BIGINT,
	drone BIGINT,
	data DATE,
	quantidade INTEGER NOT NULL,
	CONSTRAINT pk_cameraAerea
		PRIMARY KEY (camera, drone, data),
	CONSTRAINT fk1_cameraAerea
		FOREIGN KEY (camera)
		REFERENCES camera
		ON DELETE RESTRICT, /* Para guardar histórico */
	CONSTRAINT fk2_cameraAerea
		FOREIGN KEY (drone)
		REFERENCES drone
		ON DELETE RESTRICT /* Para guardar histórico */
);

/* TABELA 14 */
CREATE TABLE musico (
	cpf CHAR(14),
	nome VARCHAR(128) NOT NULL,
	CONSTRAINT pk_musico
		PRIMARY KEY (cpf),
	CONSTRAINT ck1_musico
		CHECK ( cpf ~ '^[0-9]{3}\.[0-9]{3}\.[0-9]{3}\-[0-9]{2}$' )
);

/* TABELA 15 */
CREATE TABLE banda (
	nome VARCHAR(64),
	dataCriacao DATE,
	estiloMusical VARCHAR(64),
	tipo CHAR(10) NOT NULL,
	CONSTRAINT pk_banda
		PRIMARY KEY (nome, dataCriacao),
	CONSTRAINT ck_banda
		CHECK ( upper(tipo) IN ('PARTICULAR', 'CONTRATADA') )
);

/* TABELA 16 */
CREATE TABLE compoe (
	cpfMusico CHAR (14),
	nomeBanda VARCHAR(64),
	dataCriacaoBanda DATE,
	CONSTRAINT pk_compoe
		PRIMARY KEY (cpfMusico, nomeBanda, dataCriacaoBanda),
	CONSTRAINT fk1_compoe
		FOREIGN KEY (cpfMusico)
		REFERENCES musico
		ON DELETE RESTRICT, /* Não é para deletar essas informações! */
	CONSTRAINT fk2_compoe
		FOREIGN KEY (nomeBanda, dataCriacaoBanda)
		REFERENCES banda
		ON DELETE RESTRICT /* Não é para deletar essas informações! */
);

/* TABELA 17 */
CREATE TABLE festaNoCruzeiro (
	IMO INTEGER, /* Exemplo IMO: 9710880, 1009613, 8852356 */
	dataInicio DATE,
	dataFim DATE,
	numeroConvidados INTEGER,
	nome VARCHAR(128) NOT NULL,
	CONSTRAINT pk_festaNoCruzeiro
		PRIMARY KEY (IMO, dataInicio)
);

/* TABELA 18 */
CREATE TABLE locaisCruzeiro (
	IMO INTEGER,
	dataFesta DATE,
	local VARCHAR(128),
	CONSTRAINT pk_locaisCruzeiro
		PRIMARY KEY (IMO, dataFesta),
	CONSTRAINT fk_locaisCruzeiro
		FOREIGN KEY (IMO, dataFesta)
		REFERENCES festaNoCruzeiro
		ON DELETE RESTRICT /* Para armazenar histórico */
);

/* TABELA 19 */
CREATE TABLE show (
	id BIGSERIAL,
	IMO INTEGER NOT NULL,
	dataFesta DATE NOT NULL,
	nomeBanda VARCHAR(64) NOT NULL,
	dataCriacaoBanda DATE NOT NULL,
	data DATE NOT NULL,
	horaInicio TIME NOT NULL,
	terminoPrevisto TIMESTAMP, /* TIMESTAMP guarda hora e data */
	contrato VARCHAR(64), /* Qual é o tamanho do número de contrato? */
	CONSTRAINT pk_show
		PRIMARY KEY (id),
	CONSTRAINT un1_show
		UNIQUE (IMO, dataFesta, nomeBanda, dataCriacaoBanda),
	CONSTRAINT un2_show
		UNIQUE (contrato),
	CONSTRAINT fk1_show
		FOREIGN KEY (IMO, dataFesta)
		REFERENCES festaNoCruzeiro
		ON DELETE RESTRICT, /* Histórico! */
	CONSTRAINT fk2_show
		FOREIGN KEY (nomeBanda, dataCriacaoBanda)
		REFERENCES banda
		ON DELETE RESTRICT /* Histórico! */
);

/* TABELA 20 */
CREATE TABLE showSonorizacao (
	showId BIGINT,
	sonorizacaoId BIGINT,
	CONSTRAINT pk_showSonorizacao
		PRIMARY KEY (showId, sonorizacaoId),
	CONSTRAINT fk1_showSonorizacao
		FOREIGN KEY (showId)
		REFERENCES show
		ON DELETE RESTRICT, /* Histórico */
	CONSTRAINT fk2_showSonorizacao
		FOREIGN KEY (sonorizacaoId)
		REFERENCES sonorizacao
		ON DELETE RESTRICT /* Histórico */
);

/* TABELA 21 */
CREATE TABLE album (
	id BIGSERIAL,
	IMOFesta INTEGER NOT NULL,
	dataFesta DATE NOT NULL,
	CONSTRAINT pk_album
		PRIMARY KEY(id),
	CONSTRAINT un_album
		UNIQUE (IMOFesta, dataFesta),
	CONSTRAINT fk_album
		FOREIGN KEY (IMOFesta, dataFesta)
		REFERENCES festaNoCruzeiro
		ON DELETE RESTRICT /* Histórico */
);

/* TABELA 22 */
CREATE TABLE makingof (
	id BIGSERIAL,
	IMOFesta INTEGER NOT NULL,
	dataFesta DATE NOT NULL,
	CONSTRAINT pk_makingof
		PRIMARY KEY(id),
	CONSTRAINT un_makingof
		UNIQUE (IMOFesta, dataFesta),
	CONSTRAINT fk_makingof
		FOREIGN KEY (IMOFesta, dataFesta)
		REFERENCES festaNoCruzeiro
		ON DELETE RESTRICT /* Histórico */
);

/* TABELA 23 */
CREATE TABLE opComCamera (
	cpfOpCamera CHAR(14),
	data DATE,
	camera BIGINT NOT NULL,
	tipo CHAR(12) NOT NULL,
	CONSTRAINT pk_opComCamera
		PRIMARY KEY (cpfOpCamera, data),
	CONSTRAINT fk_opComCamera
		FOREIGN KEY (cpfOpCamera)
		REFERENCES opCamera
		ON DELETE RESTRICT, /* Histórico */ 
	CONSTRAINT ck_opComCamera
		CHECK ( upper(tipo) IN ('PARQUE', 'FOTOGRAFO', 'CINEGRAFISTA' ) )
);

/* TABELA 24 */
CREATE TABLE fotografoCruzeiro (
	cpfOpCamera CHAR(14),
	data DATE,
	categoria CHAR(12) NOT NULL,
	idAlbum BIGINT NOT NULL,
	CONSTRAINT pk_fotografoCruzeiro
		PRIMARY KEY (cpfOpCamera, data),
	CONSTRAINT fk1_fotografoCruzeiro
		FOREIGN KEY (cpfOpCamera, data)
		REFERENCES opComCamera
		ON DELETE RESTRICT, /* Histórico */
	CONSTRAINT fk2_fotografoCruzeiro
		FOREIGN KEY (idAlbum)
		REFERENCES album
		ON DELETE RESTRICT, /* Historico */
	CONSTRAINT ck_fotografoCruzeiro
		CHECK ( upper(categoria) IN ('ESPECIALISTA', 'TECNICO', 'JUNIOR') )
);

/* TABELA 25 */
CREATE TABLE cinegrafistaCruzeiro (
	cpfOpCamera CHAR(14),
	data DATE,
	idMakingof BIGINT NOT NULL,
	CONSTRAINT pk_cinegrafistaCruzeiro
		PRIMARY KEY (cpfOpCamera, data),
	CONSTRAINT fk1_cinegrafistaCruzeiro
		FOREIGN KEY (cpfOpCamera, data)
		REFERENCES opComCamera
		ON DELETE RESTRICT, /* Histórico */
	CONSTRAINT fk2_cinegrafistaCruzeiro
		FOREIGN KEY (idMakingof)
		REFERENCES makingof
		ON DELETE RESTRICT /* Historico */
);

/* TABELA 26 */
CREATE TABLE parque (
	cnpj CHAR(18), /* Exemplo: 07.414.674/0001-81 */
	nome VARCHAR(64) NOT NULL,
	mapaFilePath VARCHAR(128) NOT NULL,
	endereco VARCHAR(128) NOT NULL,
	CONSTRAINT pk_parque
		PRIMARY KEY (cnpj),
	CONSTRAINT ck_parque
		CHECK ( cnpj ~ '^[0-9]{2}\.[0-9]{3}\.[0-9]{3}\/[0-9]{4}\-[0-9]{2}$' )
);

/* TABELA 27 */
CREATE TABLE festaNoParque (
	cnpjParque CHAR(18),
	dataInicio DATE,
	dataFim DATE,
	numeroConvidados INTEGER NOT NULL,
	nome VARCHAR(64) NOT NULL,
	CONSTRAINT pk_festaNoParque
		PRIMARY KEY (cnpjParque, dataInicio),
	CONSTRAINT fk_festaNoParque
		FOREIGN KEY (cnpjParque)
		REFERENCES parque
		ON DELETE RESTRICT
);

/* TABELA 28 */
CREATE TABLE atracao (
	cnpjParque CHAR(18),
	dataFesta DATE,
	numero INTEGER,
	nome VARCHAR(64),
	poligono INTEGER[10][3] NOT NULL, /* Um polígono com no máximo 10 pontos */
	CONSTRAINT pk_atracao
		PRIMARY KEY (cnpjParque, dataFesta, numero, nome),
	CONSTRAINT fk_atracao
		FOREIGN KEY (cnpjParque, dataFesta)
		REFERENCES festaNoParque
		ON DELETE RESTRICT
);

/* TABELA 29 */
CREATE TABLE opParque (
	cpfOpCamera CHAR(14),
	data DATE,
	idCameraSecundaria BIGINT,
	cnpjParque CHAR(18) NOT NULL,
	dataInicioParque DATE NOT NULL,
	cpfAssistente CHAR(14) NOT NULL,
	CONSTRAINT pk_opParque
		PRIMARY KEY (cpfOpCamera, data, idCameraSecundaria),
	CONSTRAINT un_opParque
		UNIQUE (cnpjParque, dataInicioParque, cpfAssistente),
	CONSTRAINT fk1_opParque
		FOREIGN KEY (cpfOpCamera, data)
		REFERENCES opComCamera
		ON DELETE RESTRICT,
	CONSTRAINT fk2_opParque
		FOREIGN KEY (idCameraSecundaria)
		REFERENCES camera
		ON DELETE RESTRICT,
	CONSTRAINT fk3_opParque
		FOREIGN KEY (cnpjParque, dataInicioParque)
		REFERENCES festaNoParque
		ON DELETE RESTRICT,
	CONSTRAINT fk4_opParque
		FOREIGN KEY (cpfAssistente)
		REFERENCES assistente
		ON DELETE RESTRICT
);

/* TABELA 30 */
CREATE TABLE pontoInstalacao (
	cnpjParque CHAR(18),
	coordenadas INTEGER[3],
	descricao VARCHAR(128),
	conectividade VARCHAR(32),
	iluminacao CHAR(5),
	contatoAgua BOOLEAN,
	fonteAlimentacao VARCHAR(32),
	CONSTRAINT pk_pontoInstalacao
		PRIMARY KEY (cnpjParque, coordenadas),
	CONSTRAINT fk_pontoInstalacao
		FOREIGN KEY (cnpjParque)
		REFERENCES parque
		ON DELETE RESTRICT,
	CONSTRAINT ck_pontoInstalacao
		CHECK ( upper(iluminacao) IN ('ALTA', 'MEDIA', 'BAIXA') )
);

/* TABELA 31 */
CREATE TABLE pontoCamera (
	idCamera BIGINT,
	cnpjParque CHAR(18),
	coordenadas INTEGER[3],
	data DATE,
	quantidade INTEGER NOT NULL,
	CONSTRAINT pk_pontoCamera
		PRIMARY KEY (idCamera, cnpjParque, coordenadas, data),
	CONSTRAINT fk1_pontoCamera
		FOREIGN KEY (idCamera)
		REFERENCES camera
		ON DELETE RESTRICT,
	CONSTRAINT fk2_pontoCamera
		FOREIGN KEY (cnpjParque, coordenadas)
		REFERENCES pontoInstalacao
		ON DELETE RESTRICT
);

/* TABELA 32 */
CREATE TABLE pontoEstrutura (
	idEstruturacao BIGINT,
	cnpjParque CHAR(18),
	coordenadas INTEGER[3],
	data DATE,
	quantidade INTEGER NOT NULL,
	CONSTRAINT pk_pontoEstrutura
		PRIMARY KEY (idEstruturacao, cnpjParque, coordenadas, data),
	CONSTRAINT fk1_pontoEstrutura
		FOREIGN KEY (idEstruturacao)
		REFERENCES estruturacao
		ON DELETE RESTRICT,
	CONSTRAINT fk2_pontoEstrutura
		FOREIGN KEY (cnpjParque, coordenadas)
		REFERENCES pontoInstalacao
		ON DELETE RESTRICT
);

/* TABELA 33 */
CREATE TABLE pontoSom (
	idSonorizacao BIGINT,
	cnpjParque CHAR(18),
	coordenadas INTEGER[3],
	data DATE,
	quantidade INTEGER NOT NULL,
	numeroGrafo INTEGER,
	CONSTRAINT fk1_pontoSom
		FOREIGN KEY (idSonorizacao)
		REFERENCES sonorizacao
		ON DELETE RESTRICT,
	CONSTRAINT fk2_pontoSom
		FOREIGN KEY (cnpjParque, coordenadas)
		REFERENCES pontoInstalacao
		ON DELETE RESTRICT
);

/* TABELA 34 */
CREATE TABLE opera (
	cnpjParque CHAR(18),
	dataFesta DATE,
	cpfPiloto CHAR(14),
	idDrone BIGINT NOT NULL, /* No MR não é chave estrangeira!!!??? */
	CONSTRAINT pk_opera
		PRIMARY KEY (cnpjParque, dataFesta, cpfPiloto),
	CONSTRAINT fk1_opera
		FOREIGN KEY (cnpjParque, dataFesta)
		REFERENCES festaNoParque
		ON DELETE RESTRICT,
	CONSTRAINT fk2_opera
		FOREIGN KEY (cpfPiloto)
		REFERENCES piloto
		ON DELETE RESTRICT
);

/* TABELA 35 */
CREATE TABLE auxilia (
	cnpjParque CHAR(18),
	dataFesta DATE,
	cpfPiloto CHAR(14),
	cpfCopiloto CHAR(14) NOT NULL,
	CONSTRAINT pk_auxilia
		PRIMARY KEY (cnpjParque, dataFesta, cpfPiloto),
	CONSTRAINT un_auxilia
		UNIQUE (cpfCopiloto),
	CONSTRAINT fk1_auxilia
		FOREIGN KEY (cnpjParque, dataFesta)
		REFERENCES festaNoParque
		ON DELETE RESTRICT,
	CONSTRAINT fk2_auxilia
		FOREIGN KEY (cpfPiloto)
		REFERENCES piloto
		ON DELETE RESTRICT,
	CONSTRAINT fk3_auxilia
		FOREIGN KEY (cpfCopiloto)
		REFERENCES copiloto
		ON DELETE RESTRICT
);

/* TABELA 36 */
CREATE TABLE manutencao (
	cpfTecnico CHAR(14),
	idEquipamento BIGINT,
	data DATE,
	CONSTRAINT pk_manutencao
		PRIMARY KEY (cpfTecnico, idEquipamento, data),
	CONSTRAINT fk1_manutencao
		FOREIGN KEY (cpfTecnico)
		REFERENCES tecnico
		ON DELETE RESTRICT,
	CONSTRAINT fk2_manutencao
		FOREIGN KEY (idEquipamento)
		REFERENCES equipamento
		ON DELETE RESTRICT
);


/* For debugging currently */
END TRANSACTION;
