USE [www.gana.kleenbebe.com_1]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetScore]    Script Date: 01/10/2021 05:12:30 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
