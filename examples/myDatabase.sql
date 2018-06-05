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
        jobsDone INTEGER,
        CONSTRAINT pk_worker
                PRIMARY KEY (cpf),
        CONSTRAINT fk_worker
                FOREIGN KEY (cpf)
                REFERENCES person
                ON DELETE CASCADE
);

