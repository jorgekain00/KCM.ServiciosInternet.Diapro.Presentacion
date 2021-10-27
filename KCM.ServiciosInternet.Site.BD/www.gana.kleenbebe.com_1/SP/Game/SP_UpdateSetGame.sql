USE [www.gana.kleenbebe.com_1]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateSetGame]    Script Date: 01/10/2021 06:01:31 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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