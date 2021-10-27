/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [IdSize]
      ,[Description]
  FROM [www.gana.kleenbebe.com_1].[dbo].[Size]

  INSERT INTO [www.gana.kleenbebe.com_1].[dbo].[Size]
	([Description])
	VALUES 
	('Recién nacido')
	,('Chico')
	,('Mediano')
	,('Grande')
	,('Jumbo')
	,('Extra jumbo')