/*CREATE DATABASE av01
GO
USE av01
GO

CREATE TABLE team(
	codigo INT NOT NULL IDENTITY,
	nome varchar(60) NOT NULL,
	cidade varchar(40) NOT NULL,
	estadio varchar(40) NOT NULL,
	PRIMARY KEY(codigo)
)
GO
CREATE TABLE random(
	codTeam INT NOT NULL UNIQUE,
	aleatorio INT UNIQUE,
	FOREIGN KEY(codTeam) REFERENCES team(codigo)
)
GO
CREATE TABLE grupoA(
	chave CHAR(1) CHECK(chave = 'A' OR chave = 'B' 
	OR chave = 'C' OR chave = 'D'),
	codTeam INT,
	FOREIGN KEY(codTeam) REFERENCES team(codigo),
	PRIMARY KEY(chave, codTeam)
)
GO
CREATE TABLE grupoB(
	chave CHAR(1) CHECK(chave = 'A' OR chave = 'B' 
	OR chave = 'C' OR chave = 'D'),
	codTeam INT,
	FOREIGN KEY(codTeam) REFERENCES team(codigo),
	PRIMARY KEY(chave, codTeam)
)
GO
CREATE TABLE grupoC(
	chave CHAR(1) CHECK(chave = 'A' OR chave = 'B' 
	OR chave = 'C' OR chave = 'D'),
	codTeam INT,
	FOREIGN KEY(codTeam) REFERENCES team(codigo),
	PRIMARY KEY(chave, codTeam)
)
GO
CREATE TABLE grupoD(
	chave CHAR(1) CHECK(chave = 'A' OR chave = 'B' 
	OR chave = 'C' OR chave = 'D'),
	codTeam INT,
	FOREIGN KEY(codTeam) REFERENCES team(codigo),
	PRIMARY KEY(chave, codTeam)
)
GO


CREATE TABLE jogos(
	numJogo INT UNIQUE IDENTITY,
	codTeamA INT NOT NULL,
	codTeamB INT NOT NULL,
	data_jogo DATE,
	FOREIGN KEY(codTeamA) REFERENCES team(codigo),
	FOREIGN KEY(codTeamB) REFERENCES team(codigo),
	PRIMARY KEY(codTeamA, codTeamB),
	CHECK(codTeamA != codTeamB),
	CHECK(grupoTeamA != grupoTeamB)
)


*/

--PROCEDURE JOGOS

/*	Estabelecer lógica
	temos 5 times por grupo e 4 grupos
	cada time terá 15 jogos resultando em 300 jogos
	Realizar o cadastro do times e dividir em grupos realizado
	Para os jogos de grupo será alterado a cada 50 jogos
	preciso estabelecer os grupos que irão jogar
*/
CREATE PROCEDURE sp_gerar_jogos(@saida VARCHAR(MAX) OUTPUT)
AS
	DECLARE @date DATE,
			@date_inicio DATE,
			@count INT,
			@i INT,
			@codTeamA INT,
			@codTeamB INT,
			@codTeamC INT,
			@codTeamD INT
	
	SET @count = 1
	SET @date_inicio = '2016-01-31'
	WHILE(@count < 15)
	BEGIN
		PRINT ('Comecei com: ')
		PRINT(@date_inicio)
		--SELECT GRUPO
		-- IF SELECT TIMES AND INSERT GAME
		IF(@count % 2 = 0)
		BEGIN
			SET @date=(select dateadd(day,4, @date_inicio))
			WHILE((SELECT MAX(numJogo) FROM jogos) < 6 )
			BEGIN
				BEGIN TRY
					IF(@count < 6)
					BEGIN
					/* PROBLEMA COMEÇA AQUI */
						SET @i = 1;
						--GRUPO A VS GRUPO B
						WHILE(@i < 6)
						BEGIN
							SET @codTeamA = (SELECT codTeam FROM grupo WHERE chave = 'A')
							SET @codTeamB = (SELECT codTeam FROM grupo WHERE chave = 'B')
							INSERT INTO jogos (codTeamA, codTeamB, grupoTeamA, grupoTeamB, data_jogo)  VALUES(@codTeamA, @codTeamB, 'A', 'B', @date)
							SET @i = @i + 1
						END
						--GRUPO C VS GRUPO D
						WHILE(@i > 5 AND @i < 11)
						BEGIN
							SET @codTeamC = (SELECT codTeam FROM grupo WHERE chave = 'C')
							SET @codTeamD = (SELECT codTeam FROM grupo WHERE chave = 'D')
							INSERT INTO jogos (codTeamA, codTeamB, grupoTeamA, grupoTeamB, data_jogo)  VALUES(1, 1, 'C', 'D', @date)
							SET @i = @i + 1
						END
					END 
					ELSE
					BEGIN
						IF(@count < 11)
						BEGIN
							SET @i = 1;
							--GRUPO A VS GRUPO C
							WHILE(@i < 6)
							BEGIN
								SET @codTeamA = (SELECT codTeam FROM grupo WHERE chave = 'A')
								SET @codTeamC = (SELECT codTeam FROM grupo WHERE chave = 'C')
								INSERT INTO jogos (codTeamA, codTeamB, grupoTeamA, grupoTeamB, data_jogo)  VALUES(@codTeamA, @codTeamC, 'A', 'C', @date)
								SET @i = @i + 1
							END
							--GRUPO B VS GRUPO D
							WHILE(@i > 5 AND @i < 11)
							BEGIN
								SET @codTeamB = (SELECT codTeam FROM grupo WHERE chave = 'B')
								SET @codTeamD = (SELECT codTeam FROM grupo WHERE chave = 'D')
								INSERT INTO jogos (codTeamA, codTeamB, grupoTeamA, grupoTeamB, data_jogo)  VALUES(@codTeamB, @codTeamD,  'B', 'D', @date)
								SET @i = @i + 1
							END
						END
				END TRY
				BEGIN CATCH
					PRINT ('ERRO AO ADICIONAR JOGO')	
				END CATCH 
			END 
		END
		-- IGNORAR POR ENQUANTO
		ELSE
		BEGIN
			SET @date=(select dateadd(day,3, @date_inicio))
			WHILE((SELECT MAX(numJogo) FROM jogos) < 6 )
			BEGIN
				BEGIN TRY
					IF(@count < 6)
					BEGIN
					/* PROBLEMA COMEÇA AQUI */
						SET @i = 1;
						--GRUPO A VS GRUPO C
						WHILE(@i < 6)
						BEGIN
							SET @codTeamA = (SELECT codTeam FROM grupo WHERE chave = 'A')
							SET @codTeamC = (SELECT codTeam FROM grupo WHERE chave = 'C')
							INSERT INTO jogos (codTeamA, codTeamC, grupoTeamA, grupoTeamC, data_jogo)  VALUES(@codTeamA, @codTeamB, 'A', 'B', @date)
							SET @i = @i + 1
						END
						--GRUPO B VS GRUPO D
						WHILE(@i > 5 AND @i < 11)
						BEGIN
							SET @codTeamB = (SELECT codTeam FROM grupo WHERE chave = 'B')
							SET @codTeamD = (SELECT codTeam FROM grupo WHERE chave = 'D')
							INSERT INTO jogos (codTeamB, codTeamD, grupoTeamA, grupoTeamB, data_jogo)  VALUES(1, 1, 'C', 'D', @date)
							SET @i = @i + 1
						END
					END 
					ELSE
					BEGIN
						IF(@count < 11)
						BEGIN
							SET @i = 1;
							--GRUPO A VS GRUPO C
							WHILE(@i < 6)
							BEGIN
								SET @codTeamA = (SELECT codTeam FROM grupo WHERE chave = 'A')
								SET @codTeamC = (SELECT codTeam FROM grupo WHERE chave = 'C')
								INSERT INTO jogos (codTeamA, codTeamB, grupoTeamA, grupoTeamB, data_jogo)  VALUES(@codTeamA, @codTeamC, 'A', 'C', @date)
								SET @i = @i + 1
							END
							--GRUPO B VS GRUPO D
							WHILE(@i > 5 AND @i < 11)
							BEGIN
								SET @codTeamB = (SELECT codTeam FROM grupo WHERE chave = 'B')
								SET @codTeamD = (SELECT codTeam FROM grupo WHERE chave = 'D')
								INSERT INTO jogos (codTeamA, codTeamB, grupoTeamA, grupoTeamB, data_jogo)  VALUES(@codTeamB, @codTeamD,  'B', 'D', @date)
								SET @i = @i + 1
							END
						END
				END TRY
				BEGIN CATCH
					PRINT ('ERRO AO ADICIONAR JOGO')	
				END CATCH
			END 
		END
		--
		SET @date_inicio = @date
		PRINT ('Terminei com: ')
		PRINT(@date_inicio)
		PRINT('')
		SET @count = @count + 1
	END



	
--PROCEDURE DE DIVIDIR TIMES

/*
CREATE PROCEDURE sp_insere_random(@saida VARCHAR(MAX) OUTPUT)
AS
	DECLARE @count INT,
			@codigo INT,
			@random INT

	INSERT INTO RANDOM (codTeam, aleatorio) VALUES(1, 1)
	INSERT INTO RANDOM (codTeam, aleatorio) VALUES(2, 2)
	INSERT INTO RANDOM (codTeam, aleatorio) VALUES(3, 3)
	INSERT INTO RANDOM (codTeam, aleatorio) VALUES(4, 4)

	SET @count = 5

	WHILE(@count < 21)
	BEGIN
		SET @codigo = @count
		SET @random = ((RAND()*20)+1)
		BEGIN TRY
			INSERT INTO RANDOM (codTeam, aleatorio) VALUES(@codigo, @random)
		END TRY
		BEGIN CATCH
			PRINT(@random)
		END CATCH
		IF((SELECT COUNT(codTeam) FROM random WHERE @codigo = codTeam) = 1)
		BEGIN
			SET @count = @count +1	
		END
		ELSE
		BEGIN
			PRINT('ERRO AO ADICIONAR')
			PRINT(@codigo)
		END
	END	
	SET @saida = 'Random Gerado com sucesso'

DECLARE @exit VARCHAR(MAX)

EXEC sp_insere_random @exit OUTPUT
PRINT(@exit)


select team.nome, random.aleatorio from random, team where codigo = codTeam

truncate table RANDOM
*/

--PROCEDURE DE GRUPOS
/*
CREATE PROCEDURE sp_gerar_grupos(@saida VARCHAR OUTPUT)
AS
	DECLARE @query VARCHAR(MAX),
			@count INT,
			@team INT

	SET @count = 5
	
	INSERT INTO grupo (chave, codTeam) VALUES('A', 1)
	INSERT INTO grupo (chave, codTeam) VALUES('B', 2)
	INSERT INTO grupo (chave, codTeam) VALUES('C', 3)
	INSERT INTO grupo (chave, codTeam) VALUES('D', 4)

	WHILE(@count < 21)
	BEGIN
		BEGIN TRY 
			IF(@count < 9)
			BEGIN
				SET @team = (SELECT codTeam FROM random WHERE @count = aleatorio)
				INSERT INTO grupo (chave, codTeam) VALUES('A', @team)
			END
			ELSE
			BEGIN
				IF(@count < 13)
				BEGIN
					SET @team = (SELECT codTeam FROM random WHERE @count = aleatorio)
					INSERT INTO grupo (chave, codTeam) VALUES('B', @team)
				END
				ELSE
				BEGIN
					IF(@count < 17)
					BEGIN
						SET @team = (SELECT codTeam FROM random WHERE @count = aleatorio)
						INSERT INTO grupo (chave, codTeam) VALUES('C', @team)
					END
					ELSE
					BEGIN
						IF(@count < 21)
						BEGIN
							SET @team = (SELECT codTeam FROM random WHERE @count = aleatorio)
							INSERT INTO grupo (chave, codTeam) VALUES('D', @team)
						END
					END
				END
			END
		END TRY
		BEGIN CATCH
			PRINT ('Valor')
		END CATCH
		SET @count = @count + 1 
	END
	
	SET @saida = 'Random Gerado com sucesso'
 

DECLARE @exit VARCHAR(MAX)

EXEC sp_gerar_grupos @exit OUTPUT
PRINT(@exit)

SELECT team.codigo, team.nome, grupo.chave FROM team, grupo WHERE grupo.codTeam = team.codigo
TRUNCATE table grupo
 */