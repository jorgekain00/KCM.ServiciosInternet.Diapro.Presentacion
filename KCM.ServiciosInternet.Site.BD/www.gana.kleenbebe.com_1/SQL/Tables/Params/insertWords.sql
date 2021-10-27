/****** Script for SelectTopNRows command from SSMS  ******/

use  [www.gana.kleenbebe.com_1]
SELECT TOP (1000) [Id]
      ,[Description]
      ,[Value]
  FROM [www.gana.kleenbebe.com_1].[dbo].[Params];

  --DELETE FROM [www.gana.kleenbebe.com_1].[dbo].[Params] WHERE ID = 'words1'

 -- update dbo.gameinfo
	--set IdParam = 'WORDS1'
	--where IdGameinfo = 1

	--select * from dbo.gameinfo where IdGameinfo = 1

update [www.gana.kleenbebe.com_1].[dbo].[Params]
		set [Value] = 
		'[
		{
			"word" : {"config" : { "rows" : 11, "columns" : 10, "ExpiredTimeInSeconds" : 600 }}
		},
		{
			"word" : ["KLEENBEBE"]
		},
		{
			"word" : ["SUAVELASTIC"]
		},
		{
			"word" : ["PAÑAL"]
		},
		{
			"word" : ["MAMA"]
		},
		{
			"word" : ["BEBE"]
		},
		{
			"word" : ["BIBERON"]
		},
		{
			"word" : ["CARRIOLA"]
		},
		{
			"word" : ["FERIA"]
		},
		{
			"word" : ["GANADORA"]
		},
		{
			"word" : ["SORPRESA"]
		},
		{
			"word" : ["MOVILASTIC"]
		},
		{
			"word" : ["JUEGO"]
		},
		{
			"word" : ["TOALLITAS"]
		},
		{
			"word" : ["MOVIMIENTO"]
		},
		{
			"word" : ["PEQUES"]
		},
		{
			"word" : ["REGALO"]
		},
		{
			"word" : ["COMODISEC"]
		},
		{
			"word" : ["MAMILA"]
		},
		{
			"word" : ["VASITO"]
		},
		{
			"word" : ["SONRISA"]
		},
		{
			"word" : ["GANADORAS"]
		},
		{
			"word" : ["PREMIO"]
		},
		{
			"word" : ["ABSORSEC"]
		},
		{
			"word" :["POMPIS"]
		},
		{
			"word" : ["CHUPON"]
		},
		{
			"word" : ["CUNA"]
		},
		{
			"word" : ["SHAMPOO"]
		},
		{
			"word" : ["MAMAS"]
		},
		{
			"word" : ["BEBES"]
		},
		{
			"word" : ["ABRAZO"]
		},
		{
			"word" : ["TINA"]
		},
		{
			"word" : ["CREMA"]
		},
		{
			"word" : ["JABON"]
		},
		{
			"word" : ["TRAVESURAS"]
		},
		{
			"word" : ["JUGUETES"]
		},
		{
			"word" : ["MANZANILLA"]
		},
		{
			"word" : ["BAÑO"]
		},
		{
			"word" : ["JUEGOS"]
		},
		{
			"word" : ["RISITA"]
		},
		{
			"word" : ["CARRITO"]
		},
		{
			"word" : ["PELOTA"]
		},
		{
			"word" : ["MUÑECA"]
		},
		{
			"word" : ["PAÑALES"]
		},
		{
			"word" : ["CREMITA"]
		},
		{
			"word" : ["SONAJA"]
		},
		{
			"word" : ["MAMELUCO"]
		},
		{
			"word" : ["MANTITA"]
		},
		{
			"word" : ["FAMILIA"]
		}
	]'
	where id = 'words1'


  insert into [www.gana.kleenbebe.com_1].[dbo].[Params](
		[Id]
      ,[Description]
      ,[Value]
	  )
	values(
		'WORDS1',
		'Palabras para el sopa de letra',
		'[
		{
			"word" : {"config" : { "rows" : 11, "columns" : 10, "ExpiredTimeInSeconds" : 600 }}
		},
		{
			"word" : ["KLEENBEBE"]
		},
		{
			"word" : ["SUAVELASTIC"]
		},
		{
			"word" : ["PAÑAL"]
		},
		{
			"word" : ["MAMA"]
		},
		{
			"word" : ["BEBE"]
		},
		{
			"word" : ["BIBERON"]
		},
		{
			"word" : ["CARRIOLA"]
		},
		{
			"word" : ["FERIA"]
		},
		{
			"word" : ["GANADORA"]
		},
		{
			"word" : ["SORPRESA"]
		},
		{
			"word" : ["MOVILASTIC"]
		},
		{
			"word" : ["JUEGO"]
		},
		{
			"word" : ["TOALLITAS"]
		},
		{
			"word" : ["MOVIMIENTO"]
		},
		{
			"word" : ["PEQUES"]
		},
		{
			"word" : ["REGALO"]
		},
		{
			"word" : ["COMODISEC"]
		},
		{
			"word" : ["MAMILA"]
		},
		{
			"word" : ["VASITO"]
		},
		{
			"word" : ["SONRISA"]
		},
		{
			"word" : ["GANADORAS"]
		},
		{
			"word" : ["PREMIO"]
		},
		{
			"word" : ["ABSORSEC"]
		},
		{
			"word" :["POMPIS"]
		},
		{
			"word" : ["CHUPON"]
		},
		{
			"word" : ["CUNA"]
		},
		{
			"word" : ["SHAMPOO"]
		},
		{
			"word" : ["MAMAS"]
		},
		{
			"word" : ["BEBES"]
		},
		{
			"word" : ["ABRAZO"]
		},
		{
			"word" : ["TINA"]
		},
		{
			"word" : ["CREMA"]
		},
		{
			"word" : ["JABON"]
		},
		{
			"word" : ["TRAVESURAS"]
		},
		{
			"word" : ["JUGUETES"]
		},
		{
			"word" : ["MANZANILLA"]
		},
		{
			"word" : ["BAÑO"]
		},
		{
			"word" : ["JUEGOS"]
		},
		{
			"word" : ["RISITA"]
		},
		{
			"word" : ["CARRITO"]
		},
		{
			"word" : ["PELOTA"]
		},
		{
			"word" : ["MUÑECA"]
		},
		{
			"word" : ["PAÑALES"]
		},
		{
			"word" : ["CREMITA"]
		},
		{
			"word" : ["SONAJA"]
		},
		{
			"word" : ["MAMELUCO"]
		},
		{
			"word" : ["MANTITA"]
		},
		{
			"word" : ["FAMILIA"]
		}
	]'
	);



DECLARE @JSONPROMO NVARCHAR(2000) = '[
		{
			"word" : ["KLEENBEBE"]
		},
		{
			"word" : ["SUAVELASTIC"]
		},
		{
			"word" : ["PAÑAL"]
		},
		{
			"word" : ["MAMA"]
		},
		{
			"word" : ["BEBE"]
		},
		{
			"word" : ["BIBERON"]
		},
		{
			"word" : ["CARRIOLA"]
		},
		{
			"word" : ["FERIA"]
		},
		{
			"word" : ["GANADORA"]
		},
		{
			"word" : ["SORPRESA"]
		},
		{
			"word" : ["MOVILASTIC"]
		},
		{
			"word" : ["JUEGO"]
		},
		{
			"word" : ["TOALLITAS"]
		},
		{
			"word" : ["MOVIMIENTO"]
		},
		{
			"word" : ["PEQUES"]
		},
		{
			"word" : ["REGALO"]
		},
		{
			"word" : ["COMODISEC"]
		},
		{
			"word" : ["MAMILA"]
		},
		{
			"word" : ["VASITO"]
		},
		{
			"word" : ["SONRISA"]
		},
		{
			"word" : ["GANADORAS"]
		},
		{
			"word" : ["PREMIO"]
		},
		{
			"word" : ["ABSORSEC"]
		},
		{
			"word" :["POMPIS"]
		},
		{
			"word" : ["CHUPON"]
		},
		{
			"word" : ["CUNA"]
		},
		{
			"word" : ["SHAMPOO"]
		},
		{
			"word" : ["MAMAS"]
		},
		{
			"word" : ["BEBES"]
		},
		{
			"word" : ["ABRAZO"]
		},
		{
			"word" : ["TINA"]
		},
		{
			"word" : ["CREMA"]
		},
		{
			"word" : ["JABON"]
		},
		{
			"word" : ["TRAVESURAS"]
		},
		{
			"word" : ["JUGUETES"]
		},
		{
			"word" : ["MANZANILLA"]
		},
		{
			"word" : ["BAÑO"]
		},
		{
			"word" : ["JUEGOS"]
		},
		{
			"word" : ["RISITA"]
		},
		{
			"word" : ["CARRITO"]
		},
		{
			"word" : ["PELOTA"]
		},
		{
			"word" : ["MUÑECA"]
		},
		{
			"word" : ["PAÑALES"]
		},
		{
			"word" : ["CREMITA"]
		},
		{
			"word" : ["SONAJA"]
		},
		{
			"word" : ["MAMELUCO"]
		},
		{
			"word" : ["MANTITA"]
		},
		{
			"word" : ["FAMILIA"]
		}
	]';

	SELECT Word
	FROM OpenJson(@JSONPROMO)
		WITH (Word nvarchar(MAX) '$.word' as json);




