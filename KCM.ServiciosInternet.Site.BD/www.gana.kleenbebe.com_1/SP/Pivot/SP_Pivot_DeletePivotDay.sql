USE [www.gana.kleenbebe.com_1]
GO
/****** Object:  StoredProcedure [dbo].[SP_Winners_UpdateTickets]    Script Date: 05/10/2021 06:00:29 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Eng. Jorge Flores Miguel    jorgekain00@gmail.com
-- Create date: September 2021
-- Description:	Delete PivotDay table
-- =============================================
ALTER PROCEDURE [dbo].[SP_Pivot_DeletePivotDay]
	@Id int
	AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Msg nvarchar(200) = '';

	BEGIN TRAN;
    
	BEGIN TRY  
		
		-- Look for an existings games
		SELECT  @Msg = 'Este registro no se puede borrar por que tiene juegos asociados.'
		FROM [dbo].PivotDay pvt
		INNER JOIN(
			SELECT TOP(1) g.PivotDayId
			FROM dbo.vwGame g
			WHERE g.PivotDayId = @Id
		)B ON B.PivotDayId = pvt.Id;
		
		-- get the id value for the new row
		
		IF @Msg = ''
			BEGIN
				DELETE FROM dbo.PivotDay WHERE Id = @Id;
			END;
		COMMIT;
	END TRY  
	BEGIN CATCH  
		ROLLBACK;
		THROW;
	END CATCH  
	SELECT @Msg [Msg];
END