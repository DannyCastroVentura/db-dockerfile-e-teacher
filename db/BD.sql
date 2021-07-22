/*create database finalProject;*/

ALTER SYSTEM SET max_connections TO '100000';

show max_connections;

drop table if exists logsAdmin;
drop table if exists admin;
drop table if exists trabalhosAlunos;
drop table if exists professorDisciplinas;
drop table if exists Orientacoes;
drop table if exists recursosDigitais;
drop table if exists ProjetosInvestigacao;
drop table if exists professoresAlunos;
drop table if exists trabalhos;
drop table if exists professores;
drop table if exists areas;
drop table if exists alunos;
drop table if exists disciplinas;
drop table if exists instituicao;


create table if not exists areas(
    idArea serial primary key not null,
    nome varchar(50) not null,
    cor varchar(7) not null
);

create table if not exists professores(
    email varchar(50) primary key not null,
    password varchar(100) not null,
    nome varchar(50) not null,
    estado boolean DEFAULT false,
    fotoPerfil varchar(1000),
    fotoFundo varchar(1000),
    resumo varchar(1000),
    exp integer DEFAULT 0,
    idArea integer,
    FOREIGN key (idArea) REFERENCES areas (idArea) ON UPDATE CASCADE
);

create table if not exists recursosDigitais(
    id serial primary key not null,
    descricao varchar(100) not null,
    url varchar(1000) not null,
    email varchar(50) not null,
    FOREIGN key (email) REFERENCES professores (email) ON DELETE CASCADE ON UPDATE CASCADE
);

create table if not exists admin(
    email varchar(50) primary key not null,
    password varchar(100) not null,
    nome varchar(50) not null
);

create table if not exists logsAdmin(
    idLog serial primary key not null,
    tipoDeAlteracao varchar(10) not null,
    tabela varchar(30) not null,
    idRegisto varchar(50) not null,
    estadoFinal varchar(500),
    email varchar(50) not null,
    dateTime TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP + INTERVAL '1' HOUR,
    FOREIGN key (email) REFERENCES admin (email) ON DELETE CASCADE ON UPDATE CASCADE
);
create table if not exists alunos(
    email varchar(50) primary key not null,
    password varchar(100) not null,
    nome varchar(50) not null,
    numeroDeAluno integer not null unique,
    estado boolean DEFAULT false
);

create table if not exists disciplinas(
    idDisciplinas serial primary key not null,
    sigla varchar(10) not null,
    nome varchar(50) not null
);

create table if not exists instituicao(
    idInstituicao serial primary key not null,
    sigla varchar(10) unique not null,
    nome varchar(50) not null
);

create table if not exists professorDisciplinas(
    id serial primary key not null,
    email varchar(50) not null,
    idDisciplinas integer not null,
    estadoDisciplina boolean DEFAULT true,
    idInstituicao integer not null,
    semestre integer not null,
    FOREIGN key (email) REFERENCES professores (email) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN key (idDisciplinas) REFERENCES disciplinas (idDisciplinas) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (idInstituicao) REFERENCES instituicao (idInstituicao) ON DELETE CASCADE ON UPDATE CASCADE
);

create table if not exists professoresAlunos(
    professorEmail varchar(50) not null,
    alunoEmail varchar(50) not null,
    PRIMARY KEY (professorEmail, alunoEmail),
    FOREIGN key (professorEmail) REFERENCES professores (email) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN key (alunoEmail) REFERENCES alunos (email) ON DELETE CASCADE ON UPDATE CASCADE
);

create table if not exists trabalhos(
    /*criado quando o trabalho é criado*/
    idTrabalho varchar(15) primary key not null,
    nome varchar(50) not null,
    professorEmail varchar(50) not null,
    /*apenas os alunos alteram isto*/
    imagem varchar(1000),
    resumo varchar(1000) not null,
    ano integer not null,
    relatorio varchar(1000),
    codigo varchar(1000),
    informacao varchar(100),
    /*apenas os profs alteram isto*/
    nota numeric(4,2),
    versao2 boolean DEFAULT false,
    FOREIGN key (professorEmail) REFERENCES professores (email) ON DELETE CASCADE ON UPDATE CASCADE
);

create table if not exists trabalhosAlunos(
    idTrabalho varchar(15) not null,
    alunoEmail varchar(50) not null,
    PRIMARY KEY (idTrabalho, alunoEmail),
    FOREIGN key (idTrabalho) REFERENCES trabalhos (idTrabalho) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN key (alunoEmail) REFERENCES alunos (email) ON DELETE CASCADE ON UPDATE CASCADE
);

create table if not exists Orientacoes(
    id serial primary key not null,
    email varchar(50) not null,
    nomeCurso varchar(100) not null,
    tema varchar(100) not null,
    relatorio varchar(1000) not null,
    link varchar(1000) not null,
    titulo boolean not null, /*t para mestrado, f para doutoramento*/
    alunoEmail varchar(50) not null,
    dataInicio integer not null,
    dataFim integer,
    idInstituicao integer not null,
    FOREIGN key (email) REFERENCES professores (email) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN key (alunoEmail) REFERENCES alunos (email) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (idInstituicao) REFERENCES instituicao (idInstituicao) ON DELETE CASCADE ON UPDATE CASCADE
);

create table if not exists ProjetosInvestigacao(
    id serial primary key not null,
    email varchar(50) not null,
    titulo varchar(100) not null,
    sigla varchar(20) not null,
    investigadorPrincipal varchar(50) not null,
    financiador varchar(50) not null,
    dataInicio integer not null,
    dataFim integer DEFAULT 0,
    imagem varchar(1000),
    link varchar(1000),
    resumo varchar(1000),
    FOREIGN key (email) REFERENCES professores (email) ON DELETE CASCADE ON UPDATE CASCADE
);

insert into areas (idArea, nome, cor) VALUES (0, '', '#0d6efd');
insert into areas (nome, cor) VALUES ('Artificial intelligence', '#073fb8');
insert into areas (nome, cor) VALUES ('Data base', '#cdaa7d');
insert into areas (nome, cor) VALUES ('Networks', '#a75d67');
insert into areas (nome, cor) VALUES ('Cloud computing', '#9f4347');
insert into areas (nome, cor) VALUES ('Web development', '#67f20f');
insert into areas (nome, cor) VALUES ('Distributed systems', '#bfd9d7');

insert into professores (email, password, nome, estado, idArea) VALUES ('dannyventura@gmail.com', '123', 'Daniel Castro Ventura', true, 1);
insert into professores (email, password, nome, estado, idArea, fotoPerfil, fotoFundo, resumo, exp) VALUES ('exemploDeProfessor@gmail.com', '321', 'Exemplo', true, 2, 'https://i.pinimg.com/originals/4e/45/88/4e458893b1fdc033508016e09fa5553c.jpg', 'https://wakke.co/wp-content/uploads/2019/01/267114-o-que-e-educacao-40-e-como-ela-vai-mudar-o-modo-como-se-aprende-1.jpg', 'Professor de bases de dados. Faço e fiz parte de trabalhos de pesquisa e tenho alguns trabalhos de alunos realizados! Navega no meu perfil para saberes mais!', 2014);

insert into alunos (email, password, nome, estado, numeroDeAluno) VALUES ('rodrigoGomes@gmail.com', '432', 'Rodrigo Gomes', true, 30002639);
insert into alunos (email, password, nome, estado, numeroDeAluno) VALUES ('goncaloDinis@gmail.com', '434', 'Gonçalo Dinis', true, 30002640);
insert into alunos (email, password, nome, estado, numeroDeAluno) VALUES ('tacadas@gmail.com', '424', 'Ricardo Almeida', true, 30002841);
insert into alunos (email, password, nome, estado, numeroDeAluno) VALUES ('estiloso@gmail.com', '414', 'Marcelo Santos', true, 30003628);
insert into alunos (email, password, nome, estado, numeroDeAluno) VALUES ('exemplo1@gmail.com', '434', 'exemplo', true, 3000);

insert into instituicao (sigla, nome) VALUES ('UAL', 'Universidade Autónoma de Lisboa');
insert into instituicao (sigla, nome) VALUES ('FCT', 'Faculdade de Ciências e Tecnologia');

insert into disciplinas (sigla, nome) VALUES ('MBD', 'Modelação de base de dados');
insert into disciplinas (sigla, nome) VALUES ('SDP', 'Sistemas Distribuidos e Paralelos');
insert into disciplinas (sigla, nome) VALUES ('DWEB', 'Desenvolvimento Web');

insert into professorDisciplinas (email, idDisciplinas, idInstituicao, semestre) VALUES ('dannyventura@gmail.com', 1, 1, 1);
insert into professorDisciplinas (email, idDisciplinas, idInstituicao, semestre) VALUES ('dannyventura@gmail.com', 2, 1, 2);

insert into professorDisciplinas (email, idDisciplinas, idInstituicao, semestre) VALUES ('exemploDeProfessor@gmail.com', 1, 1, 1);
insert into professorDisciplinas (email, idDisciplinas, idInstituicao, semestre) VALUES ('exemploDeProfessor@gmail.com', 2, 1, 2);
insert into professorDisciplinas (email, idDisciplinas, idInstituicao, semestre) VALUES ('exemploDeProfessor@gmail.com', 1, 2, 1);
insert into professorDisciplinas (email, idDisciplinas, idInstituicao, semestre, estadoDisciplina) VALUES ('exemploDeProfessor@gmail.com', 2, 2, 2, false);
insert into professorDisciplinas (email, idDisciplinas, idInstituicao, semestre, estadoDisciplina) VALUES ('exemploDeProfessor@gmail.com', 3, 2, 1, false);


insert into professoresAlunos (professorEmail, alunoEmail) VALUES ('dannyventura@gmail.com', 'rodrigoGomes@gmail.com');
insert into professoresAlunos (professorEmail, alunoEmail) VALUES ('dannyventura@gmail.com', 'goncaloDinis@gmail.com');


insert into professoresAlunos (professorEmail, alunoEmail) VALUES ('exemploDeProfessor@gmail.com', 'goncaloDinis@gmail.com');
insert into professoresAlunos (professorEmail, alunoEmail) VALUES ('exemploDeProfessor@gmail.com', 'estiloso@gmail.com');


insert into trabalhos (idtrabalho, nome, professorEmail, ano, resumo) values ('idTrab1', 'Android', 'dannyventura@gmail.com', 2021, 'Resumo do android');

insert into trabalhos (idtrabalho, nome, professorEmail, ano, resumo) VALUES ('idTrab2', 'Cloud management', 'exemploDeProfessor@gmail.com', 2018, 'Resumo de cloud management');
insert into trabalhos (idtrabalho, nome, professorEmail, ano, resumo) VALUES ('idTrab3', 'Inteligencia artificial', 'exemploDeProfessor@gmail.com', 2021, 'Robô que estaciona carros sozinho! Vamos tirar o trabalho a quem já não o tem!');

insert into trabalhosAlunos (idTrabalho, alunoEmail) VALUES ('idTrab2', 'goncaloDinis@gmail.com');
insert into trabalhosAlunos (idTrabalho, alunoEmail) VALUES ('idTrab3', 'estiloso@gmail.com');

insert into ProjetosInvestigacao (email, titulo, sigla, investigadorPrincipal, financiador, dataInicio) VALUES ('dannyventura@gmail.com', 'exemplo de pj', 'EPJ', 'exemploDeInvestigadorPrincipal', 'exemploDeFinanciador', 2001);

insert into ProjetosInvestigacao (email, titulo, sigla, investigadorPrincipal, financiador, dataInicio) VALUES ('exemploDeProfessor@gmail.com', 'exemplo de projeto de pesquisa', 'EPJ', 'exemploDeInvestigadorPrincipal', 'exemploDeFinanciador', 2001);
insert into ProjetosInvestigacao (email, titulo, sigla, investigadorPrincipal, financiador, dataInicio, dataFim) VALUES ('exemploDeProfessor@gmail.com', 'Telecomunicações Aérias', 'TA', 'TAP', 'TAP', 2016, 2020);

insert into Orientacoes (email, nomeCurso, tema, relatorio, link, titulo, alunoEmail, dataInicio, dataFim, idInstituicao)  VALUES ('dannyventura@gmail.com', 'Criador de conteúdos Digitais', 'Instagram', 'relatorio', 'link', true, 'rodrigoGomes@gmail.com', 1999, 2004, 2 );

insert into Orientacoes (email, nomeCurso, tema, relatorio, link, titulo, alunoEmail, dataInicio, dataFim, idInstituicao)  VALUES ('exemploDeProfessor@gmail.com', 'Criador de conteúdos Digitais', 'Instagram', 'relatorio', 'link', true, 'estiloso@gmail.com', 1999, 2004, 2 );
insert into Orientacoes (email, nomeCurso, tema, relatorio, link, titulo, alunoEmail, dataInicio, idInstituicao)  VALUES ('exemploDeProfessor@gmail.com', 'Web developement', 'E-Teacher', 'relatorio', 'link', false, 'goncaloDinis@gmail.com', 2005, 2 );

insert into trabalhosAlunos (idTrabalho, alunoEmail) VALUES ('idTrab1', 'rodrigoGomes@gmail.com');
insert into trabalhosAlunos (idTrabalho, alunoEmail) VALUES ('idTrab1', 'goncaloDinis@gmail.com');

insert into recursosDigitais (descricao, url, email) VALUES ('Orcid', 'https://orcid.org/0000-0002-6424-0252', 'exemploDeProfessor@gmail.com');

insert into admin (email, password, nome) VALUES ('teste@teste', '$2b$12$HUCgGTg8nxyAwn3oC9/9B.dlMUz.N6K5fnz8Z3BnzREpwes91iwbC', 'teste');

insert into logsadmin (tipoDeAlteracao, tabela, idRegisto, estadoFinal, email) VALUES ('1', '2', '3', '4', 'teste@teste');

update professorDisciplinas set estadoDisciplina = 'f' where id = 10;


select * from professores;
select * from alunos;
select * from areas;
select * from trabalhos;
select * from professoresAlunos;
select * from disciplinas;
select * from professorDisciplinas;
select * from ProjetosInvestigacao;
select * from instituicao;
select * from Orientacoes;
select * from admin;
select * from logsadmin;
