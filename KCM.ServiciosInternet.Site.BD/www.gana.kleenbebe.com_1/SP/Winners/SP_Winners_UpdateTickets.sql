USE [www.gana.kleenbebe.com_1]
GO
/****** Object:  StoredProcedure [dbo].[SP_Winners_UpdateTickets]    Script Date: 08/10/2021 09:38:10 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Eng. Jorge Flores Miguel    jorgekain00@gmail.com
-- Create date: September 2021
-- Description:	UpdateTickects status
-- =============================================
ALTER PROCEDURE [dbo].[SP_Winners_UpdateTickets]
	@PivotDayId int,
	@JsonTickets nvarchar(max),
	@Email nvarchar(200)
	AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRAN;
    
	BEGIN TRY  
		UPDATE TP
			SET TP.IsValid = JT.JisValid,
				TP.IsWinner = JT.JisWinner,
				TP.UpdatedBy = @Email,
				TP.[LastUpdate] = GETDATE(),
				TP.[BestTimeIdTicket] = CONCAT(JT.JisValid^1,JT.JisWinner^1,BestTime,TP.IdTicket) 
		FROM [dbo].[vwTicketByPivotDay] TP
			INNER JOIN(
				SELECT Jticket, JisValid, JisWinner
				FROM OpenJson(@JsonTickets) 
					WITH (Jticket nvarchar(40) '$.ticket',
						JisValid bit '$.isValid',
						JisWinner bit '$.isWinner'
				)) JT ON JT.Jticket = TP.IdTicket
		WHERE TP.PivotDayId = @PivotDayId;
		COMMIT;
	END TRY  
	BEGIN CATCH  
		ROLLBACK;
		THROW;
	END CATCH  
END