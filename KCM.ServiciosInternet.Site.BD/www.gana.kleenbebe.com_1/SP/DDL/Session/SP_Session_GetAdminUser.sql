USE [www.gana.kleenbebe.com_1]
GO
/****** Object:  StoredProcedure [dbo].[SP_Pivot_GetGameInfo]    Script Date: 07/10/2021 09:47:17 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Eng. Jorge Flores Miguel    jorgekain00@gmail.com
-- Create date: September 2021
-- Description:	Get game Info
-- =============================================
ALTER PROCEDURE [dbo].[SP_Session_GetAdminUser]
	@Email nvarchar(200)
	AS
BEGIN
	SET NOCOUNT ON;
	   
	BEGIN TRY  
		
		SELECT 
			a.[Email]
			,a.[Password]
			,a.[isAdmin]
		FROM [dbo].[AdminUser] a
		WHERE a.[Email] = @Email;
	
	END TRY  
	BEGIN CATCH  
		THROW;
	END CATCH  
END