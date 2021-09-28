CREATE TABLE [dbo].[CompraPelicula](
	[Id] [int] NOT NULL identity(0,1),
	[IdUser] [int] NOT NULL,
	[Precio] [numeric](18, 2) NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[IdPelicula] [int] NOT NULL,
 CONSTRAINT [PK_CompraPelicula] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[AlquilerPelicula](
	[Id] [int] NOT NULL,
	[IdUser] [int] NOT NULL,
	[Precio] [numeric](18, 2) NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[IdPelicula] [int] NOT NULL,
    [FechaDevolucion] [datetime] NULL,
 CONSTRAINT [PK_AlquilerPelicula] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]


-- CREAR USUARIO CON VALIDACION DE DOCUMENTO
CREATE PROCEDURE Crear_Usuario
	@User varchar(50),
	@Password varchar(50),
	@Nombre varchar(200),
	@Apellido varchar(200),
	@Nro_Doc varchar(50),
	@Cod_rol int,
	@Activo int
AS
BEGIN

IF EXISTS(SELECT cod_usuario FROM tUsers WHERE nro_doc = @Nro_Doc)
begin
SELECT 'El documento ingresado ya existe'
end
ELSE   
begin
INSERT INTO [dbo].[tUsers]
           ([txt_user]
           ,[txt_password]
           ,[txt_nombre]
           ,[txt_apellido]
           ,[nro_doc]
           ,[cod_rol]
           ,[sn_activo])
     VALUES
           (@User
           ,@Password
           ,@Nombre
           ,@Apellido
           ,@Nro_Doc
           ,@Cod_rol
           ,@Activo)
		   end

END
GO

-- CREAR PELICULA

CREATE PROCEDURE Crear_Pelicula
	@Descripcion varchar(500),
	@cant_disponibles_alquiler int,
	@cant_disponibles_venta int,
	@precio_alquiler numeric(18,2),
	@precio_venta numeric(18,2)
AS
BEGIN
INSERT INTO [dbo].[tPelicula]
           ([txt_desc]
           ,[cant_disponibles_alquiler]
           ,[cant_disponibles_venta]
           ,[precio_alquiler]
           ,[precio_venta])
     VALUES
           (@Descripcion
           ,@cant_disponibles_alquiler
           ,@cant_disponibles_venta
           ,@precio_alquiler
           ,@precio_venta)
END
GO


CREATE PROCEDURE Editar_Pelicula
	@Cod_pelicula int,
	@Descripcion varchar(500),
	@cant_disponibles_alquiler int,
	@cant_disponibles_venta int,
	@precio_alquiler numeric(18,2),
	@precio_venta numeric(18,2)
AS
BEGIN
UPDATE [dbo].[tPelicula]
   SET [txt_desc] = @Descripcion
      ,[cant_disponibles_alquiler] = @cant_disponibles_alquiler
      ,[cant_disponibles_venta] = @cant_disponibles_venta
      ,[precio_alquiler] = @precio_alquiler
      ,[precio_venta] = @precio_venta
 WHERE cod_pelicula =@Cod_pelicula
END
GO


CREATE PROCEDURE Borrar_Pelicula
	@Cod_pelicula int
AS
BEGIN
UPDATE [dbo].[tPelicula]
   SET [cant_disponibles_alquiler] = 0
      ,[cant_disponibles_venta] = 0
 WHERE cod_pelicula =@Cod_pelicula
END
GO


CREATE PROCEDURE Crear_Genero
	@Descripcion varchar(500)
AS
BEGIN

INSERT INTO [dbo].[tGenero]
           ([txt_desc])
     VALUES
           (<@Descripcion)

END
GO



CREATE PROCEDURE Crear_Genero
	@Cod_Genero int,
	@Cod_pelicula int
AS
BEGIN

if EXISTS(select * from tGeneroPelicula where cod_genero=@Cod_Genero and cod_pelicula=@Cod_pelicula)
begin 

INSERT INTO [dbo].[tGeneroPelicula]
           ([cod_pelicula]
           ,[cod_genero])
     VALUES
           (@Cod_pelicula
           ,@Cod_Genero)
end
END
GO



CREATE PROCEDURE Alquilar_Pelicula
	@IdUser int,
	@Precio numeric(18,2),
	@Fecha datetime,
	@IdPelicula int
AS
BEGIN

INSERT INTO [dbo].[AlquilerPelicula]
           ([IdUser]
           ,[Precio]
           ,[Fecha]
           ,[IdPelicula])
     VALUES
           (@IdUser
           ,@Precio
           ,@Fecha
           ,@IdPelicula)

UPDATE [dbo].[tPelicula]
   SET 
      [cant_disponibles_alquiler] = (select cant_disponibles_alquiler -1 from tPelicula where cod_pelicula = @IdPelicula)
 WHERE cod_pelicula=@IdPelicula

END
GO



CREATE PROCEDURE Comprar_Pelicula
	@IdUser int,
	@Precio numeric(18,2),
	@Fecha datetime,
	@IdPelicula int
AS
BEGIN

INSERT INTO [dbo].[CompraPelicula]
           ([IdUser]
           ,[Precio]
           ,[Fecha]
           ,[IdPelicula])
     VALUES
           (@IdUser
           ,@Precio
           ,@Fecha
           ,@IdPelicula)

UPDATE [dbo].[tPelicula]
   SET 
      cant_disponibles_venta = (select cant_disponibles_venta -1 from tPelicula where cod_pelicula = @IdPelicula)
 WHERE cod_pelicula=@IdPelicula

END
GO



CREATE PROCEDURE Stock_alquiler
	@IdPelicula int
AS
BEGIN

Select txt_desc,cant_disponibles_alquiler
FROM tPelicula 
WHERE cod_pelicula = @IdPelicula

END
GO



CREATE PROCEDURE Stock_Venta
	@IdPelicula int
AS
BEGIN

Select txt_desc,cant_disponibles_venta
FROM tPelicula 
WHERE cod_pelicula = @IdPelicula

END
GO


