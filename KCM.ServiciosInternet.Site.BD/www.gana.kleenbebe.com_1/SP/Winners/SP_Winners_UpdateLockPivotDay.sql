USE [www.gana.kleenbebe.com_1]
GO
/****** Object:  StoredProcedure [dbo].[SP_Winners_UpdateLockPivotDay]    Script Date: 07/10/2021 12:16:34 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Eng. Jorge Flores Miguel    jorgekain00@gmail.com
-- Create date: September 2021
-- Description:	Lock Pivot Day
-- =============================================
ALTER PROCEDURE [dbo].[SP_Winners_UpdateLockPivotDay]
   @PivotDayId int,
   @Email nvarchar(200)
	AS
BEGIN
	SET NOCOUNT ON;
	 
    BEGIN TRY  
		BEGIN TRAN;
		DECLARE @msgVc nvarchar(120) = '';
					
		IF EXISTS(SELECT TOP(1) 1
					FROM [dbo].PivotDay pt 
						INNER JOIN [dbo].[vwTicketByPivotDay] TP ON TP.PivotDayId = pt.Id
					WHERE pt.Id = @PivotDayId
						AND pt.IsProcessed = 0
						AND TP.[IsWinner] = 1
		)
			BEGIN
				UPDATE [dbo].[PivotDay]
					SET IsProcessed = 1,
					Closeby = @Email,
					ClosebyDate = GETDATE()
				WHERE [Id] = @PivotDayId;
			END
		ELSE
			BEGIN
				SET @msgVc = 'No hay ganadores seleccionados';
			END
		COMMIT
	END TRY  
	BEGIN CATCH  
		ROLLBACK;
		THROW;
	END CATCH  
	SELECT @msgVc;	
END