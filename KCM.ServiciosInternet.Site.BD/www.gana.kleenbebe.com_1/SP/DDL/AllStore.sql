USE [www.gana.kleenbebe.com_1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Eng. Jorge Flores Miguel    jorgekain00@gmail.com
-- Create date: August 2021
-- Description:	getAttemps from pending games (dbo.Game_0)
-- =============================================
ALTER PROCEDURE [dbo].[SP_GetAttemps]
	@UID nvarchar(40)				-- User ID
	AS
BEGIN
	DECLARE @Attemps INT = 0;

	SET NOCOUNT ON;
	    
	BEGIN TRY  
		SELECT @Attemps = COUNT(*)
			FROM dbo.Ticket TK
				INNER JOIN [dbo].[vwGame] vG ON vG.IdTicket = TK.IdTicket
		WHERE vG.[PivotDayId] = 0		--get rows from game_0  (pending games)
			AND TK.[UID] = @UID;
		
		SELECT @Attemps;
	END TRY  
	BEGIN CATCH  
		THROW;
	END CATCH  
END
GO
-- =============================================
-- Author:		Eng. Jorge Flores Miguel    jorgekain00@gmail.com
-- Create date: August 2021
-- Description:	get the current avalaible game (route for the mvc controller)
-- =============================================
ALTER PROCEDURE [dbo].[SP_GetGameInfo]
	@todayDt DATETIME
	AS
BEGIN
	SET NOCOUNT ON;

    BEGIN TRY  
		SELECT TOP(1) gi.[Path]
			FROM [dbo].[PivotDay] pvt
				INNER JOIN [dbo].[GameInfo] gi on gi.IdGameinfo = pvt.IdGameinfo
		WHERE @todayDt < pvt.PivotDate
			AND pvt.IsProcessed = 0
		ORDER BY pvt.PivotDate ASC;			
	END TRY  
	BEGIN CATCH  
		THROW;
	END CATCH  
END
GO
-- =============================================
-- Author:		Eng. Jorge Flores Miguel    jorgekain00@gmail.com
-- Create date: August 2021
-- Description:	get the current avalaible game params from dbo.Params
-- =============================================
ALTER PROCEDURE [dbo].[SP_GetParamsFromGame]
	@IdGameinfo INT
	AS
BEGIN
	DECLARE @JsonParams nvarchar(max) = null;   -- the params are in JSON format
	
	SET NOCOUNT ON;

	BEGIN TRY  
		SELECT @JsonParams = p.[Value]
		FROM [dbo].[GameInfo] g INNER JOIN [dbo].[Params] p on p.Id = g.IdParam
		WHERE g.IdGameinfo = @IdGameinfo

		SELECT Word
		FROM OpenJson(@JsonParams)
			WITH (Word nvarchar(max) '$.word' AS JSON);			--the params are processed by the client
	END TRY  
	BEGIN CATCH  
		THROW
	END CATCH  
	
END
GO
-- =============================================
-- Author:		Eng. Jorge Flores Miguel    jorgekain00@gmail.com
-- Create date: August 2021
-- Description:	get the score
-- Remark A table Game_n exist for each pivotDay
-- =============================================
ALTER PROCEDURE [dbo].[SP_GetScore]
	@UID nvarchar(40),  -- user(gamer)
	@TodayDate Datetime
	AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY  
		SELECT vg.[GameDate], gi.[Description], vg.[Time]
			FROM (SELECT TOP(1) pvt.[Id], pvt.[IdGameinfo] FROM [dbo].[PivotDay] pvt WHERE @TodayDate < pvt.PivotDate AND pvt.IsProcessed = 0 ORDER BY PivotDate ASC) pt
				INNER JOIN [dbo].[vwGame] vg ON vg.PivotDayId =  pt.Id
				INNER JOIN [dbo].[GameInfo] gi ON gi.IdGameinfo = pt.IdGameinfo
				INNER JOIN [dbo].[Ticket] tk on tk.IdTicket = vg.IdTicket
		WHERE tk.[UID] = @UID
			AND vg.[Time] IS NOT NULL
		ORDER BY vg.[Time],vg.[GameDate]
	END TRY  
	BEGIN CATCH  
		THROW
	END CATCH  
END
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
GO
USE [www.gana.kleenbebe.com_1]
GO
-- =============================================
-- Author:		Eng. Jorge Flores Miguel    jorgekain00@gmail.com
-- Create date: August 2021
-- Description:	save the game
-- =============================================
ALTER PROCEDURE [dbo].[SP_UpdateSaveGame]
	@PivotDayId INT,
	@IdGame bigint,
	@EndGameDt DATETIME,
	@Time nchar(15)
	AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY  
		UPDATE [dbo].vwGame
			SET [EndDate] = @EndGameDt,
				[Time] = @Time
		WHERE [PivotDayId] = @PivotDayId AND [Id] = @IdGame;
	END TRY  
	BEGIN CATCH  
		THROW
	END CATCH  
END
GO
-- =============================================
-- Author:		Eng. Jorge Flores Miguel    jorgekain00@gmail.com
-- Create date: August 2021
-- Description:	set game  (subtract 1 attemp to the game)
-- =============================================
ALTER PROCEDURE [dbo].[SP_UpdateSetGame]
	@UID nvarchar(40),   --USERID
	@todayDt DATETIME	 
	AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @GameTbl TABLE(
		PivotDayId INT,
		GameId bigint,
		IdGameInfo int
	);

	BEGIN TRY  
		-- Get the row to update
		INSERT INTO @GameTbl (
			PivotDayId
			,GameId
			,IdGameInfo
		)
		SELECT TOP(1) pt.Id  [PivotDayId]
					,vg.Id [GameId]
					,pt.IdGameInfo
				FROM [dbo].[Ticket] tk
				INNER JOIN [dbo].[vwGame] vg ON vg.IdTicket = tk.IdTicket,
				(SELECT TOP(1) pvt.[Id], pvt.[IdGameinfo] FROM [dbo].PivotDay pvt WHERE @todayDt < pvt.PivotDate AND pvt.IsProcessed = 0 ORDER BY pvt.PivotDate ASC	) pt
			WHERE tk.[UID] = @UID     
				AND vg.PivotDayId = 0;		-- get the pending games from game_0
		--update the row
		UPDATE A
			SET A.PivotDayId = B.[PivotDayId],
				A.IdGameInfo = B.IdGameinfo,
				A.GameDate = GETDATE()
		FROM [dbo].[vwGame] A
			INNER JOIN @GameTbl B ON A.PivotDayId = 0 AND A.Id = B.GameId;
		--Retrieve the new values
		SELECT PivotDayId,GameId,IdGameInfo FROM  @GameTbl;
	END TRY  
	BEGIN CATCH  
		THROW;
	END CATCH  
END
GO
-- =============================================
-- Author:		Eng. Jorge Flores Miguel    jorgekain00@gmail.com
-- Create date: August 2021
-- Description:	Get All Tickets from a specific @PivotDayId
-- =============================================
ALTER PROCEDURE [dbo].[SP_Winners_GetAllTickets]
   @PivotDayId int		
	AS
BEGIN
	SET NOCOUNT ON;
    
	BEGIN TRY  
		SELECT vw.[PivotDayId]
			  ,vw.[IdTicket]
			  ,vw.[GameDescription]
			  ,CONVERT(nvarchar(19), vw.[TicketDate], 25) [TicketDate]
			  ,vw.[TicketAmount]
			  ,CONVERT(nvarchar(12), vw.[BestTime], 114) [BestTime]
			  ,vw.[Product]
			  ,vw.[ProductSize]
			  ,vw.[TicketAttempts]
			  ,vw.[TicketPath]
			  ,vw.[CompetitorUID]
			  ,vw.[CompetitorFirstName]
			  ,vw.[CompetitorLastName]
			  ,vw.[CompetitorEmail]
			  ,vw.[CompetitorBirthDay]
			  ,vw.[CompetitorPhone]
			  ,vw.[BestTimeIdTicket]
			  ,vw.[IsValid]
			  ,vw.[IsWinner]
		  FROM [dbo].[vwTicketByPivotDay] vw
		WHERE vw.[PivotDayId] = @PivotDayId;
	END TRY  
	BEGIN CATCH  
		THROW;
	END CATCH  
END
GO
-- =============================================
-- Author:		Eng. Jorge Flores Miguel    jorgekain00@gmail.com
-- Create date: September 2021
-- Description:	Get Games
-- =============================================
ALTER PROCEDURE [dbo].[SP_Winners_GetGamesByTicket]
   @IdTicket nvarchar(40),
   @PivotDayId int
	AS
BEGIN
	SET NOCOUNT ON;
    
	BEGIN TRY  
		SELECT ROW_NUMBER() OVER(ORDER BY VG.Id) [numberGame]
				,CONVERT(nvarchar(19), VG.[GameDate], 25) [GameDate]
				,CONVERT(nvarchar(12), VG.[Time], 114) [Time]
		FROM [dbo].[vwGame] VG
		WHERE VG.PivotDayId = @PivotDayId
			AND VG.IdTicket = @IdTicket
		ORDER BY VG.Id
	END TRY  
	BEGIN CATCH  
		THROW
	END CATCH  
END
GO
-- =============================================
-- Author:		Eng. Jorge Flores Miguel    jorgekain00@gmail.com
-- Create date: August 2021
-- Description:	Get Range Dates for the query
-- =============================================
ALTER PROCEDURE [dbo].[SP_Winners_GetRangeDates]
	@todayDate DATETIME
	AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY  
		SELECT  
			pvt.Id
			,CONVERT(CHAR(10),DATEADD(DD, (pvt.[Days] * -1),pvt.PivotDate),20) [initialDate] 
			,CONVERT(CHAR(10),DATEADD(DD,-1,pvt.PivotDate),20) [endDate]
			,pvt.IsProcessed				-- flag that indicates that range was processed, ie, the winners were selected
			FROM [dbo].PivotDay pvt
			WHERE pvt.Id >  0    -- zero is for a initialization date
			  AND pvt.PivotDate <= @todayDate
			ORDER BY pvt.Id;
	END TRY  
	BEGIN CATCH  
		THROW
	END CATCH  
END
GO
-- =============================================
-- Author:		Eng. Jorge Flores Miguel    jorgekain00@gmail.com
-- Create date: August 2021
-- Description:	Get Tickets from a specific @PivotDayId
-- =============================================
ALTER PROCEDURE [dbo].[SP_Winners_GetTickets]
   @NumberOfTickets int,			-- number of tickets to read
   @BestTimeIdTicket nvarchar(80),	-- unique id for the best time-ticket
   @PivotDayId int		
	AS
BEGIN
	SET NOCOUNT ON;
    
	BEGIN TRY  
		SELECT vw.[PivotDayId]
			  ,vw.[IdTicket]
			  ,vw.[GameDescription]
			  ,CONVERT(nvarchar(19), vw.[TicketDate], 25) [TicketDate]
			  ,vw.[TicketAmount]
			  ,CONVERT(nvarchar(12), vw.[BestTime], 114) [BestTime]
			  ,vw.[Product]
			  ,vw.[ProductSize]
			  ,vw.[TicketAttempts]
			  ,vw.[TicketPath]
			  ,vw.[CompetitorUID]
			  ,vw.[CompetitorFirstName]
			  ,vw.[CompetitorLastName]
			  ,vw.[CompetitorEmail]
			  ,vw.[CompetitorBirthDay]
			  ,vw.[CompetitorPhone]
			  ,vw.[BestTimeIdTicket]
			  ,vw.[IsValid]
			  ,vw.[IsWinner]
		  FROM [dbo].[vwTicketByPivotDay] vw
		WHERE vw.[PivotDayId] = @PivotDayId
			AND vw.[BestTimeIdTicket] > @BestTimeIdTicket 
		ORDER BY vw.[BestTimeIdTicket], vw.[IsWinner] DESC
		OFFSET 0 ROWS 
		FETCH NEXT @NumberOfTickets ROWS ONLY;
	END TRY  
	BEGIN CATCH  
		THROW;
	END CATCH  
END
GO
-- =============================================
-- Author:		Eng. Jorge Flores Miguel    jorgekain00@gmail.com
-- Create date: August 2021
-- Description:	Get user records
-- =============================================
ALTER PROCEDURE [dbo].[SP_Winners_GetUserRecords]
   @UID nvarchar(40)		
	AS
BEGIN
	SET NOCOUNT ON;
    
	BEGIN TRY  
		SELECT vw.[PivotDayId]
			  ,vw.[IdTicket]
			  ,vw.[GameDescription]
			  ,vw.[TicketDate]
			  ,vw.[TicketAmount]
			  ,vw.[BestTime]
			  ,vw.[Product]
			  ,vw.[ProductSize]
			  ,vw.[TicketAttempts]
			  ,vw.[TicketPath]
			  ,vw.[CompetitorUID]
			  ,vw.[CompetitorFirstName]
			  ,vw.[CompetitorLastName]
			  ,vw.[CompetitorEmail]
			  ,vw.[CompetitorBirthDay]
			  ,vw.[CompetitorPhone]
			  ,vw.[BestTimeIdTicket]
			  ,vw.[IsValid]
			  ,vw.[IsWinner]
			  ,ROW_NUMBER() OVER(PARTITION BY vw.PivotDayId, vw.IdTicket ORDER BY vg.Id) [numberGame]
			  ,VG.[GameDate]
			  ,VG.[Time]
		  FROM [dbo].[vwTicketByPivotDay] vw
			INNER JOIN [dbo].vwGame vg ON vg.PivotDayId = vw.PivotDayId AND vg.IdTicket = vw.IdTicket
		WHERE vw.CompetitorUID = @UID
		ORDER BY vw.PivotDayId, vw.IdTicket
	END TRY  
	BEGIN CATCH  
		THROW;
	END CATCH  
END
GO
-- =============================================
-- Author:		Eng. Jorge Flores Miguel    jorgekain00@gmail.com
-- Create date: September 2021
-- Description:	Lock Pivot Day
-- =============================================
ALTER PROCEDURE [dbo].[SP_Winners_UpdateLockPivotDay]
   @PivotDayId int
	AS
BEGIN
	SET NOCOUNT ON;
	 
    BEGIN TRY  
		BEGIN TRAN;
		DECLARE @msgVc nvarchar(120) = '';
					
		IF EXISTS(SELECT TOP(1) 1
					FROM [dbo].PivotDay pt 
						INNER JOIN [dbo].[vwTicketByPivotDay] TP ON TP.PivotDayId = pt.Id
					WHERE pt.Id = @PivotDayId
						AND pt.IsProcessed = 0
						AND TP.[IsWinner] = 1
		)
			BEGIN
				UPDATE [dbo].[PivotDay]
					SET IsProcessed = 1
				WHERE [Id] = @PivotDayId;
			END
		ELSE
			BEGIN
				SET @msgVc = 'No hay ganadores seleccionados';
			END
		COMMIT
	END TRY  
	BEGIN CATCH  
		ROLLBACK;
		THROW;
	END CATCH  
	SELECT @msgVc;	
END
GO
-- =============================================
-- Author:		Eng. Jorge Flores Miguel    jorgekain00@gmail.com
-- Create date: August 2021
-- Description:	Update TicketByPivotDay_1, TicketByPivotDay_2,... TicketByPivotDay_N depending of @PivotDayId
-- =============================================
ALTER PROCEDURE [dbo].[SP_Winners_UpdateTicketByPivotDay]
  @PivotDayId int
	AS
BEGIN
	BEGIN TRAN
	SET NOCOUNT ON;
    DECLARE @rowCount int  = 0;
	BEGIN TRY  
		INSERT INTO [dbo].[vwTicketByPivotDay](
				[PivotDayId]
			  ,[IdTicket]
			  ,[GameDescription]
			  ,[TicketDate]
			  ,[TicketAmount]
			  ,[BestTime]
			  ,[Product]
			  ,[ProductSize]
			  ,[TicketAttempts]
			  ,[TicketPath]
			  ,[CompetitorUID]
			  ,[CompetitorFirstName]
			  ,[CompetitorLastName]
			  ,[CompetitorEmail]
			  ,[CompetitorBirthDay]
			  ,[CompetitorPhone]
			  ,[BestTimeIdTicket]
			  ,[IsValid]
			  ,[IsWinner]
		)
		SELECT 
				VG.PivotDayId		[PivotDayId]
				,TK.IdTicket
				,GI.[Description]	[GameDescription]
				,TK.CreationDate	[TicketDate]
				,TK.Amount			[TicketAmount]
				,MIN(VG.[Time])     [BestTime] 
				,PD.SKU				[Product]
				,SZ.[Description]	[ProductSize]
				,TK.Attempts		[TicketAttempts]
				,TK.UrlPhoto		[TicketPath]
				,CT.[UID]			[CompetitorUID]
				,CT.FirstName		[CompetitorFirstName]
				,CT.LastName		[CompetitorLastName]
				,CT.Email			[CompetitorEmail]
				,CONCAT(CAST(CT.BirthYear AS CHAR(4)),'-', RIGHT(REPLICATE('0',1) + CAST(CT.BirthMonth AS NVARCHAR(2)),2), '-',  RIGHT(REPLICATE('0',1) + CAST(CT.BirthDay AS  NVARCHAR(2)),2)) [CompetitorBirthDay]
				,CT.CellPhone		[CompetitorPhone]
				,CONCAT(MIN(VG.[Time]),TK.IdTicket) [BestTimeIdTicket]
				,0
				,0
			FROM [dbo].[vwGame] VG
				INNER JOIN [dbo].[Ticket] TK ON TK.IdTicket = VG.IdTicket
				INNER JOIN [dbo].[GameInfo] GI ON GI.IdGameinfo = VG.IdGameInfo
				INNER JOIN [dbo].[Product] PD ON PD.SKU = TK.SKU
				INNER JOIN [dbo].[Size] SZ ON SZ.IdSize = PD.idSize
				INNER JOIN [dbo].[Competitor] CT ON CT.[UID] = TK.[UID]
			WHERE VG.PivotDayId = @PivotDayId
				AND VG.[Time] IS NOT NULL									-- only finished games
			GROUP BY 
				VG.PivotDayId				
				,TK.IdTicket
				,GI.[Description]	
				,TK.CreationDate	
				,TK.Amount			
				,PD.SKU				
				,SZ.[Description]	
				,TK.Attempts		
				,TK.UrlPhoto		
				,CT.[UID]			
				,CT.FirstName		
				,CT.LastName		
				,CT.Email			
				,CONCAT(CAST(CT.BirthYear AS CHAR(4)),'-', RIGHT(REPLICATE('0',1) + CAST(CT.BirthMonth AS NVARCHAR(2)),2), '-',  RIGHT(REPLICATE('0',1) + CAST(CT.BirthDay AS  NVARCHAR(2)),2)) 
				,CT.CellPhone;		
			

			SELECT @rowCount = @@ROWCOUNT;
			COMMIT;

			SELECT @rowCount;
	END TRY  
	BEGIN CATCH  
		ROLLBACK;
		THROW;
	END CATCH  
END
GO
-- =============================================
-- Author:		Eng. Jorge Flores Miguel    jorgekain00@gmail.com
-- Create date: September 2021
-- Description:	UpdateTickects status
-- =============================================
ALTER PROCEDURE [dbo].[SP_Winners_UpdateTickets]
	@PivotDayId int,
	@JsonTickets nvarchar(max)
	AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRAN;
    
	BEGIN TRY  
		UPDATE TP
			SET TP.IsValid = JT.JisValid,
				TP.IsWinner = JT.JisWinner
		FROM [dbo].[vwTicketByPivotDay] TP
			INNER JOIN(
				SELECT Jticket, JisValid, JisWinner
				FROM OpenJson(@JsonTickets) 
					WITH (Jticket nvarchar(40) '$.ticket',
						JisValid bit '$.isValid',
						JisWinner bit '$.isWinner'
				)) JT ON JT.Jticket = TP.IdTicket
		WHERE TP.PivotDayId = @PivotDayId;
		COMMIT;
	END TRY  
	BEGIN CATCH  
		ROLLBACK;
		THROW;
	END CATCH  
END