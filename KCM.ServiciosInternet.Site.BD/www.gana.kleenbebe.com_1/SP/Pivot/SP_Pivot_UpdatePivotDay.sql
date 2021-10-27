USE [www.gana.kleenbebe.com_1]
GO
/****** Object:  StoredProcedure [dbo].[SP_Pivot_UpdatePivotDay]    Script Date: 07/10/2021 03:33:16 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Eng. Jorge Flores Miguel    jorgekain00@gmail.com
-- Create date: September 2021
-- Description:	UpdateTickects status
-- =============================================
ALTER PROCEDURE [dbo].[SP_Pivot_UpdatePivotDay]
	@Id int,
    @PivotDate nvarchar(25),
    @IdGameinfo int,
    @IsProcessed bit,
    @Days int,
	@IdParam nchar(10) 
	AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Msg nvarchar(200) = '';

	BEGIN TRAN;
    
	BEGIN TRY  
		
		-- overwrite the values if a previous row exists
		SELECT  @PivotDate = pvt.PivotDate
				,@IdGameinfo  = pvt.IdGameinfo
				,@Days = pvt.[Days]
				,@IdParam = pvt.IdParam
				,@Msg = 'Este registro tiene juegos. Sólo se actualiza la bandera de Cierre de corte'
		FROM [dbo].PivotDay pvt
		INNER JOIN(
			SELECT TOP(1) g.PivotDayId
			FROM dbo.vwGame g
			WHERE g.PivotDayId = @Id
		)B ON B.PivotDayId = pvt.Id;
		
		-- get the id value for the new row
		SELECT @Id = ISNULL(@Id, (SELECT (MAX(Id) + 1) FROM [dbo].[PivotDay]));


		-- insert or update
		MERGE [dbo].[PivotDay] tgt USING (
				SELECT 
					 @Id				[Id]
					,@PivotDate		[PivotDate]
					,@IdGameinfo	[IdGameinfo]
					,@IsProcessed	[IsProcessed]
					,@Days			[Days]
					,@IdParam		[IdParam]
			) src
		ON tgt.[Id] = src.[Id]
		WHEN MATCHED
			THEN UPDATE SET [PivotDate]	= ISNULL(src.[PivotDate],tgt.[PivotDate])
							,[IdGameinfo]	= ISNULL(src.[IdGameinfo],tgt.[IdGameinfo])	
							,[IsProcessed]	= src.[IsProcessed]
							,[Days]			= ISNULL(src.[Days],tgt.[Days])			
							,[IdParam]		= ISNULL(src.[IdParam],tgt.[IdParam])		
							
		WHEN NOT MATCHED
			THEN INSERT(
				[Id]
				,[PivotDate]
				,[IdGameinfo]
				,[IsProcessed]
				,[Days]
				,[IdParam]
				,[CreationDate]
				,[Closeby]
				,[ClosebyDate]
			)
			VALUES(
				src.[Id]		
				,src.[PivotDate]		
				,src.[IdGameinfo]	
				,src.[IsProcessed]	
				,src.[Days]			
				,src.[IdParam]
				,GETDATE()
				,NULL
				,NULL
			);

		COMMIT;
	END TRY  
	BEGIN CATCH  
		ROLLBACK;
		THROW;
	END CATCH  
	SELECT @Msg [Msg];
END