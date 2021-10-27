USE [www.gana.kleenbebe.com_1]
GO
/****** Object:  StoredProcedure [dbo].[SP_Winners_GetGamesByTicket]    Script Date: 01/10/2021 06:06:57 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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