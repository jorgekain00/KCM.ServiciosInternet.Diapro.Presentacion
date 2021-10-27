USE [www.gana.kleenbebe.com_1]
GO
/****** Object:  StoredProcedure [dbo].[SP_Winners_UpdateTicketByPivotDay]    Script Date: 08/10/2021 09:37:19 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Eng. Jorge Flores Miguel    jorgekain00@gmail.com
-- Create date: August 2021
-- Description:	Update TicketByPivotDay_1, TicketByPivotDay_2,... TicketByPivotDay_N depending of @PivotDayId
-- =============================================
ALTER PROCEDURE [dbo].[SP_Winners_UpdateTicketByPivotDay]
  @PivotDayId int
	AS
BEGIN
	BEGIN TRAN
	SET NOCOUNT ON;
    DECLARE @rowCount int  = 0;
	BEGIN TRY  
		INSERT INTO [dbo].[vwTicketByPivotDay](
				[PivotDayId]
			  ,[IdTicket]
			  ,[GameDescription]
			  ,[TicketDate]
			  ,[TicketAmount]
			  ,[BestTime]
			  ,[Product]
			  ,[ProductSize]
			  ,[TicketAttempts]
			  ,[TicketPath]
			  ,[CompetitorUID]
			  ,[CompetitorFirstName]
			  ,[CompetitorLastName]
			  ,[CompetitorEmail]
			  ,[CompetitorBirthDay]
			  ,[CompetitorPhone]
			  ,[BestTimeIdTicket]
			  ,[IsValid]
			  ,[IsWinner]
			  ,[UpdatedBy]
			  ,[LastUpdate]
		)
		SELECT 
				VG.PivotDayId		[PivotDayId]
				,TK.IdTicket
				,GI.[Description]	[GameDescription]
				,TK.CreationDate	[TicketDate]
				,TK.Amount			[TicketAmount]
				,MIN(VG.[Time])     [BestTime] 
				,PD.SKU				[Product]
				,SZ.[Description]	[ProductSize]
				,TK.Attempts		[TicketAttempts]
				,TK.UrlPhoto		[TicketPath]
				,CT.[UID]			[CompetitorUID]
				,CT.FirstName		[CompetitorFirstName]
				,CT.LastName		[CompetitorLastName]
				,CT.Email			[CompetitorEmail]
				,CONCAT(CAST(CT.BirthYear AS CHAR(4)),'-', RIGHT(REPLICATE('0',1) + CAST(CT.BirthMonth AS NVARCHAR(2)),2), '-',  RIGHT(REPLICATE('0',1) + CAST(CT.BirthDay AS  NVARCHAR(2)),2)) [CompetitorBirthDay]
				,CT.CellPhone		[CompetitorPhone]
				,CONCAT(1,1,MIN(VG.[Time]),TK.IdTicket) [BestTimeIdTicket]
				,0
				,0
				,NULL
				,NULL
			FROM [dbo].[vwGame] VG
				INNER JOIN [dbo].[Ticket] TK ON TK.IdTicket = VG.IdTicket
				INNER JOIN [dbo].[GameInfo] GI ON GI.IdGameinfo = VG.IdGameInfo
				INNER JOIN [dbo].[Product] PD ON PD.SKU = TK.SKU
				INNER JOIN [dbo].[Size] SZ ON SZ.IdSize = PD.idSize
				INNER JOIN [dbo].[Competitor] CT ON CT.[UID] = TK.[UID]
			WHERE VG.PivotDayId = @PivotDayId
				AND VG.[Time] IS NOT NULL									-- only finished games
			GROUP BY 
				VG.PivotDayId				
				,TK.IdTicket
				,GI.[Description]	
				,TK.CreationDate	
				,TK.Amount			
				,PD.SKU				
				,SZ.[Description]	
				,TK.Attempts		
				,TK.UrlPhoto		
				,CT.[UID]			
				,CT.FirstName		
				,CT.LastName		
				,CT.Email			
				,CONCAT(CAST(CT.BirthYear AS CHAR(4)),'-', RIGHT(REPLICATE('0',1) + CAST(CT.BirthMonth AS NVARCHAR(2)),2), '-',  RIGHT(REPLICATE('0',1) + CAST(CT.BirthDay AS  NVARCHAR(2)),2)) 
				,CT.CellPhone;		
			

			SELECT @rowCount = @@ROWCOUNT;
			COMMIT;

			SELECT @rowCount;
	END TRY  
	BEGIN CATCH  
		ROLLBACK;
		THROW;
	END CATCH  
END