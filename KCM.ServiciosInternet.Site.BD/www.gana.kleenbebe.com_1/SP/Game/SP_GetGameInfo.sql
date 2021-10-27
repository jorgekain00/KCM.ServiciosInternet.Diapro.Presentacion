USE [www.gana.kleenbebe.com_1]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetGameInfo]    Script Date: 01/10/2021 05:05:13 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
