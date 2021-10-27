-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 09/10/2021 22:09:50
-- Author: Eng. JORGE FLORES MIGUEL   jorge_kain@yahoo.com
-- Description:  Game Table Collection
-- --------------------------------------------------
-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------
IF OBJECT_ID(N'dbo.FK_Game_0_GameInfo_IdGameinfo', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_0] DROP CONSTRAINT [FK_Game_0_GameInfo_IdGameinfo];
GO
IF OBJECT_ID(N'dbo.FK_Game_1_GameInfo_IdGameinfo', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_1] DROP CONSTRAINT [FK_Game_1_GameInfo_IdGameinfo];
GO
IF OBJECT_ID(N'dbo.FK_Game_2_GameInfo_IdGameinfo', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_2] DROP CONSTRAINT [FK_Game_2_GameInfo_IdGameinfo];
GO
IF OBJECT_ID(N'dbo.FK_Game_3_GameInfo_IdGameinfo', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_3] DROP CONSTRAINT [FK_Game_3_GameInfo_IdGameinfo];
GO
IF OBJECT_ID(N'dbo.FK_Game_4_GameInfo_IdGameinfo', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_4] DROP CONSTRAINT [FK_Game_4_GameInfo_IdGameinfo];
GO
IF OBJECT_ID(N'dbo.FK_Game_5_GameInfo_IdGameinfo', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_5] DROP CONSTRAINT [FK_Game_5_GameInfo_IdGameinfo];
GO
IF OBJECT_ID(N'dbo.FK_Game_6_GameInfo_IdGameinfo', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_6] DROP CONSTRAINT [FK_Game_6_GameInfo_IdGameinfo];
GO
IF OBJECT_ID(N'dbo.FK_Game_7_GameInfo_IdGameinfo', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_7] DROP CONSTRAINT [FK_Game_7_GameInfo_IdGameinfo];
GO
IF OBJECT_ID(N'dbo.FK_Game_8_GameInfo_IdGameinfo', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_8] DROP CONSTRAINT [FK_Game_8_GameInfo_IdGameinfo];
GO

IF OBJECT_ID(N'dbo.FK_Game_0_Ticket_IdTicket', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_0] DROP CONSTRAINT [FK_Game_0_Ticket_IdTicket];
GO
IF OBJECT_ID(N'dbo.FK_Game_1_Ticket_IdTicket', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_1] DROP CONSTRAINT [FK_Game_1_Ticket_IdTicket];
GO
IF OBJECT_ID(N'dbo.FK_Game_2_Ticket_IdTicket', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_2] DROP CONSTRAINT [FK_Game_2_Ticket_IdTicket];
GO
IF OBJECT_ID(N'dbo.FK_Game_3_Ticket_IdTicket', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_3] DROP CONSTRAINT [FK_Game_3_Ticket_IdTicket];
GO
IF OBJECT_ID(N'dbo.FK_Game_4_Ticket_IdTicket', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_4] DROP CONSTRAINT [FK_Game_4_Ticket_IdTicket];
GO
IF OBJECT_ID(N'dbo.FK_Game_5_Ticket_IdTicket', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_5] DROP CONSTRAINT [FK_Game_5_Ticket_IdTicket];
GO
IF OBJECT_ID(N'dbo.FK_Game_6_Ticket_IdTicket', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_6] DROP CONSTRAINT [FK_Game_6_Ticket_IdTicket];
GO
IF OBJECT_ID(N'dbo.FK_Game_7_Ticket_IdTicket', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_7] DROP CONSTRAINT [FK_Game_7_Ticket_IdTicket];
GO
IF OBJECT_ID(N'dbo.FK_Game_8_Ticket_IdTicket', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_8] DROP CONSTRAINT [FK_Game_8_Ticket_IdTicket];
GO

IF OBJECT_ID(N'dbo.FK_Game_0_PivotDay_PivotDayId', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_0] DROP CONSTRAINT [FK_Game_0_PivotDay_PivotDayId];
GO
IF OBJECT_ID(N'dbo.FK_Game_1_PivotDay_PivotDayId', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_1] DROP CONSTRAINT [FK_Game_1_PivotDay_PivotDayId];
GO
IF OBJECT_ID(N'dbo.FK_Game_2_PivotDay_PivotDayId', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_2] DROP CONSTRAINT [FK_Game_2_PivotDay_PivotDayId];
GO
IF OBJECT_ID(N'dbo.FK_Game_3_PivotDay_PivotDayId', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_3] DROP CONSTRAINT [FK_Game_3_PivotDay_PivotDayId];
GO
IF OBJECT_ID(N'dbo.FK_Game_4_PivotDay_PivotDayId', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_4] DROP CONSTRAINT [FK_Game_4_PivotDay_PivotDayId];
GO
IF OBJECT_ID(N'dbo.FK_Game_5_PivotDay_PivotDayId', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_5] DROP CONSTRAINT [FK_Game_5_PivotDay_PivotDayId];
GO
IF OBJECT_ID(N'dbo.FK_Game_6_PivotDay_PivotDayId', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_6] DROP CONSTRAINT [FK_Game_6_PivotDay_PivotDayId];
GO
IF OBJECT_ID(N'dbo.FK_Game_7_PivotDay_PivotDayId', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_7] DROP CONSTRAINT [FK_Game_7_PivotDay_PivotDayId];
GO
IF OBJECT_ID(N'dbo.FK_Game_8_PivotDay_PivotDayId', N'F') IS NOT NULL ALTER TABLE [dbo].[Game_8] DROP CONSTRAINT [FK_Game_8_PivotDay_PivotDayId];
GO
-- --------------------------------------------------
-- Dropping existing INDEX
-- --------------------------------------------------

IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_Game_0_GameDate' AND object_id = OBJECT_ID('[dbo].[Game_0]')) DROP INDEX NIX_Game_0_GameDate ON [dbo].[Game_0];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_Game_1_GameDate' AND object_id = OBJECT_ID('[dbo].[Game_1]')) DROP INDEX NIX_Game_1_GameDate ON [dbo].[Game_1];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_Game_2_GameDate' AND object_id = OBJECT_ID('[dbo].[Game_2]')) DROP INDEX NIX_Game_2_GameDate ON [dbo].[Game_2];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_Game_3_GameDate' AND object_id = OBJECT_ID('[dbo].[Game_3]')) DROP INDEX NIX_Game_3_GameDate ON [dbo].[Game_3];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_Game_4_GameDate' AND object_id = OBJECT_ID('[dbo].[Game_4]')) DROP INDEX NIX_Game_4_GameDate ON [dbo].[Game_4];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_Game_5_GameDate' AND object_id = OBJECT_ID('[dbo].[Game_5]')) DROP INDEX NIX_Game_5_GameDate ON [dbo].[Game_5];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_Game_6_GameDate' AND object_id = OBJECT_ID('[dbo].[Game_6]')) DROP INDEX NIX_Game_6_GameDate ON [dbo].[Game_6];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_Game_7_GameDate' AND object_id = OBJECT_ID('[dbo].[Game_7]')) DROP INDEX NIX_Game_7_GameDate ON [dbo].[Game_7];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_Game_8_GameDate' AND object_id = OBJECT_ID('[dbo].[Game_8]')) DROP INDEX NIX_Game_8_GameDate ON [dbo].[Game_8];  
GO

IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_Game_0_IdTicket' AND object_id = OBJECT_ID('[dbo].[Game_0]')) DROP INDEX NIX_Game_0_IdTicket ON [dbo].[Game_0];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_Game_1_IdTicket' AND object_id = OBJECT_ID('[dbo].[Game_1]')) DROP INDEX NIX_Game_1_IdTicket ON [dbo].[Game_1];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_Game_2_IdTicket' AND object_id = OBJECT_ID('[dbo].[Game_2]')) DROP INDEX NIX_Game_2_IdTicket ON [dbo].[Game_2];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_Game_3_IdTicket' AND object_id = OBJECT_ID('[dbo].[Game_3]')) DROP INDEX NIX_Game_3_IdTicket ON [dbo].[Game_3];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_Game_4_IdTicket' AND object_id = OBJECT_ID('[dbo].[Game_4]')) DROP INDEX NIX_Game_4_IdTicket ON [dbo].[Game_4];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_Game_5_IdTicket' AND object_id = OBJECT_ID('[dbo].[Game_5]')) DROP INDEX NIX_Game_5_IdTicket ON [dbo].[Game_5];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_Game_6_IdTicket' AND object_id = OBJECT_ID('[dbo].[Game_6]')) DROP INDEX NIX_Game_6_IdTicket ON [dbo].[Game_6];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_Game_7_IdTicket' AND object_id = OBJECT_ID('[dbo].[Game_7]')) DROP INDEX NIX_Game_7_IdTicket ON [dbo].[Game_7];  
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE name='NIX_Game_8_IdTicket' AND object_id = OBJECT_ID('[dbo].[Game_8]')) DROP INDEX NIX_Game_8_IdTicket ON [dbo].[Game_8];  
GO

-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------
IF OBJECT_ID(N'[dbo].[Game_0]') IS NOT NULL DROP TABLE [dbo].[Game_0];
GO
IF OBJECT_ID(N'[dbo].[Game_1]') IS NOT NULL DROP TABLE [dbo].[Game_1];
GO
IF OBJECT_ID(N'[dbo].[Game_2]') IS NOT NULL DROP TABLE [dbo].[Game_2];
GO
IF OBJECT_ID(N'[dbo].[Game_3]') IS NOT NULL DROP TABLE [dbo].[Game_3];
GO
IF OBJECT_ID(N'[dbo].[Game_4]') IS NOT NULL DROP TABLE [dbo].[Game_4];
GO
IF OBJECT_ID(N'[dbo].[Game_5]') IS NOT NULL DROP TABLE [dbo].[Game_5];
GO
IF OBJECT_ID(N'[dbo].[Game_6]') IS NOT NULL DROP TABLE [dbo].[Game_6];
GO
IF OBJECT_ID(N'[dbo].[Game_7]') IS NOT NULL DROP TABLE [dbo].[Game_7];
GO
IF OBJECT_ID(N'[dbo].[Game_8]') IS NOT NULL DROP TABLE [dbo].[Game_8];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------
-- Creating table 'Game_0'      
-- All the pendings games are saved in Game_0
CREATE TABLE [dbo].[Game_0] (
	[PivotDayId] int NOT NULL,
    [Id] bigint NOT NULL,
    [IdGameInfo] int NULL,
    [GameDate] datetime NULL,
    [EndDate]  datetime NULL,
    [Time] time NULL,
    [IdTicket] nvarchar(40)  NOT NULL,
    [CreationDate] datetime NOT NULL
);
GO
-- Creating table 'Game_1'
CREATE TABLE [dbo].[Game_1] (
	[PivotDayId] int NOT NULL,
    [Id] bigint NOT NULL,
    [IdGameInfo] int NULL,
    [GameDate] datetime NULL,
    [EndDate]  datetime NULL,
    [Time] time NULL,
    [IdTicket] nvarchar(40)  NOT NULL,
    [CreationDate] datetime NOT NULL
);
GO
-- Creating table 'Game_2'
CREATE TABLE [dbo].[Game_2] (
	[PivotDayId] int NOT NULL,
    [Id] bigint NOT NULL,
    [IdGameInfo] int NULL,
    [GameDate] datetime NULL,
    [EndDate]  datetime NULL,
    [Time] time NULL,
    [IdTicket] nvarchar(40)  NOT NULL,
    [CreationDate] datetime NOT NULL
);
GO
-- Creating table 'Game_3'
CREATE TABLE [dbo].[Game_3] (
	[PivotDayId] int NOT NULL,
    [Id] bigint NOT NULL,
    [IdGameInfo] int NULL,
    [GameDate] datetime NULL,
    [EndDate]  datetime NULL,
    [Time] time NULL,
    [IdTicket] nvarchar(40)  NOT NULL,
    [CreationDate] datetime NOT NULL
);
GO
-- Creating table 'Game_4'
CREATE TABLE [dbo].[Game_4] (
	[PivotDayId] int NOT NULL,
    [Id] bigint NOT NULL,
    [IdGameInfo] int NULL,
    [GameDate] datetime NULL,
    [EndDate]  datetime NULL,
    [Time] time NULL,
    [IdTicket] nvarchar(40)  NOT NULL,
    [CreationDate] datetime NOT NULL
);
GO
-- Creating table 'Game_5'
CREATE TABLE [dbo].[Game_5] (
	[PivotDayId] int NOT NULL,
    [Id] bigint NOT NULL,
    [IdGameInfo] int NULL,
    [GameDate] datetime NULL,
    [EndDate]  datetime NULL,
    [Time] time NULL,
    [IdTicket] nvarchar(40)  NOT NULL,
    [CreationDate] datetime NOT NULL
);
GO
-- Creating table 'Game_6'
CREATE TABLE [dbo].[Game_6] (
	[PivotDayId] int NOT NULL,
    [Id] bigint NOT NULL,
    [IdGameInfo] int NULL,
    [GameDate] datetime NULL,
    [EndDate]  datetime NULL,
    [Time] time NULL,
    [IdTicket] nvarchar(40)  NOT NULL,
    [CreationDate] datetime NOT NULL
);
GO
-- Creating table 'Game_7'
CREATE TABLE [dbo].[Game_7] (
	[PivotDayId] int NOT NULL,
    [Id] bigint NOT NULL,
    [IdGameInfo] int NULL,
    [GameDate] datetime NULL,
    [EndDate]  datetime NULL,
    [Time] time NULL,
    [IdTicket] nvarchar(40)  NOT NULL,
    [CreationDate] datetime NOT NULL
);
GO
-- Creating table 'Game_8'
CREATE TABLE [dbo].[Game_8] (
	[PivotDayId] int NOT NULL,
    [Id] bigint NOT NULL,
    [IdGameInfo] int NULL,
    [GameDate] datetime NULL,
    [EndDate]  datetime NULL,
    [Time] time NULL,
    [IdTicket] nvarchar(40)  NOT NULL,
    [CreationDate] datetime NOT NULL
);
GO
-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------
-- Creating primary key on [Id] in table 'Game_1'
ALTER TABLE [dbo].[Game_0] ADD CONSTRAINT [PK_Game_0_PivotDayId_Id] PRIMARY KEY CLUSTERED ([PivotDayId],[Id]);
GO
ALTER TABLE [dbo].[Game_1] ADD CONSTRAINT [PK_Game_1_PivotDayId_Id] PRIMARY KEY CLUSTERED ([PivotDayId],[Id]);
GO
ALTER TABLE [dbo].[Game_2] ADD CONSTRAINT [PK_Game_2_PivotDayId_Id] PRIMARY KEY CLUSTERED ([PivotDayId],[Id]);
GO
ALTER TABLE [dbo].[Game_3] ADD CONSTRAINT [PK_Game_3_PivotDayId_Id] PRIMARY KEY CLUSTERED ([PivotDayId],[Id]);
GO
ALTER TABLE [dbo].[Game_4] ADD CONSTRAINT [PK_Game_4_PivotDayId_Id] PRIMARY KEY CLUSTERED ([PivotDayId],[Id]);
GO
ALTER TABLE [dbo].[Game_5] ADD CONSTRAINT [PK_Game_5_PivotDayId_Id] PRIMARY KEY CLUSTERED ([PivotDayId],[Id]);
GO
ALTER TABLE [dbo].[Game_6] ADD CONSTRAINT [PK_Game_6_PivotDayId_Id] PRIMARY KEY CLUSTERED ([PivotDayId],[Id]);
GO
ALTER TABLE [dbo].[Game_7] ADD CONSTRAINT [PK_Game_7_PivotDayId_Id] PRIMARY KEY CLUSTERED ([PivotDayId],[Id]);
GO
ALTER TABLE [dbo].[Game_8] ADD CONSTRAINT [PK_Game_8_PivotDayId_Id] PRIMARY KEY CLUSTERED ([PivotDayId],[Id]);
GO
-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------
-- Creating foreign key on [IdGameinfo] in table 'Game_0'
ALTER TABLE [dbo].[Game_0] ADD CONSTRAINT [FK_Game_0_GameInfo_IdGameinfo] FOREIGN KEY (IdGameinfo) REFERENCES [dbo].[GameInfo](IdGameinfo);
GO
-- Creating foreign key on [IdGameinfo] in table 'Game_1'
ALTER TABLE [dbo].[Game_1] ADD CONSTRAINT [FK_Game_1_GameInfo_IdGameinfo] FOREIGN KEY (IdGameinfo) REFERENCES [dbo].[GameInfo](IdGameinfo);
GO
-- Creating foreign key on [IdGameinfo] in table 'Game_2'
ALTER TABLE [dbo].[Game_2] ADD CONSTRAINT [FK_Game_2_GameInfo_IdGameinfo] FOREIGN KEY (IdGameinfo) REFERENCES [dbo].[GameInfo](IdGameinfo);
GO
-- Creating foreign key on [IdGameinfo] in table 'Game_3'
ALTER TABLE [dbo].[Game_3] ADD CONSTRAINT [FK_Game_3_GameInfo_IdGameinfo] FOREIGN KEY (IdGameinfo) REFERENCES [dbo].[GameInfo](IdGameinfo);
GO
-- Creating foreign key on [IdGameinfo] in table 'Game_4'
ALTER TABLE [dbo].[Game_4] ADD CONSTRAINT [FK_Game_4_GameInfo_IdGameinfo] FOREIGN KEY (IdGameinfo) REFERENCES [dbo].[GameInfo](IdGameinfo);
GO
-- Creating foreign key on [IdGameinfo] in table 'Game_5'
ALTER TABLE [dbo].[Game_5] ADD CONSTRAINT [FK_Game_5_GameInfo_IdGameinfo] FOREIGN KEY (IdGameinfo) REFERENCES [dbo].[GameInfo](IdGameinfo);
GO
-- Creating foreign key on [IdGameinfo] in table 'Game_6'
ALTER TABLE [dbo].[Game_6] ADD CONSTRAINT [FK_Game_6_GameInfo_IdGameinfo] FOREIGN KEY (IdGameinfo) REFERENCES [dbo].[GameInfo](IdGameinfo);
GO
-- Creating foreign key on [IdGameinfo] in table 'Game_7'
ALTER TABLE [dbo].[Game_7] ADD CONSTRAINT [FK_Game_7_GameInfo_IdGameinfo] FOREIGN KEY (IdGameinfo) REFERENCES [dbo].[GameInfo](IdGameinfo);
GO
-- Creating foreign key on [IdGameinfo] in table 'Game_8'
ALTER TABLE [dbo].[Game_8] ADD CONSTRAINT [FK_Game_8_GameInfo_IdGameinfo] FOREIGN KEY (IdGameinfo) REFERENCES [dbo].[GameInfo](IdGameinfo);
GO


-- Creating foreign key on [IdTicket] in table 'Game_0'
ALTER TABLE [dbo].[Game_0] ADD CONSTRAINT [FK_Game_0_Ticket_IdTicket] FOREIGN KEY (IdTicket) REFERENCES [dbo].[Ticket](IdTicket);
GO
-- Creating foreign key on [IdTicket] in table 'Game_1'
ALTER TABLE [dbo].[Game_1] ADD CONSTRAINT [FK_Game_1_Ticket_IdTicket] FOREIGN KEY (IdTicket) REFERENCES [dbo].[Ticket](IdTicket);
GO
-- Creating foreign key on [IdTicket] in table 'Game_1'
ALTER TABLE [dbo].[Game_2] ADD CONSTRAINT [FK_Game_2_Ticket_IdTicket] FOREIGN KEY (IdTicket) REFERENCES [dbo].[Ticket](IdTicket);
GO
-- Creating foreign key on [IdTicket] in table 'Game_1'
ALTER TABLE [dbo].[Game_3] ADD CONSTRAINT [FK_Game_3_Ticket_IdTicket] FOREIGN KEY (IdTicket) REFERENCES [dbo].[Ticket](IdTicket);
GO
-- Creating foreign key on [IdTicket] in table 'Game_1'
ALTER TABLE [dbo].[Game_4] ADD CONSTRAINT [FK_Game_4_Ticket_IdTicket] FOREIGN KEY (IdTicket) REFERENCES [dbo].[Ticket](IdTicket);
GO
-- Creating foreign key on [IdTicket] in table 'Game_1'
ALTER TABLE [dbo].[Game_5] ADD CONSTRAINT [FK_Game_5_Ticket_IdTicket] FOREIGN KEY (IdTicket) REFERENCES [dbo].[Ticket](IdTicket);
GO
-- Creating foreign key on [IdTicket] in table 'Game_1'
ALTER TABLE [dbo].[Game_6] ADD CONSTRAINT [FK_Game_6_Ticket_IdTicket] FOREIGN KEY (IdTicket) REFERENCES [dbo].[Ticket](IdTicket);
GO
-- Creating foreign key on [IdTicket] in table 'Game_1'
ALTER TABLE [dbo].[Game_7] ADD CONSTRAINT [FK_Game_7_Ticket_IdTicket] FOREIGN KEY (IdTicket) REFERENCES [dbo].[Ticket](IdTicket);
GO
-- Creating foreign key on [IdTicket] in table 'Game_1'
ALTER TABLE [dbo].[Game_8] ADD CONSTRAINT [FK_Game_8_Ticket_IdTicket] FOREIGN KEY (IdTicket) REFERENCES [dbo].[Ticket](IdTicket);
GO


-- Creating foreign key on [PivotDayId] in table 'Game_0'
ALTER TABLE [dbo].[Game_0] ADD CONSTRAINT [FK_Game_0_PivotDay_PivotDayId] FOREIGN KEY (PivotDayId) REFERENCES [dbo].[PivotDay](Id);
GO
-- Creating foreign key on [PivotDayId] in table 'Game_1'
ALTER TABLE [dbo].[Game_1] ADD CONSTRAINT [FK_Game_1_PivotDay_PivotDayId] FOREIGN KEY (PivotDayId) REFERENCES [dbo].[PivotDay](Id);
GO
-- Creating foreign key on [PivotDayId] in table 'Game_2'
ALTER TABLE [dbo].[Game_2] ADD CONSTRAINT [FK_Game_2_PivotDay_PivotDayId] FOREIGN KEY (PivotDayId) REFERENCES [dbo].[PivotDay](Id);
GO
-- Creating foreign key on [PivotDayId] in table 'Game_3'
ALTER TABLE [dbo].[Game_3] ADD CONSTRAINT [FK_Game_3_PivotDay_PivotDayId] FOREIGN KEY (PivotDayId) REFERENCES [dbo].[PivotDay](Id);
GO
-- Creating foreign key on [PivotDayId] in table 'Game_4'
ALTER TABLE [dbo].[Game_4] ADD CONSTRAINT [FK_Game_4_PivotDay_PivotDayId] FOREIGN KEY (PivotDayId) REFERENCES [dbo].[PivotDay](Id);
GO
-- Creating foreign key on [PivotDayId] in table 'Game_5'
ALTER TABLE [dbo].[Game_5] ADD CONSTRAINT [FK_Game_5_PivotDay_PivotDayId] FOREIGN KEY (PivotDayId) REFERENCES [dbo].[PivotDay](Id);
GO
-- Creating foreign key on [PivotDayId] in table 'Game_6'
ALTER TABLE [dbo].[Game_6] ADD CONSTRAINT [FK_Game_6_PivotDay_PivotDayId] FOREIGN KEY (PivotDayId) REFERENCES [dbo].[PivotDay](Id);
GO
-- Creating foreign key on [PivotDayId] in table 'Game_7'
ALTER TABLE [dbo].[Game_7] ADD CONSTRAINT [FK_Game_7_PivotDay_PivotDayId] FOREIGN KEY (PivotDayId) REFERENCES [dbo].[PivotDay](Id);
GO
-- Creating foreign key on [PivotDayId] in table 'Game_8'
ALTER TABLE [dbo].[Game_8] ADD CONSTRAINT [FK_Game_8_PivotDay_PivotDayId] FOREIGN KEY (PivotDayId) REFERENCES [dbo].[PivotDay](Id);
GO
-- --------------------------------------------------
-- Creating INDEXES
-- --------------------------------------------------
-- Creating INDEX on [GameDate] in table 'Game_0'
CREATE NONCLUSTERED INDEX NIX_Game_0_GameDate ON [dbo].[Game_0](GameDate);
GO
-- Creating INDEX on [GameDate] in table 'Game_1'
CREATE NONCLUSTERED INDEX NIX_Game_1_GameDate ON [dbo].[Game_1](GameDate);
GO
-- Creating INDEX on [GameDate] in table 'Game_2'
CREATE NONCLUSTERED INDEX NIX_Game_2_GameDate ON [dbo].[Game_2](GameDate);
GO
-- Creating INDEX on [GameDate] in table 'Game_3'
CREATE NONCLUSTERED INDEX NIX_Game_3_GameDate ON [dbo].[Game_3](GameDate);
GO
-- Creating INDEX on [GameDate] in table 'Game_4'
CREATE NONCLUSTERED INDEX NIX_Game_4_GameDate ON [dbo].[Game_4](GameDate);
GO
-- Creating INDEX on [GameDate] in table 'Game_5'
CREATE NONCLUSTERED INDEX NIX_Game_5_GameDate ON [dbo].[Game_5](GameDate);
GO
-- Creating INDEX on [GameDate] in table 'Game_6'
CREATE NONCLUSTERED INDEX NIX_Game_6_GameDate ON [dbo].[Game_6](GameDate);
GO
-- Creating INDEX on [GameDate] in table 'Game_7'
CREATE NONCLUSTERED INDEX NIX_Game_7_GameDate ON [dbo].[Game_7](GameDate);
GO
-- Creating INDEX on [GameDate] in table 'Game_8'
CREATE NONCLUSTERED INDEX NIX_Game_8_GameDate ON [dbo].[Game_8](GameDate);
GO

-- Creating INDEX on [IdTicket] in table 'Game_0'
CREATE NONCLUSTERED INDEX NIX_Game_0_IdTicket ON [dbo].[Game_0](IdTicket);
GO
-- Creating INDEX on [IdTicket] in table 'Game_1'
CREATE NONCLUSTERED INDEX NIX_Game_1_IdTicket ON [dbo].[Game_1](IdTicket);
GO
-- Creating INDEX on [IdTicket] in table 'Game_2'
CREATE NONCLUSTERED INDEX NIX_Game_2_IdTicket ON [dbo].[Game_2](IdTicket);
GO
-- Creating INDEX on [IdTicket] in table 'Game_3'
CREATE NONCLUSTERED INDEX NIX_Game_3_IdTicket ON [dbo].[Game_3](IdTicket);
GO
-- Creating INDEX on [IdTicket] in table 'Game_4'
CREATE NONCLUSTERED INDEX NIX_Game_4_IdTicket ON [dbo].[Game_4](IdTicket);
GO
-- Creating INDEX on [IdTicket] in table 'Game_5'
CREATE NONCLUSTERED INDEX NIX_Game_5_IdTicket ON [dbo].[Game_5](IdTicket);
GO
-- Creating INDEX on [IdTicket] in table 'Game_6'
CREATE NONCLUSTERED INDEX NIX_Game_6_IdTicket ON [dbo].[Game_6](IdTicket);
GO
-- Creating INDEX on [IdTicket] in table 'Game_7'
CREATE NONCLUSTERED INDEX NIX_Game_7_IdTicket ON [dbo].[Game_7](IdTicket);
GO
-- Creating INDEX on [IdTicket] in table 'Game_8'
CREATE NONCLUSTERED INDEX NIX_Game_8_IdTicket ON [dbo].[Game_8](IdTicket);
GO

-- --------------------------------------------------
-- Creating all CHECK constraints
-- --------------------------------------------------
-- Creating CHECK CONSTRAINT on [PivotDayId] in table 'Game_0'
ALTER TABLE [dbo].[Game_0] ADD CONSTRAINT [CK_Game_0_PivotDayId]   CHECK ([PivotDayId] >= 0 AND PivotDayId < 1);
GO
-- Creating CHECK CONSTRAINT on [PivotDayId] in table 'Game_1'
ALTER TABLE [dbo].[Game_1] ADD CONSTRAINT [CK_Game_1_PivotDayId]   CHECK ([PivotDayId] >= 1 AND PivotDayId < 2);
GO
-- Creating CHECK CONSTRAINT on [PivotDayId] in table 'Game_2'
ALTER TABLE [dbo].[Game_2] ADD CONSTRAINT [CK_Game_2_PivotDayId]   CHECK ([PivotDayId] >= 2 AND PivotDayId < 3);
GO
-- Creating CHECK CONSTRAINT on [PivotDayId] in table 'Game_3'
ALTER TABLE [dbo].[Game_3] ADD CONSTRAINT [CK_Game_3_PivotDayId]   CHECK ([PivotDayId] >= 3 AND PivotDayId < 4);
GO
-- Creating CHECK CONSTRAINT on [PivotDayId] in table 'Game_4'
ALTER TABLE [dbo].[Game_4] ADD CONSTRAINT [CK_Game_4_PivotDayId]   CHECK ([PivotDayId] >= 4 AND PivotDayId < 5);
GO
-- Creating CHECK CONSTRAINT on [PivotDayId] in table 'Game_5'
ALTER TABLE [dbo].[Game_5] ADD CONSTRAINT [CK_Game_5_PivotDayId]   CHECK ([PivotDayId] >= 5 AND PivotDayId < 6);
GO
-- Creating CHECK CONSTRAINT on [PivotDayId] in table 'Game_6'
ALTER TABLE [dbo].[Game_6] ADD CONSTRAINT [CK_Game_6_PivotDayId]   CHECK ([PivotDayId] >= 6 AND PivotDayId < 7);
GO
-- Creating CHECK CONSTRAINT on [PivotDayId] in table 'Game_7'
ALTER TABLE [dbo].[Game_7] ADD CONSTRAINT [CK_Game_7_PivotDayId]   CHECK ([PivotDayId] >= 7 AND PivotDayId < 8);
GO
-- Creating CHECK CONSTRAINT on [PivotDayId] in table 'Game_8'
ALTER TABLE [dbo].[Game_8] ADD CONSTRAINT [CK_Game_8_PivotDayId]   CHECK ([PivotDayId] >= 8 AND PivotDayId < 9);
GO
