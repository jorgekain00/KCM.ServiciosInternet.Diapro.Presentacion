USE [www.gana.kleenbebe.com_1]
GO
/****** Object:  StoredProcedure [dbo].[SP_Winners_GetTickets]    Script Date: 01/10/2021 06:13:05 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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