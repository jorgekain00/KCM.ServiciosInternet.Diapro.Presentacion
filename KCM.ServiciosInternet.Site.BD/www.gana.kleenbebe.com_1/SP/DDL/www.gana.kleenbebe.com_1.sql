
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 08/17/2021 22:09:50
-- Author: Eng. JORGE FLORES MIGUEL   jorge_kain@yahoo.com
-- Description:  generate the starup DB
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [www.gana.kleenbebe.com_1];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------
IF OBJECT_ID(N'dbo.FK_Product_Size_idSize', N'F') IS NOT NULL ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_Size_idSize];
GO
IF OBJECT_ID(N'dbo.FK_Ticket_Product_SKU', N'F') IS NOT NULL ALTER TABLE [dbo].[Ticket] DROP CONSTRAINT [FK_Ticket_Product_SKU];
GO
IF OBJECT_ID(N'dbo.FK_PivotDay_GameInfo_IdGameinfo', N'F') IS NOT NULL ALTER TABLE [dbo].[PivotDay] DROP CONSTRAINT [FK_PivotDay_GameInfo_IdGameinfo];
GO
IF OBJECT_ID(N'dbo.FK_PivotDay_Params_IdParam', N'F') IS NOT NULL ALTER TABLE [dbo].[PivotDay] DROP CONSTRAINT [FK_PivotDay_Params_IdParam];
GO
IF OBJECT_ID(N'dbo.FK_Gameinfo_Params_IdParam', N'F') IS NOT NULL ALTER TABLE [dbo].[Gameinfo] DROP CONSTRAINT [FK_Gameinfo_Params_IdParam];
GO
IF OBJECT_ID(N'dbo.FK_SiteMap_SiteMap_IdFather', N'F') IS NOT NULL ALTER TABLE [dbo].[SiteMap] DROP CONSTRAINT [FK_SiteMap_SiteMap_IdFather];
GO
IF OBJECT_ID(N'dbo.FK_Ticket_Competitor_UID', N'F') IS NOT NULL ALTER TABLE [dbo].[Ticket] DROP CONSTRAINT [FK_Ticket_Competitor_UID];
GO
-- --------------------------------------------------
-- Dropping existing INDEX
-- --------------------------------------------------
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_Ticket_UID' AND object_id = OBJECT_ID('[dbo].[Ticket]')) DROP INDEX NIX_Ticket_UID ON [dbo].[Ticket];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_PivotDay_PivotDate' AND object_id = OBJECT_ID('[dbo].[PivotDay]')) DROP INDEX NIX_PivotDay_PivotDate ON [dbo].[PivotDay];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_SiteMap_Path' AND object_id = OBJECT_ID('[dbo].[SiteMap]')) DROP INDEX NIX_SiteMap_Path ON [dbo].[SiteMap];  
GO
-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------
IF OBJECT_ID(N'[dbo].[Params]') IS NOT NULL DROP TABLE [dbo].Params;
GO
IF OBJECT_ID(N'[dbo].[SiteMap]') IS NOT NULL DROP TABLE [dbo].[SiteMap];
GO
IF OBJECT_ID(N'[dbo].[Size]') IS NOT NULL DROP TABLE [dbo].[Size];
GO
IF OBJECT_ID(N'[dbo].[Product]') IS NOT NULL DROP TABLE [dbo].[Product];
GO
IF OBJECT_ID(N'[dbo].[Ticket]') IS NOT NULL DROP TABLE [dbo].[Ticket];
GO
IF OBJECT_ID(N'[dbo].[GameInfo]') IS NOT NULL DROP TABLE [dbo].[GameInfo];
GO
IF OBJECT_ID(N'[dbo].[PivotDay]') IS NOT NULL DROP TABLE [dbo].[PivotDay];
GO
IF OBJECT_ID(N'[dbo].[Competitor]') IS NOT NULL DROP TABLE [dbo].[Competitor];
GO
IF OBJECT_ID(N'[dbo].[AdminUser]') IS NOT NULL DROP TABLE [dbo].[AdminUser];
GO
-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'Params'
CREATE TABLE [dbo].[Params] (
    [Id] nchar(10)  NOT NULL,
    [Description] nvarchar(max)  NOT NULL,
    [Value] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'SiteMap'
CREATE TABLE [dbo].[SiteMap] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Path] nvarchar(500)  NOT NULL,
    [Description] nvarchar(max)  NOT NULL,
    [IdFather] int  NULL,
    [IsAuthenticationNeeded] bit  NOT NULL,
	[IsDisplayNeeded] bit NOT NULL
);
GO

-- Creating table 'Size'
CREATE TABLE [dbo].[Size] (
    [IdSize] int IDENTITY(1,1) NOT NULL,
    [Description] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'Product'
CREATE TABLE [dbo].[Product] (
    [SKU] int NOT NULL,
    [Description] nvarchar(max)  NOT NULL,
    [Barcode] nvarchar(max)  NOT NULL,
    [Family] nvarchar(max)  NOT NULL,
    [idSize] int  NOT NULL
);
GO

-- Creating table 'Ticket'
CREATE TABLE [dbo].[Ticket] (
    [IdTicket] nvarchar(40)  NOT NULL,
    [UID] nvarchar(40)  NOT NULL,
    [Amount] decimal(8,2)  NOT NULL,
    [SKU] int  NOT NULL,
    [UrlPhoto] nvarchar(max)  NOT NULL,
    [Attempts] int  NOT NULL,
    [CreationDate] datetime DEFAULT GETDATE()  NOT NULL
);
GO

-- Creating table 'Competitor'
CREATE TABLE [dbo].[Competitor] (
    [UID] nvarchar(40)  NOT NULL,
    [FirstName] nvarchar(100)  NOT NULL,
    [LastName] nvarchar(100)  NOT NULL,
    [Email] nvarchar(150)  NOT NULL,
    [BirthYear] int  NOT NULL,
    [BirthMonth] int  NOT NULL,
    [BirthDay] int  NOT NULL,
    [CellPhone]  nvarchar(20)  NOT NULL,
    [CreationDate] datetime DEFAULT GETDATE()  NOT NULL
);
GO

-- Creating table 'GameInfo'
CREATE TABLE [dbo].[GameInfo] (
    [IdGameinfo] int IDENTITY(1,1) NOT NULL,
    [Description] nvarchar(max)  NOT NULL,
    [Path] nvarchar(max)  NOT NULL,
    [DevelopedBy] nvarchar(max)  NOT NULL,
	[IdParam] nchar(10) NOT NULL,
    [CreationDate] datetime DEFAULT GETDATE()  NOT NULL
);
GO

-- Creating table 'PivotDay'
CREATE TABLE [dbo].[PivotDay] (
    [Id] int NOT NULL,
    [PivotDate] datetime  NOT NULL,
    [IdGameinfo] int  NOT NULL,
    [IsProcessed] bit NOT NULL,
    [Days] int  NOT NULL,
	[IdParam] nchar(10) NOT NULL, 
	[Closeby] nvarchar(200) NULL,
	[ClosebyDate] Datetime NULL,
	[CreationDate] datetime DEFAULT GETDATE()  NOT NULL
);
GO

-- Optional table.
-- this table must be replaced by Microsoft Owin
CREATE TABLE [dbo].[AdminUser](
	[Email] nvarchar(200) NOT NULL
	,[Password] nvarchar(200) NOT NULL
	,[isAdmin] bit NOT NULL
);

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [Id] in table 'Params'
ALTER TABLE [dbo].[Params]
ADD CONSTRAINT [PK_Params_Id]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'SiteMap'
ALTER TABLE [dbo].[SiteMap]
ADD CONSTRAINT [PK_SiteMap_Id]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Size'
ALTER TABLE [dbo].[Size]
ADD CONSTRAINT [PK_Size_IdSize]
    PRIMARY KEY CLUSTERED ([IdSize] ASC);
GO

-- Creating primary key on [SKU] in table 'Product'
ALTER TABLE [dbo].[Product]
ADD CONSTRAINT [PK_Product_SKU]
    PRIMARY KEY CLUSTERED ([SKU] ASC);
GO

-- Creating primary key on [IdTicket] in table 'Ticket'
ALTER TABLE [dbo].[Ticket]
ADD CONSTRAINT [PK_Ticket_IdTicket]
    PRIMARY KEY CLUSTERED ([IdTicket] ASC);
GO

-- Creating primary key on [IdTicket] in table 'Competitor'
ALTER TABLE [dbo].Competitor
ADD CONSTRAINT [PK_Competitor_UID]
    PRIMARY KEY CLUSTERED ([UID] ASC);
GO

-- Creating primary key on [Id] in table 'GameInfo'
ALTER TABLE [dbo].[GameInfo]
ADD CONSTRAINT [PK_GameInfo_IdGameinfo]
    PRIMARY KEY CLUSTERED ([IdGameinfo] ASC);
GO

-- Creating primary key on [Id] in table 'PivotDay'
ALTER TABLE [dbo].[PivotDay]
ADD CONSTRAINT [PK_PivotDay_Id]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO
-- Optional table.
-- this table must be replaced by Microsoft Owin
-- Creating primary key on [Id] in table 'AdminUser'
ALTER TABLE [dbo].[AdminUser]
ADD CONSTRAINT [PK_AdminUser_Email]
    PRIMARY KEY CLUSTERED ([Email] ASC);
GO
-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------
-- Creating foreign key on [idSize] in table 'Product'
ALTER TABLE [dbo].[Product]
ADD CONSTRAINT [FK_Product_Size_idSize]
	FOREIGN KEY (idSize) REFERENCES [dbo].[Size](idSize);
GO

-- Creating foreign key on [SKU] in table 'Ticket'
ALTER TABLE [dbo].[Ticket]
ADD CONSTRAINT [FK_Ticket_Product_SKU]
	FOREIGN KEY (SKU) REFERENCES [dbo].[Product](SKU);
GO

-- Creating foreign key on [UID] in table 'Ticket'
ALTER TABLE [dbo].[Ticket]
ADD CONSTRAINT [FK_Ticket_Competitor_UID]
	FOREIGN KEY ([UID]) REFERENCES [dbo].[Competitor]([UID]);
GO

-- Creating foreign key on [IdGameinfo] in table 'PivotDay'
ALTER TABLE [dbo].[PivotDay]
ADD CONSTRAINT [FK_PivotDay_GameInfo_IdGameinfo]
	FOREIGN KEY (IdGameinfo) REFERENCES [dbo].[GameInfo](IdGameinfo);
GO
-- Creating foreign key on [IdParam] in table 'PivotDay'
ALTER TABLE [dbo].[PivotDay]
ADD CONSTRAINT [FK_PivotDay_Params_IdParam]
	FOREIGN KEY (IdParam) REFERENCES [dbo].[Params](Id);
GO
-- Creating foreign key on [IdParam] in table 'Gameinfo'
ALTER TABLE [dbo].[Gameinfo]
ADD CONSTRAINT [FK_Gameinfo_Params_IdParam]
	FOREIGN KEY (IdParam) REFERENCES [dbo].[Params](Id);
GO
-- Creating foreign key on [IdFather] in table 'SiteMap'
ALTER TABLE [dbo].[SiteMap]
ADD CONSTRAINT [FK_SiteMap_SiteMap_IdFather]
	FOREIGN KEY (IdFather) REFERENCES [dbo].[SiteMap](Id);
GO

-- --------------------------------------------------
-- Creating INDEXES
-- --------------------------------------------------
-- Creating INDEX on [UID] in table 'Ticket'
CREATE NONCLUSTERED INDEX NIX_Ticket_UID ON [dbo].[Ticket]([UID]);
GO
-- Creating INDEX on [PivotDate] in table 'PivotDay'
CREATE UNIQUE INDEX NIX_PivotDay_PivotDate ON [dbo].[PivotDay](PivotDate);
GO

-- Creating INDEX on [Path] in table 'SiteMap'
CREATE NONCLUSTERED INDEX NIX_SiteMap_Path ON [dbo].[SiteMap]([Path]);
GO
-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------