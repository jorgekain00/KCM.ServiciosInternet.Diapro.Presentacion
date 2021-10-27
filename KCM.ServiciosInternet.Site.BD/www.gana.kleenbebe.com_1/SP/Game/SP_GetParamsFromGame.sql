USE [www.gana.kleenbebe.com_1]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetParamsFromGame]    Script Date: 01/10/2021 05:10:20 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Eng. Jorge Flores Miguel    jorgekain00@gmail.com
-- Create date: August 2021
-- Description:	get the current avalaible game params from dbo.Params
-- =============================================
ALTER PROCEDURE [dbo].[SP_GetParamsFromGame]
	@IdGameinfo INT
	AS
BEGIN
	DECLARE @JsonParams nvarchar(max) = null;   -- the params are in JSON format
	
	SET NOCOUNT ON;

	BEGIN TRY  
		SELECT @JsonParams = p.[Value]
		FROM [dbo].[GameInfo] g INNER JOIN [dbo].[Params] p on p.Id = g.IdParam
		WHERE g.IdGameinfo = @IdGameinfo

		SELECT Word
		FROM OpenJson(@JsonParams)
			WITH (Word nvarchar(max) '$.word' AS JSON);			--the params are processed by the client
	END TRY  
	BEGIN CATCH  
		THROW
	END CATCH  
	
END
