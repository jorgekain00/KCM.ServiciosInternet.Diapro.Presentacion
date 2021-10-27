USE [www.gana.kleenbebe.com_1]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetAttemps]    Script Date: 01/10/2021 04:57:32 p. m. ******/
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