USE [www.gana.kleenbebe.com_1]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateSaveGame]    Script Date: 01/10/2021 05:41:10 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
