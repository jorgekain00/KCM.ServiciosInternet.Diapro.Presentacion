USE [www.gana.kleenbebe.com_1]
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertTicket]    Script Date: 01/10/2021 05:13:38 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Eng. Jorge Flores Miguel    jorgekain00@gmail.com
-- Create date: August 2021
-- Description:	add a ticket 
-- =============================================
ALTER PROCEDURE [dbo].[SP_InsertTicket]
	-- Add the parameters for the stored procedure here
	@productPrice decimal(8,2)			-- product Price
	,@productClave int					-- product SKU
	,@productTicket nchar(40)			-- Ticket
	,@UID nvarchar(40)					-- user id
	,@Path nvarchar(500)				-- Path for the ticket
	,@FirstName nvarchar(100)			-- user name
	,@LastName nvarchar(100)			-- user name
	,@Email  nvarchar(100)				-- user email
	,@BirthYear int						-- user birthYear
	,@BirthMonth int					-- user birthMonth
	,@BirthDay int						-- user birthDay
	,@CellPhone  nvarchar(20)			-- user cellphone
	,@todayDt datetime					-- today
	AS
BEGIN
	DECLARE @msgErr NVARCHAR(500) = '',					-- error message
			@JSONPROMO nvarchar(max) = NULL,			-- read the params to calculate attemps
			@IdSize INT = NULL,							-- Size of the product
			@Attemps INT = NULL,						-- computed attemps
			@CounterGames int = 0;						-- Number of games

	-- Work Table to computed the attemps
	DECLARE @PROMOtbl TABLE (							
		InferiorAmout decimal(8,2),			--amount ticket
		SuperiorAmount decimal(8,2),
		Attemp INT,							--initial number of attemp by amount
		ExtraAttemp INT,					-- extra attemp by Size Of the product
		Size INT,							-- Size of the product
		CalculatedAttemp INT NULL		-- final computed attemps
	);

	SET NOCOUNT ON;

	BEGIN TRY  
		-----------------------------
		-- DUPLICATED TICKET
		-----------------------------
		IF	EXISTS(SELECT 1 FROM [dbo].[Ticket] WHERE [IdTicket] = @productTicket)
			BEGIN
				SET @msgErr = 'Este ticket ya fue registrado';
				GOTO FAIL_VALIDATION;
			END;
		-----------------------------
		-- PRODUCT VALIDATION
		-----------------------------
		-- GET THE PRODUCT
		SELECT @IdSize = idSize FROM [dbo].[Product] WHERE SKU = @productClave;
		IF @IdSize IS NULL
			BEGIN
				SET @msgErr = 'No existe la clave del producto';
				GOTO FAIL_VALIDATION;
			END;
		-----------------------------
		-- COMPUTE THE ATTEMPS
		-----------------------------
		-- GET THE PARAMS TO COMPUTE THE ATTEMPS
		SELECT @JSONPROMO = [Value] from dbo.Params p INNER JOIN 
		(SELECT TOP(1) pvt.IdParam FROM dbo.PivotDay pvt WHERE @todayDt < pvt.PivotDate AND pvt.IsProcessed = 0
		ORDER BY pvt.PivotDate ASC) pt on pt.IdParam = p.Id;

		IF  @JSONPROMO IS NULL
			BEGIN
				SET @msgErr = 'No existe los parámetros para calcular los intentos';
				GOTO FAIL_VALIDATION;
			END;
		
		-- GET THE PARAM TABLE WITH THE RULES FOR ATTEMPS ASSIGNMENT
		INSERT INTO @PROMOtbl
		SELECT	InferiorAmout 
				,SuperiorAmount
				,Attemp
				,ExtraAttemp
				,Size
				,NULL [CalculatedAttemp]
		FROM OpenJson(@JSONPROMO)
			WITH (InferiorAmout decimal(8,2) '$.InferiorAmout',
				SuperiorAmount decimal(8,2) '$.SuperiorAmount',
				Attemp INT '$.Attemp',
				ExtraAttemp INT '$.ExtraAttemp',
				Size INT '$.Size'
			);
		-- COMPUTE ATTEMPS
		UPDATE @PROMOtbl
			SET CalculatedAttemp = Attemp + (ExtraAttemp * (CASE WHEN Size = @IdSize THEN 1 ELSE 0 END))
		WHERE @productPrice BETWEEN InferiorAmout AND SuperiorAmount;
		-- GET THE FINAL ATTEMPS
		SELECT @Attemps = MAX(CalculatedAttemp) FROM @PROMOtbl; 

		IF(@Attemps IS NULL OR @Attemps = 0)
			BEGIN
				SET @msgErr = 'El monto no es válido para entrar en la promoción';
				GOTO FAIL_VALIDATION;
			END
		-----------------------------
		-- UPDATE TABLES 
		-----------------------------
		BEGIN TRAN 
		-- UPDATE COMPETITOR
		MERGE [dbo].[Competitor] tgt USING (
				SELECT 
					@UID			[UID]
					,@FirstName		[FirstName]
					,@LastName		[LastName]
					,@Email			[Email]
					,@BirthYear		[BirthYear]
					,@BirthMonth	[BirthMonth]
					,@BirthDay		[BirthDay]
					,@CellPhone		[CellPhone]
			) src
		ON tgt.[UID] = src.[UID]
		WHEN MATCHED
			THEN UPDATE SET FirstName = src.[FirstName],
							LastName  = src.[LastName],
							Email     = src.[Email],
							BirthYear = src.[BirthYear],
							BirthMonth = src.[BirthMonth],
							BirthDay   = src.[BirthDay],
							CellPhone  = src.[CellPhone]
		WHEN NOT MATCHED
			THEN INSERT(
				[UID]
				,[FirstName]
				,[LastName]
				,[Email]
				,[BirthYear]
				,[BirthMonth]
				,[BirthDay]
				,[CellPhone]
			)
			VALUES(
				@UID		
				,@FirstName
				,@LastName	
				,@Email		
				,@BirthYear
				,@BirthMonth
				,@BirthDay	
				,@CellPhone
			);

		-- ADD TICKET
		INSERT INTO [dbo].[Ticket]
		(
			[IdTicket]
			,[UID]
			,[Amount]
			,[SKU]
			,[UrlPhoto]
			,[Attempts]
		)
		VALUES (
			@productTicket
			,@UID 
			,@productPrice
			,@productClave
			,@Path
			,@Attemps
		);
		--GENERATE THE GAMES BY NUMBER OF ATTEMPS
		SET @CounterGames = 0
		WHILE (@CounterGames <  @Attemps)
			BEGIN
				INSERT INTO [dbo].[vwGame](
					[PivotDayId]
					,[Id]
					,[IdGameInfo]
					,[GameDate]
					,[EndDate]
					,[Time]
					,[IdTicket]
					,[CreationDate]
				) 
				VALUES (
				0   -- dbo.Game_0
				,NEXT VALUE FOR dbo.Sec_GameNumber
				,NULL
				,NULL
				,NULL
				,NULL
				,@productTicket
				,GETDATE()
				);
				SET @CounterGames  = @CounterGames  + 1
			END
		COMMIT; 
	END TRY  
	BEGIN CATCH  
		ROLLBACK;
		THROW;
	END CATCH  

	FAIL_VALIDATION:
		SELECT @msgErr [msgErr]; 
END
