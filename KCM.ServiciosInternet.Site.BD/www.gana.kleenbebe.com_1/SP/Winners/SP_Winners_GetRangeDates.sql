USE [www.gana.kleenbebe.com_1]
GO
/****** Object:  StoredProcedure [dbo].[SP_Winners_GetRangeDates]    Script Date: 01/10/2021 06:08:27 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
