/****** Script for SelectTopNRows command from SSMS  ******/
-- --------------------------------------------------
-- Date Created: 09/09/2021 
-- Author: Eng. JORGE FLORES MIGUEL   jorge_kain@yahoo.com
-- Description:  genarate dbo.vwGame
-- --------------------------------------------------
USE [www.gana.kleenbebe.com_1]
GO

DROP VIEW IF EXISTS dbo.vwGame; 
GO

CREATE VIEW dbo.vwGame
AS
SELECT [PivotDayId]
      ,[Id]
      ,[IdGameInfo]
      ,[GameDate]
      ,[EndDate]
      ,[Time]
      ,[IdTicket]
      ,[CreationDate]
  FROM [dbo].[Game_0]
UNION ALL
SELECT [PivotDayId]
      ,[Id]
      ,[IdGameInfo]
      ,[GameDate]
      ,[EndDate]
      ,[Time]
      ,[IdTicket]
      ,[CreationDate]
  FROM [dbo].[Game_1]
UNION ALL
SELECT [PivotDayId]
      ,[Id]
      ,[IdGameInfo]
      ,[GameDate]
      ,[EndDate]
      ,[Time]
      ,[IdTicket]
      ,[CreationDate]
  FROM [dbo].[Game_2]
  UNION ALL
SELECT [PivotDayId]
      ,[Id]
      ,[IdGameInfo]
      ,[GameDate]
      ,[EndDate]
      ,[Time]
      ,[IdTicket]
      ,[CreationDate]
  FROM [dbo].[Game_3]
UNION ALL
SELECT [PivotDayId]
      ,[Id]
      ,[IdGameInfo]
      ,[GameDate]
      ,[EndDate]
      ,[Time]
      ,[IdTicket]
      ,[CreationDate]
  FROM [dbo].[Game_4]
UNION ALL
SELECT [PivotDayId]
      ,[Id]
      ,[IdGameInfo]
      ,[GameDate]
      ,[EndDate]
      ,[Time]
      ,[IdTicket]
      ,[CreationDate]
  FROM [dbo].[Game_5]
UNION ALL
SELECT [PivotDayId]
      ,[Id]
      ,[IdGameInfo]
      ,[GameDate]
      ,[EndDate]
      ,[Time]
      ,[IdTicket]
      ,[CreationDate]
  FROM [dbo].[Game_6]
UNION ALL
SELECT [PivotDayId]
      ,[Id]
      ,[IdGameInfo]
      ,[GameDate]
      ,[EndDate]
      ,[Time]
      ,[IdTicket]
      ,[CreationDate]
  FROM [dbo].[Game_7]
UNION ALL
SELECT [PivotDayId]
      ,[Id]
      ,[IdGameInfo]
      ,[GameDate]
      ,[EndDate]
      ,[Time]
      ,[IdTicket]
      ,[CreationDate]
  FROM [dbo].[Game_8]