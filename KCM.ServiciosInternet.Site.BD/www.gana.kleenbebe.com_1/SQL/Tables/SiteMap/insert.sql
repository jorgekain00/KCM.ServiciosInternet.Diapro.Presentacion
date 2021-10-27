/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Id]
      ,[Path]
      ,[Description]
      ,[IdFather]
      ,[IsAuthenticationNeeded]
	  ,[IsDisplayNeeded]
  FROM [www.gana.kleenbebe.com_1].[dbo].[SiteMap]


  update [www.gana.kleenbebe.com_1].[dbo].[SiteMap]
  set [IsAuthenticationNeeded] = 1
  where id in (4,5)
  --where id = 7
  --where id = 8

  insert into [www.gana.kleenbebe.com_1].[dbo].[SiteMap](
    	Path,	Description,	IdFather,	IsAuthenticationNeeded, IsDisplayNeeded
	)
	values
--	('/','Root',NULL,0,1)
	
--	('/Home/Index','Página de Inicio',1,0,1)
--	,('/Register/Index','Página de Registro',1,0,1)
--	,('/Ticket/Index','Página de registro de tickets',1,1,1)
--	,('/Games/Index','Página de Inicio de juegos',1,1,1)

--	('/Home','Página de Inicio',1,0,0)
--	,('/Register','Página de Registro',1,0,0)
--	,('/Ticket','Página de registro de tickets',1,1,0)
--	,('/Games','Página de Inicio de juegos',1,1,0)

	('/Home/Aviso','Aviso de Privacidad',2,0,1)
	,('/Home/Legales','Legales',2,0,1)
	,('/Home/Error','Página de Error',2,0,1)