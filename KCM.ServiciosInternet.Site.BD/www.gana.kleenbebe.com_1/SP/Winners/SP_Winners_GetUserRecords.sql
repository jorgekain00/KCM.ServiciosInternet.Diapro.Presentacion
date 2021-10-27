USE [www.gana.kleenbebe.com_1]
GO
/****** Object:  StoredProcedure [dbo].[SP_Winners_GetUserRecords]    Script Date: 01/10/2021 06:15:13 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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