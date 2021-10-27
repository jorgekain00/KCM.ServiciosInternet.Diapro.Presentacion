-- --------------------------------------------------
-- Date Created: 09/09/2021 
-- Author: Eng. JORGE FLORES MIGUEL   jorge_kain@yahoo.com
-- Description:  generate the transactions tables for the moderator
-- --------------------------------------------------

USE [www.gana.kleenbebe.com_1]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- --------------------------------------------------
-- Dropping existing indexes
-- --------------------------------------------------
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_TicketByPivotDay_1_BestTimeIdTicket' AND object_id = OBJECT_ID('[dbo].[TicketByPivotDay_1]')) DROP INDEX NIX_TicketByPivotDay_1_BestTimeIdTicket ON [dbo].[TicketByPivotDay_1];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_TicketByPivotDay_2_BestTimeIdTicket' AND object_id = OBJECT_ID('[dbo].[TicketByPivotDay_2]')) DROP INDEX NIX_TicketByPivotDay_2_BestTimeIdTicket ON [dbo].[TicketByPivotDay_2];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_TicketByPivotDay_3_BestTimeIdTicket' AND object_id = OBJECT_ID('[dbo].[TicketByPivotDay_3]')) DROP INDEX NIX_TicketByPivotDay_3_BestTimeIdTicket ON [dbo].[TicketByPivotDay_3];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_TicketByPivotDay_4_BestTimeIdTicket' AND object_id = OBJECT_ID('[dbo].[TicketByPivotDay_4]')) DROP INDEX NIX_TicketByPivotDay_4_BestTimeIdTicket ON [dbo].[TicketByPivotDay_4];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_TicketByPivotDay_5_BestTimeIdTicket' AND object_id = OBJECT_ID('[dbo].[TicketByPivotDay_5]')) DROP INDEX NIX_TicketByPivotDay_5_BestTimeIdTicket ON [dbo].[TicketByPivotDay_5];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_TicketByPivotDay_6_BestTimeIdTicket' AND object_id = OBJECT_ID('[dbo].[TicketByPivotDay_6]')) DROP INDEX NIX_TicketByPivotDay_6_BestTimeIdTicket ON [dbo].[TicketByPivotDay_6];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_TicketByPivotDay_7_BestTimeIdTicket' AND object_id = OBJECT_ID('[dbo].[TicketByPivotDay_7]')) DROP INDEX NIX_TicketByPivotDay_7_BestTimeIdTicket ON [dbo].[TicketByPivotDay_7];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_TicketByPivotDay_8_BestTimeIdTicket' AND object_id = OBJECT_ID('[dbo].[TicketByPivotDay_8]')) DROP INDEX NIX_TicketByPivotDay_8_BestTimeIdTicket ON [dbo].[TicketByPivotDay_8];  
GO

IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_TicketByPivotDay_1_CompetitorUID' AND object_id = OBJECT_ID('[dbo].[TicketByPivotDay_1]')) DROP INDEX NIX_TicketByPivotDay_1_CompetitorUID ON [dbo].[TicketByPivotDay_1];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_TicketByPivotDay_2_CompetitorUID' AND object_id = OBJECT_ID('[dbo].[TicketByPivotDay_2]')) DROP INDEX NIX_TicketByPivotDay_2_CompetitorUID ON [dbo].[TicketByPivotDay_2];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_TicketByPivotDay_3_CompetitorUID' AND object_id = OBJECT_ID('[dbo].[TicketByPivotDay_3]')) DROP INDEX NIX_TicketByPivotDay_3_CompetitorUID ON [dbo].[TicketByPivotDay_3];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_TicketByPivotDay_4_CompetitorUID' AND object_id = OBJECT_ID('[dbo].[TicketByPivotDay_4]')) DROP INDEX NIX_TicketByPivotDay_4_CompetitorUID ON [dbo].[TicketByPivotDay_4];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_TicketByPivotDay_5_CompetitorUID' AND object_id = OBJECT_ID('[dbo].[TicketByPivotDay_5]')) DROP INDEX NIX_TicketByPivotDay_5_CompetitorUID ON [dbo].[TicketByPivotDay_5];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_TicketByPivotDay_6_CompetitorUID' AND object_id = OBJECT_ID('[dbo].[TicketByPivotDay_6]')) DROP INDEX NIX_TicketByPivotDay_6_CompetitorUID ON [dbo].[TicketByPivotDay_6];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_TicketByPivotDay_7_CompetitorUID' AND object_id = OBJECT_ID('[dbo].[TicketByPivotDay_7]')) DROP INDEX NIX_TicketByPivotDay_7_CompetitorUID ON [dbo].[TicketByPivotDay_7];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_TicketByPivotDay_8_CompetitorUID' AND object_id = OBJECT_ID('[dbo].[TicketByPivotDay_8]')) DROP INDEX NIX_TicketByPivotDay_8_CompetitorUID ON [dbo].[TicketByPivotDay_8];  
GO

-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[TicketByPivotDay_1]') IS NOT NULL DROP TABLE [dbo].[TicketByPivotDay_1];
GO
IF OBJECT_ID(N'[dbo].[TicketByPivotDay_2]') IS NOT NULL DROP TABLE [dbo].[TicketByPivotDay_2];
GO
IF OBJECT_ID(N'[dbo].[TicketByPivotDay_3]') IS NOT NULL DROP TABLE [dbo].[TicketByPivotDay_3];
GO
IF OBJECT_ID(N'[dbo].[TicketByPivotDay_4]') IS NOT NULL DROP TABLE [dbo].[TicketByPivotDay_4];
GO
IF OBJECT_ID(N'[dbo].[TicketByPivotDay_5]') IS NOT NULL DROP TABLE [dbo].[TicketByPivotDay_5];
GO
IF OBJECT_ID(N'[dbo].[TicketByPivotDay_6]') IS NOT NULL DROP TABLE [dbo].[TicketByPivotDay_6];
GO
IF OBJECT_ID(N'[dbo].[TicketByPivotDay_7]') IS NOT NULL DROP TABLE [dbo].[TicketByPivotDay_7];
GO
IF OBJECT_ID(N'[dbo].[TicketByPivotDay_8]') IS NOT NULL DROP TABLE [dbo].[TicketByPivotDay_8];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

CREATE TABLE [dbo].[TicketByPivotDay_1](
	[PivotDayId] [int] NOT NULL,
	[IdTicket] [nvarchar](40) NOT NULL,
	[GameDescription] [nvarchar](max) NOT NULL,
	[TicketDate] [datetime] NOT NULL,
	[TicketAmount] [decimal](8, 2) NOT NULL,
	[BestTime] [time](7) NULL,
	[Product] [int] NOT NULL,
	[ProductSize] [nvarchar](max) NOT NULL,
	[TicketAttempts] [int] NOT NULL,
	[TicketPath] [nvarchar](max) NOT NULL,
	[CompetitorUID] [nvarchar](40) NOT NULL,
	[CompetitorFirstName] [nvarchar](100) NOT NULL,
	[CompetitorLastName] [nvarchar](100) NOT NULL,
	[CompetitorEmail] [nvarchar](150) NOT NULL,
	[CompetitorBirthDay] [nvarchar](10) NOT NULL,
	[CompetitorPhone] [nvarchar](20) NOT NULL,
	[BestTimeIdTicket] [nvarchar](80) NOT NULL,
	[IsValid] bit NOT NULL,
	[IsWinner] bit NOT NULL,
	[UpdatedBy] nvarchar(200) NULL,
	[LastUpdate] Datetime NULL
)
GO

CREATE TABLE [dbo].[TicketByPivotDay_2](
	[PivotDayId] [int] NOT NULL,
	[IdTicket] [nvarchar](40) NOT NULL,
	[GameDescription] [nvarchar](max) NOT NULL,
	[TicketDate] [datetime] NOT NULL,
	[TicketAmount] [decimal](8, 2) NOT NULL,
	[BestTime] [time](7) NULL,
	[Product] [int] NOT NULL,
	[ProductSize] [nvarchar](max) NOT NULL,
	[TicketAttempts] [int] NOT NULL,
	[TicketPath] [nvarchar](max) NOT NULL,
	[CompetitorUID] [nvarchar](40) NOT NULL,
	[CompetitorFirstName] [nvarchar](100) NOT NULL,
	[CompetitorLastName] [nvarchar](100) NOT NULL,
	[CompetitorEmail] [nvarchar](150) NOT NULL,
	[CompetitorBirthDay] [nvarchar](10) NOT NULL,
	[CompetitorPhone] [nvarchar](20) NOT NULL,
	[BestTimeIdTicket] [nvarchar](80) NOT NULL,
	[IsValid] bit NOT NULL,
	[IsWinner] bit NOT NULL,
	[UpdatedBy] nvarchar(200) NULL,
	[LastUpdate] Datetime NULL
)
GO

CREATE TABLE [dbo].[TicketByPivotDay_3](
	[PivotDayId] [int] NOT NULL,
	[IdTicket] [nvarchar](40) NOT NULL,
	[GameDescription] [nvarchar](max) NOT NULL,
	[TicketDate] [datetime] NOT NULL,
	[TicketAmount] [decimal](8, 2) NOT NULL,
	[BestTime] [time](7) NULL,
	[Product] [int] NOT NULL,
	[ProductSize] [nvarchar](max) NOT NULL,
	[TicketAttempts] [int] NOT NULL,
	[TicketPath] [nvarchar](max) NOT NULL,
	[CompetitorUID] [nvarchar](40) NOT NULL,
	[CompetitorFirstName] [nvarchar](100) NOT NULL,
	[CompetitorLastName] [nvarchar](100) NOT NULL,
	[CompetitorEmail] [nvarchar](150) NOT NULL,
	[CompetitorBirthDay] [nvarchar](10) NOT NULL,
	[CompetitorPhone] [nvarchar](20) NOT NULL,
	[BestTimeIdTicket] [nvarchar](80) NOT NULL,
	[IsValid] bit NOT NULL,
	[IsWinner] bit NOT NULL,
	[UpdatedBy] nvarchar(200) NULL,
	[LastUpdate] Datetime NULL
)
GO

CREATE TABLE [dbo].[TicketByPivotDay_4](
	[PivotDayId] [int] NOT NULL,
	[IdTicket] [nvarchar](40) NOT NULL,
	[GameDescription] [nvarchar](max) NOT NULL,
	[TicketDate] [datetime] NOT NULL,
	[TicketAmount] [decimal](8, 2) NOT NULL,
	[BestTime] [time](7) NULL,
	[Product] [int] NOT NULL,
	[ProductSize] [nvarchar](max) NOT NULL,
	[TicketAttempts] [int] NOT NULL,
	[TicketPath] [nvarchar](max) NOT NULL,
	[CompetitorUID] [nvarchar](40) NOT NULL,
	[CompetitorFirstName] [nvarchar](100) NOT NULL,
	[CompetitorLastName] [nvarchar](100) NOT NULL,
	[CompetitorEmail] [nvarchar](150) NOT NULL,
	[CompetitorBirthDay] [nvarchar](10) NOT NULL,
	[CompetitorPhone] [nvarchar](20) NOT NULL,
	[BestTimeIdTicket] [nvarchar](80) NOT NULL,
	[IsValid] bit NOT NULL,
	[IsWinner] bit NOT NULL,
	[UpdatedBy] nvarchar(200) NULL,
	[LastUpdate] Datetime NULL
)
GO

CREATE TABLE [dbo].[TicketByPivotDay_5](
	[PivotDayId] [int] NOT NULL,
	[IdTicket] [nvarchar](40) NOT NULL,
	[GameDescription] [nvarchar](max) NOT NULL,
	[TicketDate] [datetime] NOT NULL,
	[TicketAmount] [decimal](8, 2) NOT NULL,
	[BestTime] [time](7) NULL,
	[Product] [int] NOT NULL,
	[ProductSize] [nvarchar](max) NOT NULL,
	[TicketAttempts] [int] NOT NULL,
	[TicketPath] [nvarchar](max) NOT NULL,
	[CompetitorUID] [nvarchar](40) NOT NULL,
	[CompetitorFirstName] [nvarchar](100) NOT NULL,
	[CompetitorLastName] [nvarchar](100) NOT NULL,
	[CompetitorEmail] [nvarchar](150) NOT NULL,
	[CompetitorBirthDay] [nvarchar](10) NOT NULL,
	[CompetitorPhone] [nvarchar](20) NOT NULL,
	[BestTimeIdTicket] [nvarchar](80) NOT NULL,
	[IsValid] bit NOT NULL,
	[IsWinner] bit NOT NULL,
	[UpdatedBy] nvarchar(200) NULL,
	[LastUpdate] Datetime NULL
)
GO

CREATE TABLE [dbo].[TicketByPivotDay_6](
	[PivotDayId] [int] NOT NULL,
	[IdTicket] [nvarchar](40) NOT NULL,
	[GameDescription] [nvarchar](max) NOT NULL,
	[TicketDate] [datetime] NOT NULL,
	[TicketAmount] [decimal](8, 2) NOT NULL,
	[BestTime] [time](7) NULL,
	[Product] [int] NOT NULL,
	[ProductSize] [nvarchar](max) NOT NULL,
	[TicketAttempts] [int] NOT NULL,
	[TicketPath] [nvarchar](max) NOT NULL,
	[CompetitorUID] [nvarchar](40) NOT NULL,
	[CompetitorFirstName] [nvarchar](100) NOT NULL,
	[CompetitorLastName] [nvarchar](100) NOT NULL,
	[CompetitorEmail] [nvarchar](150) NOT NULL,
	[CompetitorBirthDay] [nvarchar](10) NOT NULL,
	[CompetitorPhone] [nvarchar](20) NOT NULL,
	[BestTimeIdTicket] [nvarchar](80) NOT NULL,
	[IsValid] bit NOT NULL,
	[IsWinner] bit NOT NULL,
	[UpdatedBy] nvarchar(200) NULL,
	[LastUpdate] Datetime NULL
)
GO

CREATE TABLE [dbo].[TicketByPivotDay_7](
	[PivotDayId] [int] NOT NULL,
	[IdTicket] [nvarchar](40) NOT NULL,
	[GameDescription] [nvarchar](max) NOT NULL,
	[TicketDate] [datetime] NOT NULL,
	[TicketAmount] [decimal](8, 2) NOT NULL,
	[BestTime] [time](7) NULL,
	[Product] [int] NOT NULL,
	[ProductSize] [nvarchar](max) NOT NULL,
	[TicketAttempts] [int] NOT NULL,
	[TicketPath] [nvarchar](max) NOT NULL,
	[CompetitorUID] [nvarchar](40) NOT NULL,
	[CompetitorFirstName] [nvarchar](100) NOT NULL,
	[CompetitorLastName] [nvarchar](100) NOT NULL,
	[CompetitorEmail] [nvarchar](150) NOT NULL,
	[CompetitorBirthDay] [nvarchar](10) NOT NULL,
	[CompetitorPhone] [nvarchar](20) NOT NULL,
	[BestTimeIdTicket] [nvarchar](80) NOT NULL,
	[IsValid] bit NOT NULL,
	[IsWinner] bit NOT NULL,
	[UpdatedBy] nvarchar(200) NULL,
	[LastUpdate] Datetime NULL
)
GO

CREATE TABLE [dbo].[TicketByPivotDay_8](
	[PivotDayId] [int] NOT NULL,
	[IdTicket] [nvarchar](40) NOT NULL,
	[GameDescription] [nvarchar](max) NOT NULL,
	[TicketDate] [datetime] NOT NULL,
	[TicketAmount] [decimal](8, 2) NOT NULL,
	[BestTime] [time](7) NULL,
	[Product] [int] NOT NULL,
	[ProductSize] [nvarchar](max) NOT NULL,
	[TicketAttempts] [int] NOT NULL,
	[TicketPath] [nvarchar](max) NOT NULL,
	[CompetitorUID] [nvarchar](40) NOT NULL,
	[CompetitorFirstName] [nvarchar](100) NOT NULL,
	[CompetitorLastName] [nvarchar](100) NOT NULL,
	[CompetitorEmail] [nvarchar](150) NOT NULL,
	[CompetitorBirthDay] [nvarchar](10) NOT NULL,
	[CompetitorPhone] [nvarchar](20) NOT NULL,
	[BestTimeIdTicket] [nvarchar](80) NOT NULL,
	[IsValid] bit NOT NULL,
	[IsWinner] bit NOT NULL,
	[UpdatedBy] nvarchar(200) NULL,
	[LastUpdate] Datetime NULL
)
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [PivotDayId],[IdTicket] in table 'TicketByPivotDay_1'
ALTER TABLE [dbo].[TicketByPivotDay_1]
ADD CONSTRAINT [PK_TicketByPivotDay_1_PivotDayId_IdTicket]
    PRIMARY KEY CLUSTERED ([PivotDayId],[IdTicket]);
GO

-- Creating primary key on [PivotDayId],[IdTicket] in table 'TicketByPivotDay_2'
ALTER TABLE [dbo].[TicketByPivotDay_2]
ADD CONSTRAINT [PK_TicketByPivotDay_2_PivotDayId_IdTicket]
    PRIMARY KEY CLUSTERED ([PivotDayId],[IdTicket]);
GO

-- Creating primary key on [PivotDayId],[IdTicket] in table 'TicketByPivotDay_3'
ALTER TABLE [dbo].[TicketByPivotDay_3]
ADD CONSTRAINT [PK_TicketByPivotDay_3_PivotDayId_IdTicket]
    PRIMARY KEY CLUSTERED ([PivotDayId],[IdTicket]);
GO

-- Creating primary key on [PivotDayId],[IdTicket] in table 'TicketByPivotDay_4'
ALTER TABLE [dbo].[TicketByPivotDay_4]
ADD CONSTRAINT [PK_TicketByPivotDay_4_PivotDayId_IdTicket]
    PRIMARY KEY CLUSTERED ([PivotDayId],[IdTicket]);
GO

-- Creating primary key on [PivotDayId],[IdTicket] in table 'TicketByPivotDay_5'
ALTER TABLE [dbo].[TicketByPivotDay_5]
ADD CONSTRAINT [PK_TicketByPivotDay_5_PivotDayId_IdTicket]
    PRIMARY KEY CLUSTERED ([PivotDayId],[IdTicket]);
GO

-- Creating primary key on [PivotDayId],[IdTicket] in table 'TicketByPivotDay_6'
ALTER TABLE [dbo].[TicketByPivotDay_6]
ADD CONSTRAINT [PK_TicketByPivotDay_6_PivotDayId_IdTicket]
    PRIMARY KEY CLUSTERED ([PivotDayId],[IdTicket]);
GO

-- Creating primary key on [PivotDayId],[IdTicket] in table 'TicketByPivotDay_7'
ALTER TABLE [dbo].[TicketByPivotDay_7]
ADD CONSTRAINT [PK_TicketByPivotDay_7_PivotDayId_IdTicket]
    PRIMARY KEY CLUSTERED ([PivotDayId],[IdTicket]);
GO

-- Creating primary key on [PivotDayId],[IdTicket] in table 'TicketByPivotDay_8'
ALTER TABLE [dbo].[TicketByPivotDay_8]
ADD CONSTRAINT [PK_TicketByPivotDay_8_PivotDayId_IdTicket]
    PRIMARY KEY CLUSTERED ([PivotDayId],[IdTicket]);
GO

-- --------------------------------------------------
-- Creating all CHECK constraints
-- --------------------------------------------------
-- Creating CHECK CONSTRAINT on [PivotDayId] in table 'TicketByPivotDay_1'
ALTER TABLE [dbo].[TicketByPivotDay_1]
ADD CONSTRAINT [CK_TicketByPivotDay_1_PivotDayId]
    CHECK ([PivotDayId] >= 1 AND PivotDayId < 2);
GO

-- Creating CHECK CONSTRAINT on [PivotDayId] in table 'TicketByPivotDay_2'
ALTER TABLE [dbo].[TicketByPivotDay_2]
ADD CONSTRAINT [CK_TicketByPivotDay_2_PivotDayId]
    CHECK ([PivotDayId] >= 2 AND PivotDayId < 3);
GO

-- Creating CHECK CONSTRAINT on [PivotDayId] in table 'TicketByPivotDay_3'
ALTER TABLE [dbo].[TicketByPivotDay_3]
ADD CONSTRAINT [CK_TicketByPivotDay_3_PivotDayId]
    CHECK ([PivotDayId] >= 3 AND PivotDayId < 4);
GO

-- Creating CHECK CONSTRAINT on [PivotDayId] in table 'TicketByPivotDay_4'
ALTER TABLE [dbo].[TicketByPivotDay_4]
ADD CONSTRAINT [CK_TicketByPivotDay_4_PivotDayId]
    CHECK ([PivotDayId] >= 4 AND PivotDayId < 5);
GO

-- Creating CHECK CONSTRAINT on [PivotDayId] in table 'TicketByPivotDay_5'
ALTER TABLE [dbo].[TicketByPivotDay_5]
ADD CONSTRAINT [CK_TicketByPivotDay_5_PivotDayId]
    CHECK ([PivotDayId] >= 5 AND PivotDayId < 6);
GO

-- Creating CHECK CONSTRAINT on [PivotDayId] in table 'TicketByPivotDay_6'
ALTER TABLE [dbo].[TicketByPivotDay_6]
ADD CONSTRAINT [CK_TicketByPivotDay_6_PivotDayId]
    CHECK ([PivotDayId] >= 6 AND PivotDayId < 7);
GO

-- Creating CHECK CONSTRAINT on [PivotDayId] in table 'TicketByPivotDay_7'
ALTER TABLE [dbo].[TicketByPivotDay_7]
ADD CONSTRAINT [CK_TicketByPivotDay_7_PivotDayId]
    CHECK ([PivotDayId] >= 7 AND PivotDayId < 8);
GO

-- Creating CHECK CONSTRAINT on [PivotDayId] in table 'TicketByPivotDay_8'
ALTER TABLE [dbo].[TicketByPivotDay_8]
ADD CONSTRAINT [CK_TicketByPivotDay_8_PivotDayId]
    CHECK ([PivotDayId] >= 8 AND PivotDayId < 9);
GO
-- --------------------------------------------------
-- Creating INDEXES
-- --------------------------------------------------

-- Creating INDEX on [BestTime] in table 'TicketByPivotDay_1'
CREATE NONCLUSTERED INDEX NIX_TicketByPivotDay_1_BestTimeIdTicket ON [dbo].[TicketByPivotDay_1]([BestTimeIdTicket] ASC);
GO																									    
																									    
-- Creating INDEX on [BestTime] in table 'TicketByPivotDay_2'										    
CREATE NONCLUSTERED INDEX NIX_TicketByPivotDay_2_BestTimeIdTicket ON [dbo].[TicketByPivotDay_2]([BestTimeIdTicket] ASC);
GO																									    
																									    
-- Creating INDEX on [BestTime] in table 'TicketByPivotDay_3'										    
CREATE NONCLUSTERED INDEX NIX_TicketByPivotDay_3_BestTimeIdTicket ON [dbo].[TicketByPivotDay_3]([BestTimeIdTicket] ASC);
GO																									    
																									    
-- Creating INDEX on [BestTime] in table 'TicketByPivotDay_4'										    
CREATE NONCLUSTERED INDEX NIX_TicketByPivotDay_4_BestTimeIdTicket ON [dbo].[TicketByPivotDay_4]([BestTimeIdTicket] ASC);
GO																									    
																									    
-- Creating INDEX on [BestTime] in table 'TicketByPivotDay_5'										    
CREATE NONCLUSTERED INDEX NIX_TicketByPivotDay_5_BestTimeIdTicket ON [dbo].[TicketByPivotDay_5]([BestTimeIdTicket] ASC);
GO																									    
																									    
-- Creating INDEX on [BestTime] in table 'TicketByPivotDay_6'										    
CREATE NONCLUSTERED INDEX NIX_TicketByPivotDay_6_BestTimeIdTicket ON [dbo].[TicketByPivotDay_6]([BestTimeIdTicket] ASC);
GO																									    
																									    
-- Creating INDEX on [BestTime] in table 'TicketByPivotDay_7'										    
CREATE NONCLUSTERED INDEX NIX_TicketByPivotDay_7_BestTimeIdTicket ON [dbo].[TicketByPivotDay_7]([BestTimeIdTicket] ASC);
GO																									    
																									    
-- Creating INDEX on [BestTime] in table 'TicketByPivotDay_8'										    
CREATE NONCLUSTERED INDEX NIX_TicketByPivotDay_8_BestTimeIdTicket ON [dbo].[TicketByPivotDay_8]([BestTimeIdTicket] ASC);
GO

-- Creating INDEX on [CompetitorUID] in table 'TicketByPivotDay_1'
CREATE NONCLUSTERED INDEX NIX_TicketByPivotDay_1_CompetitorUID ON [dbo].[TicketByPivotDay_1]([CompetitorUID] ASC);
GO		
-- Creating INDEX on [CompetitorUID] in table 'TicketByPivotDay_2'
CREATE NONCLUSTERED INDEX NIX_TicketByPivotDay_2_CompetitorUID ON [dbo].[TicketByPivotDay_2]([CompetitorUID] ASC);
GO		
-- Creating INDEX on [CompetitorUID] in table 'TicketByPivotDay_3'
CREATE NONCLUSTERED INDEX NIX_TicketByPivotDay_3_CompetitorUID ON [dbo].[TicketByPivotDay_3]([CompetitorUID] ASC);
GO		
-- Creating INDEX on [CompetitorUID] in table 'TicketByPivotDay_4'
CREATE NONCLUSTERED INDEX NIX_TicketByPivotDay_4_CompetitorUID ON [dbo].[TicketByPivotDay_4]([CompetitorUID] ASC);
GO		
-- Creating INDEX on [CompetitorUID] in table 'TicketByPivotDay_5'
CREATE NONCLUSTERED INDEX NIX_TicketByPivotDay_5_CompetitorUID ON [dbo].[TicketByPivotDay_5]([CompetitorUID] ASC);
GO		
-- Creating INDEX on [CompetitorUID] in table 'TicketByPivotDay_6'
CREATE NONCLUSTERED INDEX NIX_TicketByPivotDay_6_CompetitorUID ON [dbo].[TicketByPivotDay_6]([CompetitorUID] ASC);
GO		
-- Creating INDEX on [CompetitorUID] in table 'TicketByPivotDay_7'
CREATE NONCLUSTERED INDEX NIX_TicketByPivotDay_7_CompetitorUID ON [dbo].[TicketByPivotDay_7]([CompetitorUID] ASC);
GO		
-- Creating INDEX on [CompetitorUID] in table 'TicketByPivotDay_8'
CREATE NONCLUSTERED INDEX NIX_TicketByPivotDay_8_CompetitorUID ON [dbo].[TicketByPivotDay_8]([CompetitorUID] ASC);
GO		

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------

