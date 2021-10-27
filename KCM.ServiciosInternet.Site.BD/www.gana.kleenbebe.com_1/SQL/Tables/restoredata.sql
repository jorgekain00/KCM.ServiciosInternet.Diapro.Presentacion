/****** Script for SelectTopNRows command from SSMS  ******/
INSERT INTO dbo.[Params]
SELECT TOP (1000) [Id]
      ,[Description]
      ,[Value]
  FROM [www.gana.kleenbebe.com_1].[KCUS\C84818].[Params]


  SET IDENTITY_INSERT dbo.Size ON
  insert into dbo.Size(
		[IdSize]  ,[Description]) 
  select [IdSize]
      ,[Description] from  [www.gana.kleenbebe.com_1].[KCUS\C84818].[Size]
	
  SET IDENTITY_INSERT dbo.Size OFF


   
  insert into dbo.product(
  [SKU]
      ,[Description]
      ,[Barcode]
      ,[Family]
      ,[idSize]
  )
  select [SKU]
      ,[Description]
      ,[Barcode]
      ,[Family]
      ,[idSize] from  [www.gana.kleenbebe.com_1].[KCUS\C84818].[product]
	
  

   SET IDENTITY_INSERT dbo.sitemap ON
  insert into dbo.sitemap(
   [Id]
      ,[Path]
      ,[Description]
      ,[IdFather]
      ,[IsAuthenticationNeeded]
      ,[IsDisplayNeeded]
  )
  select  [Id]
      ,[Path]
      ,[Description]
      ,[IdFather]
      ,[IsAuthenticationNeeded]
      ,[IsDisplayNeeded] from  [www.gana.kleenbebe.com_1].[KCUS\C84818].[sitemap]
	
  SET IDENTITY_INSERT dbo.sitemap OFF