USE [www.gana.kleenbebe.com_1]
GO
/****** Object:  StoredProcedure [dbo].[SP_Pivot_GetPivotDays]    Script Date: 06/10/2021 04:31:14 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Eng. Jorge Flores Miguel    jorgekain00@gmail.com
-- Create date: September 2021
-- Description:get pivotDay table
-- =============================================
ALTER PROCEDURE [dbo].[SP_Pivot_GetPivotDays]
   	AS
BEGIN
	SET NOCOUNT ON;
	 
	DECLARE @pivotTemp TABLE(
		[Id] int,
		[PivotDate] nvarchar(30),
		[IdGameinfo] int,
		[GameDescription] nvarchar(max),
		[Days] int,
		[IdParam] nchar(10), 
		[CreationDate] nvarchar(30),
		[IsProcessed] bit,
		[Closeby] nvarchar(200),
		[ClosebyDate] nvarchar(30),
		[IsLive] bit
	);

	DECLARE @PivotDayId int

    BEGIN TRY  
		INSERT INTO @pivotTemp
		SELECT [Id]
		  ,CONVERT(nvarchar(19), pvt.PivotDate, 25) [PivotDate]
		  ,pvt.IdGameinfo
		  ,gi.[Description]
		  ,[Days]
		  ,pvt.[IdParam]
		  ,CONVERT(nvarchar(19), pvt.[CreationDate], 25) [CreationDate]
		  ,[IsProcessed]
		  ,[Closeby]
		  ,CONVERT(nvarchar(19), pvt.[ClosebyDate], 25) [ClosebyDate]
		  ,0
		FROM [dbo].[PivotDay] pvt
		INNER JOIN dbo.GameInfo gi ON gi.IdGameinfo = pvt.IdGameinfo
		WHERE pvt.Id > 0;
		
	

	DECLARE PivotDays CURSOR FOR 
		SELECT [Id]
		FROM [dbo].[PivotDay] pvt;
		
	OPEN PivotDays

	FETCH NEXT FROM PivotDays INTO @PivotDayId

	WHILE @@fetch_status = 0

	BEGIN
		UPDATE A
			SET A.IsLive = IIF(B.PivotDayId IS NULL, 0,1)
		FROM @pivotTemp A
		INNER JOIN(
			SELECT TOP(1) g.PivotDayId
			FROM dbo.vwGame g
			WHERE g.PivotDayId = @PivotDayId
		)B ON B.PivotDayId = A.Id;

		FETCH NEXT FROM PivotDays INTO @PivotDayId
	END

	CLOSE PivotDays

	DEALLOCATE PivotDays

	SELECT
		[Id]
		,[PivotDate]
		,[IdGameinfo]
		,[GameDescription]
		,[Days]
		,[IdParam]
		,[CreationDate]
		,[IsProcessed]
		,[Closeby]
		,[ClosebyDate]
		,[IsLive]
	FROM @pivotTemp
		
	END TRY  
	BEGIN CATCH  
		THROW;
	END CATCH  
END