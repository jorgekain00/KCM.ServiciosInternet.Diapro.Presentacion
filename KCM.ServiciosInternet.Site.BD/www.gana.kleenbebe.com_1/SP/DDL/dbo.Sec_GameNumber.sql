-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 09/10/2021 22:09:50
-- Author: Eng. JORGE FLORES MIGUEL   jorge_kain@yahoo.com
-- Description:  Sequence for the game number
-- --------------------------------------------------
DROP SEQUENCE dbo.Sec_GameNumber;
GO
CREATE SEQUENCE dbo.Sec_GameNumber 
     AS BIGINT
     START WITH 0
     INCREMENT BY 1
     MINVALUE 0
     NO MAXVALUE
     NO CYCLE
     NO CACHE;

ALTER SEQUENCE dbo.Sec_GameNumber 
RESTART WITH 0;