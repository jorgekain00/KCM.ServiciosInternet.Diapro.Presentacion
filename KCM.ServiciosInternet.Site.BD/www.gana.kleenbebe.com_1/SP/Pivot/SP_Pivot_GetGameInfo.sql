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
-- Description:	Get game Info
-- =============================================
CREATE PROCEDURE [dbo].[SP_Pivot_GetGameInfo]
	AS
BEGIN
	SET NOCOUNT ON;
	   
	BEGIN TRY  
		
		SELECT i.IdGameinfo Id , i.[Description] 
		FROM dbo.GameInfo i
	
	END TRY  
	BEGIN CATCH  
		THROW;
	END CATCH  
END