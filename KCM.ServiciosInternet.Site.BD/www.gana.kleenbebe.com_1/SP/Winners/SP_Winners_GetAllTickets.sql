USE [www.gana.kleenbebe.com_1]
GO
/****** Object:  StoredProcedure [dbo].[SP_Winners_GetAllTickets]    Script Date: 01/10/2021 06:05:52 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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