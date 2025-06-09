--Bases de datos I
--Sistema de Gestion Hotelera

--Creacion de la base de datos con la verificacion de que si existe o no la base de datos.
if not exists (select [name] from sys.databases where [name] = N'SistemaGestionHotelera')
begin
	create database SistemaGestionHotelera
end

--Uso de la base de datos
use SistemaGestionHotelera

--Creacion de las tablas catalogo 

---------------------------------------------------------------------------------
--Tabla catalogo Provincia
create table Provincia (
	IdProvincia int identity(1,1) primary key,
	NombreProvincia varchar(50) not null
);

insert into Provincia(NombreProvincia) 
values
	('San Jose'),
	('Alajuela'),
	('Cartago'),
	('Heredia'),
	('Guanacaste'),
	('Puntarenas'),
	('Limon');

--select * from Provincia

---------------------------------------------------------------------------------
--Tabla CargoPersonal
create table CargoPersonal (
    IdCargo int identity(1,1) primary key,
    NombreCargo varchar(100) not null UNIQUE
);

INSERT INTO CargoPersonal (NombreCargo)
VALUES 
('Gerente General'),
('Recepcionista'),
('Jefe de Limpieza'),
('Administrativa'),
('Conserje'),
('Jefe de Cocina'),
('Coordinadora de Eventos'),
('Seguridad'),
('Contadora'),
('Mantenimiento'),
('Gerente de Ventas'),
('Limpieza'),
('Camarero'),
('Jefa de Recepción'),
('Auxiliar Administrativo');

--select * from CargoPersonal

---------------------------------------------------------------------------------
--Tabla catalogo RedSocial
create table RedSocial (
	IdRedSocial int identity(1,1) primary key,
	NombreRedSocial varchar(50) not null
);

insert into RedSocial (NombreRedSocial)
values 
    ('Facebook'),
    ('Instagram'),
    ('Twitter'),
    ('TikTok'),
    ('Snapchat'),
    ('YouTube'),
    ('WhatsApp'),
    ('Telegram')

create nonclustered index idx_RedSocial_IdRedSocial on RedSocial(IdRedSocial);

--select * from RedSocial 

---------------------------------------------------------------------------------
--Tabla catalogo TipoHospedaje
create table TipoHospedaje(
	IdTipoHospedaje int identity(1,1) primary key,
	NombreTipoHospedaje varchar(50) not null
);

insert into TipoHospedaje(NombreTipoHospedaje) 
values
    ('Hotel'),
    ('Hostal'),
    ('Casa'),
    ('Departamento'),
    ('Cuarto compartido'),
	('Camping'),
    ('Albergue'),
    ('Bungalow'),
    ('Casa rural'),
    ('Motel');

--select * from TipoHospedaje

---------------------------------------------------------------------------------
--Tabla catalogo Servicio
create table Servicio(
	IdServicio int identity(1,1) primary key,
	NombreServicio varchar(50) not null,
	Descripcion text not null
);

insert into Servicio(NombreServicio, Descripcion)
values
	('Piscina', 'Piscina disponible para huespedes'),
    ('WiFi', 'Acceso a internet inalambrico'),
    ('Parqueo', 'Estacionamiento disponible'),
    ('Restaurante', 'Restaurante en el establecimiento'),
    ('Bar', 'Bar disponible en el establecimiento'),
    ('Ranch', 'Areas de rancho para actividades'),
    ('Aire acondicionado', 'Habitaciones con aire acondicionado'),
    ('Desayuno incluido', 'Desayuno incluido en la estadia'),
    ('Servicio a la habitacion', 'Room service disponible'),
    ('Gimnasio', 'Area de ejercicio disponible');

create nonclustered index idx_Servicio_IdServicio on Servicio(IdServicio);

--select * from Servicio

---------------------------------------------------------------------------------
--Tabla catalogo TipoCama
create table TipoCama(
	IdTipoCama int identity(1,1) primary key,
	NombreTipoCama varchar(50) not null, 
	Descripcion text not null
);

insert into TipoCama(NombreTipoCama, Descripcion)
values
	('Individual', 'Cama individual (90-100 cm)'),
    ('Matrimonial', 'Cama doble estandar (135-150 cm)'),
    ('Queen', 'Cama queen size (160 cm)'),
    ('King', 'Cama king size (180-200 cm)'),
    ('Super King', 'Cama extra grande (200 cm+)'),
    ('Litera', 'Camas apiladas'),
    ('Sofa cama', 'Sofa que se convierte en cama');

create nonclustered index idx_TipoCama_IdTipoCama on TipoCama(IdTipoCama);

--select * from TipoCama

---------------------------------------------------------------------------------
--Tabla catalogo Comodidad
create table Comodidad(
	IdComodidad int identity(1,1) primary key,
	NombreComodidad varchar(50) not null
);

insert into Comodidad(NombreComodidad)
values
	('WiFi en habitacion'),
    ('Aire acondicionado'),
    ('Ventilador'),
    ('Agua caliente'),
    ('TV pantalla plana'),
    ('Minibar'),
    ('Caja fuerte'),
    ('Telefono'),
    ('Escritorio'),
    ('Tetera/Cafetera'),
    ('Secador de pelo'),
    ('Plancha'),
    ('Baño privado'),
    ('Jacuzzi'),
    ('Balcon');

create nonclustered index idx_Comodidad_IdComodidad on Comodidad(IdComodidad);

--select * from Comodidad

---------------------------------------------------------------------------------
--Tabla catalogo TipoIdentidad
create table TipoIdentidad(
	IdTipoIdentidad int identity(1,1) primary key,
	NombreTipoIdentidad varchar(50) not null,
	Descripcion text not null
);

--Inserts TipoIdentidad
insert into TipoIdentidad(NombreTipoIdentidad, Descripcion) 
values
	('Cedula nacional', 'Documento de identidad nacional para ciudadanos costarricenses'),
	('DIMEX', 'Documento de Identidad Migratorio para Extranjeros residentes en Costa Rica'),
	('Cedula juridica', 'Documento de identidad para empresas y organizaciones legalmente constituidas en Costa Rica'),
	('Pasaporte', 'Documento de identidad internacional para extranjeros'),
	('Cedula de residencia', 'Documento para extranjeros con estatus de residentes permanentes');

create nonclustered index idx_TipoIdentidad_IdTipoIdentidad on TipoIdentidad(IdTipoIdentidad);

--select * from TipoIdentidad

---------------------------------------------------------------------------------
--Tabla Catalogo Pais
create table Pais(
	IdPais int identity(1,1) primary key,
	NombrePais varchar(75) not null,
	CodigoPais varchar(5) not null,
	Abrebiacion varchar(3) not null
);

insert into Pais(NombrePais, CodigoPais, Abrebiacion)
values 
	('Costa Rica', '506', 'CR'),
	('Estados Unidos', '1', 'USA'),
	('Canada', '1', 'CAN'),
	('Mexico', '52', 'MEX'),
	('Panama', '507', 'PAN'),
	('Nicaragua', '505', 'NIC'),
	('El Salvador', '503', 'SLV'),
	('Honduras', '504', 'HND'),
	('Guatemala', '502', 'GTM'),
	('Republica Dominicana', '1', 'DOM'),
	('Cuba', '53', 'CUB'),
	('Jamaica', '1', 'JAM'),
	('España', '34', 'ESP'),
	('Francia', '33', 'FRA'),
	('Alemania', '49', 'DEU'),
	('Reino Unido', '44', 'GBR'),
	('Italia', '39', 'ITA'),
	('Paises Bajos', '31', 'NLD'),
	('Suiza', '41', 'CHE'),
	('Belgica', '32', 'BEL'),
	('Suecia', '46', 'SWE'),
	('Portugal', '351', 'PRT'),
	('Austria', '43', 'AUT'),
	('Irlanda', '353', 'IRL'),
	('Brasil', '55', 'BRA'),
	('Argentina', '54', 'ARG'),
	('Colombia', '57', 'COL'),
	('Chile', '56', 'CHL'),
	('Peru', '51', 'PER'),
	('Ecuador', '593', 'ECU'),
	('Venezuela', '58', 'VEN'),
	('Uruguay', '598', 'URY'),
	('China', '86', 'CHN'),
	('Japon', '81', 'JPN'),
	('Corea del Sur', '82', 'KOR'),
	('Australia', '61', 'AUS'),
	('Nueva Zelanda', '64', 'NZL'),
	('India', '91', 'IND'),
	('Israel', '972', 'ISR'),
	('Emiratos arabes Unidos', '971', 'ARE');

create nonclustered index idx_Pais_IdPais on Pais(IdPais);

--select * from Pais

---------------------------------------------------------------------------------
--Tabla catalogo TipoPago
create table TipoPago(
	IdTipoPago int identity(1,1) primary key,
	NombreTipoPago varchar(50) not null,
);

insert into TipoPago(NombreTipoPago)
values
	('Efectivo'),
    ('Tarjeta credito');

--select * from TipoPago

---------------------------------------------------------------------------------
--Tabla catalogo TipoServicio
create table TipoServicio (
	IdServicio int identity(1,1) primary key, 
	NombreServicio varchar(50) not null,
	Descripcion text not null
);

insert into TipoServicio(NombreServicio, Descripcion)
values
	('Transporte', 'Servicio de transporte incluido'),
    ('Comida', 'Servicio de alimentacion incluido'),
    ('Guia', 'Servicio de guia turistico'),
    ('Equipo', 'Alquiler de equipo especializado'),
    ('Fotografia', 'Servicio fotografico profesional'),
    ('Seguro', 'Seguro de viaje incluido'),
    ('Bebidas', 'Bebidas incluidas'),
    ('Hotel', 'Incluye estadia en hotel'),
    ('Entradas', 'Incluye entradas a atracciones');

--select * from TipoServicio

---------------------------------------------------------------------------------
--Tabla catalogo TipoActividad
create table TipoActividad (
	IdActividad int identity(1,1) primary key not null,
	NombreActividad varchar(50) not null,
	Descripcion text not null
);

insert into TipoActividad(NombreActividad, Descripcion)
values 
	('Tour en bote', 'Paseos recreativos en bote'),
    ('Tour en lancha', 'Paseos en lancha rapida'),
    ('Tour en catamaran', 'Paseos en catamaran'),
    ('Kayak', 'Alquiler o tours en kayak'),
    ('Snorkeling', 'Tour de snorkeling'),
    ('Buceo', 'Tour de buceo'),
    ('Senderismo', 'Tours de senderismo guiados'),
    ('Cabalgata', 'Paseos a caballo'),
    ('Rappel', 'Actividades de rappel'),
    ('Canopy', 'Tours de canopy'),
    ('Observacion de aves', 'Tours de observacion de aves'),
    ('Tour cultural', 'Visitas culturales guiadas');

--select * from TipoActividad

--Creacion de las tablas principales Hospedajes
---------------------------------------------------------------------------------
--Tabla de Hospedaje
create table Hospedaje (
	IdHospedaje int identity(1,1) primary key,
    CedulaJuridica varchar(20) not null check(CedulaJuridica like '[0-9]%' and len(CedulaJuridica) between 10 and 11),
    NombreHospedaje varchar(50) not null,
    TipoHospedaje int not null,
    UrlSitioWeb varchar(255) null check(UrlSitioWeb is null or UrlSitioWeb like 'http%'),
    CorreoElectronico varchar(100) not null unique check(CorreoElectronico like '_%@_%._%'),
    ReferenciasGPS varchar(100) not null,
    constraint FK_TipoHospedaje foreign key (TipoHospedaje) references TipoHospedaje(IdTipoHospedaje)
);

--Se agrega la restriccion de cedula juridica para que inicie con un numero del 1 al 8 y tenga una longitud entre 10 y 11 caracteres
ALTER TABLE Hospedaje
ADD CONSTRAINT chk_CedulaJuridica CHECK (CedulaJuridica LIKE '[1-8]%' AND LEN(CedulaJuridica) BETWEEN 10 AND 11);

insert into Hospedaje (CedulaJuridica, NombreHospedaje, TipoHospedaje, UrlSitioWeb, CorreoElectronico, ReferenciasGPS) 
values
	('3-501-778899', 'Lodge Arenal', 4, 'http://www.lodgearenal.com', 'contacto@lodgearenal.com', '10.4700, -84.7034'),
	('3-101-123456', 'Hotel Buenavista', 1, 'http://www.hotelbuenavista.com', 'reservaciones@hotelbuenavista.com', '9.9281, -84.0907'),
	('3-102-654321', 'Hotel Playa Hermosa', 1, 'http://www.hotelplayahermosa.com', 'info@hotelplayahermosa.com', '10.5667, -85.6833'),
	('3-103-789123', 'Hotel Monteverde', 1, 'http://www.hotelmonteverde.com', 'contacto@hotelmonteverde.com', '10.2705, -84.8248'),
	('3-201-456789', 'Hostel Pura Vida', 2, 'http://www.hostelpuravida.com', 'bookings@hostelpuravida.com', '9.9355, -84.0791'),
	('3-202-987654', 'Hostel Caribe', 2, NULL, 'reservas@hostelarenal.com', '10.4631, -84.7033'),
	('3-301-112233', 'Casa Tropical', 3, 'http://www.casatropical.com', 'info@casatropical.com', '9.9123, -84.0567'),
	('3-401-445566', 'Cabañas del Bosque', 6, NULL, 'cabanas@delbosque.com', '10.3012, -84.8123');

--select * from Hospedaje

---------------------------------------------------------------------------------
--Tabla de DireccionHospedaje
create table DireccionHospedaje (
    IdDireccion int identity(1,1) primary key,
	IdHospedaje int not null,
	SenasExactas varchar(255) not null,
	Barrio varchar(100)not null,
    Provincia int not null,
    Canton varchar(50) not null,
    Distrito varchar(50) not null,
	constraint FK_DireccionHospedaje foreign key (IdHospedaje) references Hospedaje(IdHospedaje),
	constraint FK_ProvinciaHospedaje foreign key (Provincia) references Provincia(IdProvincia)
);

insert into DireccionHospedaje (IdHospedaje, SenasExactas, Barrio, Provincia, Canton, Distrito) 
values
	(1, '100 metros al este del parque central', 'Carmen', 1, 'San Jose', 'Carmen'),
	(2, '200 metros al sur de la playa', 'Playa Hermosa', 5, 'Guanacaste', 'Carrillo'),
	(3, 'A 5 minutos del centro de la ciudad', 'Alajuela Centro', 2, 'Alajuela', 'Alajuela Centro'),
	(4, 'Calle 15, entre avenidas 8 y 10', 'La California', 1, 'San Jose', 'Uruca'),
	(5, '1 km al este del volcan', 'La Fortuna', 2, 'San Carlos', 'La Fortuna'),
	(6, 'A 300 metros del parque central', 'Santa Elena', 5, 'Monteverde', 'Santa Elena'),
	(7, 'Entrada principal del bosque, segunda cabaña', 'Monteverde', 5, 'Monteverde', 'Santa Elena');

--select * from DireccionHospedaje

---------------------------------------------------------------------------------
--Tabla de TelefonoHospedaje
create table TelefonoHospedaje(
	IdTelefonoHospedaje int identity(1,1) primary key,
	NumeroTelefono varchar(20) not null check(NumeroTelefono like '+506%' and NumeroTelefono not like '%[^0-9+ -]%'), --permite el ingreso de n�meros y el caracter + y - para el codigo
	IdHospedaje int not null,
	constraint FK_TelefonoHospedaje foreign key (IdHospedaje) references Hospedaje(IdHospedaje)
);

insert into TelefonoHospedaje (NumeroTelefono, IdHospedaje)
values
	('+506 2222-3333', 1),
	('+506 2222-4444', 1),
	('+506 2654-1234', 2),
	('+506 2645-7890', 3),
	('+506 2233-4455', 4),
	('+506 2479-8080', 5),
	('+506 8877-6655', 6),
	('+506 8345-6789', 7);

--select * from TelefonoHospedaje

---------------------------------------------------------------------------------
--Tabla de ServicioHospedaje
create table ServicioHospedaje (
	IdServicioHospedaje int identity(1,1) primary key,
	IdHospedaje int not null,
	IdServicio int not null,
	constraint FK_ServicioHospedaje foreign key (IdHospedaje) references Hospedaje(IdHospedaje),
	constraint FK_Servicio foreign key (IdServicio) references Servicio(IdServicio)
);

insert into	ServicioHospedaje (IdHospedaje, IdServicio) 
values
	(1, 1), 
	(1, 2), 
	(1, 3), 
	(1, 4), 
	(1, 6), 
	(2, 1), 
	(2, 2), 
	(2, 3), 
	(2, 7), 
	(4, 2), 
	(4, 3),
	(7, 2);

--select * from ServicioHospedaje

---------------------------------------------------------------------------------
--Tabla de RedSocialHospedaje
create table RedSocialHospedaje(
	IdRedSocialHospedaje int identity(1,1) primary key,
	IdHospedaje int not null, 
	IdRedSocial int not null,
	NombreUsuario varchar(50) not null,
	UrlPerfil varchar(255) not null check(UrlPerfil like 'http%'),
	constraint FK_RedSocialHospedaje foreign key (IdHospedaje) references Hospedaje(IdHospedaje),
	constraint FK_RedSocial foreign key (IdRedSocial) references RedSocial(IdRedSocial)
);

insert into RedSocialHospedaje (IdHospedaje, IdRedSocial, NombreUsuario, UrlPerfil)
values 
	(1, 1, 'HotelBuenavistaCR', 'http://www.facebook.com/HotelBuenavistaCR'),
	(1, 2, '@HotelBuenavista', 'http://www.instagram.com/HotelBuenavista'),
	(2, 1, 'PlayaHermosaHotel', 'http://www.facebook.com/PlayaHermosaHotel'),
	(2, 3, '@PHHotelCR', 'http://www.twitter.com/PHHotelCR'),
	(4, 1, 'HostelPuraVida', 'http://www.facebook.com/HostelPuraVida'),
	(4, 2, '@PuraVidaHostel', 'http://www.instagram.com/PuraVidaHostel'),
	(4, 4, '@Reserva', 'http://wa.me/50683456789'),
	(3, 2, '@CabanasDelBosque', 'http://www.instagram.com/CabanasDelBosque');


--select * from RedSocialHospedaje 

---------------------------------------------------------------------------------
--Tabla de PersonalDelHospedaje 
create table PersonalDelHospedaje (
    IdPersonal int identity(1,1) primary key,
    IdHospedaje int not null,
    NombrePersonalCompleto varchar(150) not null,
    IdCargo int not null,
    CorreoElectronico varchar(100) not null unique check(CorreoElectronico like '%_@_%._%'),
    Contrasena varchar(255),
    constraint  FK_PersonalHospedaje foreign key  (IdHospedaje) references Hospedaje(IdHospedaje),
    constraint  FK_CargoPersonal foreign key (IdCargo) references CargoPersonal(IdCargo)
);

insert into PersonalDelHospedaje (IdHospedaje, NombrePersonalCompleto, IdCargo, CorreoElectronico, Contrasena)
values
(1, 'Juan Perez', 1, 'juan.perez@hotel.com', 'Contrasena1'),       
(2, 'Maria Lopez', 2, 'maria.lopez@hotel.com', 'Contrasena2'),       
(3, 'Carlos Gomez', 3, 'carlos.gomez@hotel.com', 'Contrasena3'),     
(1, 'Ana Martinez', 4, 'ana.martinez@hotel.com', 'Contrasena4'),     
(1, 'Luis Fernandez', 5, 'luis.fernandez@hotel.com', 'Contrasena5')

--select * from PersonalDelHospedaje

---------------------------------------------------------------------------------
--Tabla de TipoHabitacion
create table TipoHabitacion(
	IdTipoHabitacion int identity(1,1) primary key,
	NombreTipoHabitacion varchar(50) not null,
	IdTipoCama int not null,
	IdHospedaje int not null,
	Capacidad int not null check(Capacidad > 0),
	Descripcion text not null,
	Precio decimal(10,2) not null check(Precio > 0),
	constraint FK_TipoCamaHabitacion foreign key (IdTipoCama) references TipoCama(IdTipoCama),
	constraint FK_TipoHabitacionHospedaje foreign key (IdHospedaje) references Hospedaje(IdHospedaje)
);

insert into TipoHabitacion (NombreTipoHabitacion, IdTipoCama, IdHospedaje, Capacidad, Descripcion, Precio) 
values
	('Habitacion Estandar', 1, 1, 2, 'Habitacion comoda con cama individual, ideal para viajeros solos', 75.00),
	('Habitacion Doble', 2, 1, 2, 'Habitacion con cama matrimonial, perfecta para parejas', 95.00),
	('Suite Ejecutiva', 4, 1, 3, 'Amplia suite con cama king, sala de estar y amenities de lujo', 150.00),
	('Bungalow Vista Mar', 3, 2, 2, 'Encantador bungalow con cama queen y vista directa al mar', 120.00),
	('Suite Familiar', 5, 2, 4, 'Suite con dos camas individuales, ideal para familias', 180.00),
	('Dormitorio Compartido', 6, 4, 6, 'Amplio dormitorio con literas para 6 personas', 25.00),
	('Habitacion Privada', 1, 4, 1, 'Habitacion privada con cama individual', 40.00),
	('Cabaña Romantica', 3, 7, 2, 'Acogedora cabaña con cama queen y chimenea', 110.00),
	('Cabaña Familiar', 2, 7, 4, 'Amplia caba�-ña con cama matrimonial y litera', 160.00);

--select * from TipoHabitacion

---------------------------------------------------------------------------------
--Tabla de ComodidadHabitacion 
create table ComodidadHabitacion (
	IdComodidadHabitacion int identity(1,1) primary key,
	IdComodidad int not null,
	IdTipoHabitacion int not null,
	constraint FK_ComodidadHabitacion foreign key (IdComodidad) references Comodidad(IdComodidad),
	constraint FK_TipoHabitacionComodidad foreign key (IdTipoHabitacion) references TipoHabitacion(IdTipoHabitacion)
);

insert into ComodidadHabitacion (IdComodidad, IdTipoHabitacion) 
values
	(2, 1), 
	(6, 1), 
	(7, 1),
	(1, 2), 
	(3, 2), 
	(6, 2), 
	(7, 2),
	(1, 3), 
	(3, 3), 
	(4, 3), 
	(5, 3), 
	(6, 3), 
	(7, 3), 
	(9, 3), 
	(1, 4), 
	(3, 4), 
	(6, 4), 
	(7, 4),
	(10, 4),
	(2, 6), 
	(6, 6), 
	(7, 6),
	(2, 8), 
	(6, 8), 
	(7, 8);

--select * from ComodidadHabitacion

---------------------------------------------------------------------------------
--Tabla de FotoHabitacion
create table FotoHabitacion (
	IdFotoHabitacion int identity(1,1) primary key,
	IdTipoHabitacion int not null,
	Foto image not null,
	constraint FK_FotoTipoHabotacion foreign key (IdTipoHabitacion) references TipoHabitacion(IdTipoHabitacion)
);

insert into FotoHabitacion (IdTipoHabitacion, Foto) 
values
	(1, 0x1234567890ABCDEF),
	(1, 0xFEDCBA0987654321),
	(2, 0xABCDEF1234567890),
	(2, 0x0987654321FEDCBA),
	(2, 0x1122334455667788),
	(3, 0x3344556677889900),
	(3, 0xAABBCCDDEEFF0011),
	(3, 0x556677889900AABB),
	(4, 0x6677889900AABBCC),
	(4, 0xDDEEFF0011223344),
	(6, 0x77889900AABBCCDD),
	(8, 0xEEFF001122334455),
	(8, 0x9900AABBCCDDEEFF),
	(8, 0x0011223344556677);

--select * from FotoHabitacion 

---------------------------------------------------------------------------------
--Tabla de Habitacion
create table Habitacion (
	IdHabitacion int identity(1,1) primary key,
	NumeroHabitacion int not null check(NumeroHabitacion > 0),
	IdTipoHabitacion int not null,
	IdHospedaje int not null,
	CantidadPersonas int not null check(CantidadPersonas > 0),
	constraint FK_TipoHabitacion foreign key (IdTipoHabitacion) references TipoHabitacion(IdTipoHabitacion),
	constraint FK_HabitacionHospedaje foreign key (IdHospedaje) references Hospedaje(IdHospedaje)
);

insert into Habitacion (NumeroHabitacion, IdTipoHabitacion, IdHospedaje, CantidadPersonas) 
values 
	(101, 1, 1, 1),  
	(102, 1, 1, 1),
	(201, 2, 1, 2),  
	(202, 2, 1, 2),
	(301, 3, 1, 3), 
	(10, 4, 2, 2),  
	(11, 4, 2, 2),
	(20, 5, 2, 4),
	(1, 6, 4, 6),   
	(2, 6, 4, 6),
	(3, 7, 4, 1),
	(1, 8, 7, 2),   
	(2, 9, 7, 4);

--select * from Habitacion

--Creacion de las tablas principales del sistema
---------------------------------------------------------------------------------
--Tabla de Cliente
create table Cliente (
	IdCliente int identity(1,1) primary key,
	IdentificacionCliente varchar(20) not null,
	PrimerApellido varchar(50) not null,
	SegundoApellido varchar(50) not null,
	Nombre varchar(50) not null,
	CorreoElectronico varchar(100) not null unique check(CorreoElectronico like '%_@_%._%'),
	FechaNacimiento date not null check(FechaNacimiento < getdate()), --para que la fecha de nacimiento no sea futura
	TipoIdentidad int not null,
	PaisResidencia int not null,
	constraint FK_IdTipoIdentidad foreign key (TipoIdentidad) references TipoIdentidad(IdTipoIdentidad),
	constraint FK_PaisResidencia foreign key (PaisResidencia) references Pais(IdPais)
);

insert into Cliente (IdentificacionCliente, PrimerApellido, SegundoApellido, Nombre, CorreoElectronico, FechaNacimiento, TipoIdentidad, PaisResidencia) 
values
	('1-1234-5678', 'Gonzalez', 'Perez', 'Maria', 'maria.gonzalez@email.com', '1985-06-15', 1, 1),
	('1-2345-6789', 'Rodriguez', 'Hernandez', 'Juan', 'juan.rodriguez@email.com', '1990-11-22', 1, 1),
	('1-3456-7890', 'Martinez', 'Lopez', 'Ana', 'ana.martinez@email.com', '1978-03-10', 1, 1),
	('AB123456', 'Smith', 'Johnson', 'John', 'john.smith@email.com', '1982-09-05', 3, 2),
	('CD789012', 'Garcia', 'Fernandez', 'Carlos', 'carlos.garcia@email.com', '1995-07-30', 3, 3),
	('EF345678', 'Brown', 'Vasques', 'Emily', 'emily.brown@email.com', '1992-12-18', 3, 4);

--select * from  Cliente

---------------------------------------------------------------------------------
--Tabla de TelefonoCliente
create table TelefonoCliente (
	IdTelefonoCliente int identity(1,1) primary key,
	IdCliente int not null,
	NumeroTelefono varchar(20) not null check(NumeroTelefono like '+%' and NumeroTelefono not like '%[^0-9+ -]%'),
	TipoTelefono varchar(20) not null check(TipoTelefono in ('Movil', 'Casa', 'Trabajo', 'Otro')),
	constraint FK_TelefonoCliente foreign key (IdCliente) references Cliente(IdCliente)
);

insert into TelefonoCliente (IdCliente, NumeroTelefono, TipoTelefono) 
values
	(1, '+506 8888-9999', 'Movil'),
	(2, '+506 2222-3333', 'Casa'),
	(3, '+506 7777-6666', 'Movil'),
	(4, '+506 6666-5555', 'Movil'),
	(5, '+1 213-555-1234', 'Movil'),
	(6, '+34 91 555 12 34', 'Trabajo')

--select * from  TelefonoCliente

---------------------------------------------------------------------------------
--tabla de DireccionCliente
create table DireccionCliente (
	IdDirreccionCliente int identity(1,1) primary key,
	IdCliente int not null unique, --para que cada cliente solo pueda tener una direccion
	Provincia int null,
	Canton varchar(50) null,
	Distrito varchar(50) null,
	constraint FK_DireccionCliente foreign key (IdCliente) references Cliente(IdCliente),
	constraint FK_ProvinciaCliente foreign key (Provincia) references Provincia(IdProvincia),
	constraint CHK_DireccionCostarricense check((Provincia is null and Canton is null and Distrito is null) or (Provincia is not null and Canton is not null and Distrito is not null))
);

insert into DireccionCliente (IdCliente, Provincia, Canton, Distrito) 
values
	(1, 1, 'San Jose', 'Carmen'),
	(2, 1, 'Escazu', 'San Rafael'),
	(3, 2, 'Alajuela', 'Alajuela Centro'),
	(4, NULL, NULL, NULL),
	(5, NULL, NULL, NULL),
	(6, NULL, NULL, NULL);

--select * from  DireccionCliente

--Creacion de las tablas Reservacion y Facturacion
---------------------------------------------------------------------------------
--Tabla de Reservacion
create table Reservacion (
	IdReserva int identity(1,1) primary key,
	NumeroReserva varchar(12) not null unique,
	IdHabitacion int not null,
	CantidadPersonas int not null check(CantidadPersonas > 0),
	IdCliente int not null,
	FechaIngreso date not null check(FechaIngreso >= cast(getdate() as date)),--se valida que la fecha de ingreso este en una fecha valida
	FechaSalida  date not null,
	HoraIngreso time not null, 
	HoraSalida time not null check(HoraSalida <= '12:00:00'),--se valida que la hora de salida sea antes o a las 12:00
	PoseeVehiculo Bit not null default 0,
	constraint Ck_validacionFechas check((FechaIngreso <= FechaSalida)), --se valida que la fecha de ingreso sea menor que la de salida
	constraint FK_ReservaHabitacion foreign key (IdHabitacion) references Habitacion(IdHabitacion),
	constraint FK_ReservaCliente foreign key (IdCliente) references Cliente(IdCliente)
);


insert into Reservacion (NumeroReserva, IdHabitacion, CantidadPersonas, IdCliente, FechaIngreso, FechaSalida, HoraIngreso, HoraSalida, PoseeVehiculo)
values 
	('RES250115001', 1, 1, 1, '2025-08-05', '2025-08-08', '15:00:00', '11:00:00', 0),
	('RES250119002', 3, 2, 2, '2025-08-10', '2025-08-14', '14:00:00', '10:30:00', 1),
	('RES250208003', 5, 3, 3, '2025-08-15', '2025-08-22', '16:00:00', '12:00:00', 1),
	('RES250205004', 6, 2, 4, '2025-08-23', '2025-08-28', '13:00:00', '11:45:00', 0),
	('RES250318005', 7, 4, 5, '2025-08-29', '2025-09-04', '12:00:00', '10:00:00', 0);

--select * from  Reservacion

---------------------------------------------------------------------------------
--Tabla de Facturacion
create table Facturacion (
	IdFactura int identity(1,1) primary key,
	NumeroFacturacion varchar(12),
	IdReserva int not null unique,
	FechaEmision  date not null default cast(getdate() as date),-- que la fecha sea por omision la fecha actual
	CantidadNoches int null,
	ImporteTotal decimal(10,2) null,
	IdTipoPago int not null,
	constraint FK_ReservaFacturada foreign key (IdReserva) references Reservacion(IdReserva),
	constraint FK_MetodoPago foreign key (IdTipoPago) references TipoPago(IdTipoPago)
);

insert into Facturacion (NumeroFacturacion,IdReserva,CantidadNoches, ImporteTotal, IdTipoPago)
values 
	('FAC250115001',6, datediff(day, '2025-01-15', '2025-01-19'), 4 * 75.00, 2),
	('FAC250119002',2, datediff(day, '2025-01-19', '2025-01-23'), 4 * 95.00, 1),
	('FAC250208003',3, datediff(day, '2025-02-01', '2025-02-08'), 7 * 150.00, 1),
	('FAC250205004',4, datediff(day, '2025-02-05', '2025-02-11'), 6 * 120.00, 2),
	('FAC250318005',5, datediff(day, '2025-03-12', '2025-03-18'), 6 * 25.00, 2);

--select * from  Facturacion

--Creacion de las tablas de Empresas Recreativas
---------------------------------------------------------------------------------
--Tabla de EmpresaRecreativa
create table EmpresaRecreativa (
	IdEmpresaRecreativa int identity(1,1) primary key,
	CedulaJuridicaEmpresa varchar(20) not null check(CedulaJuridicaEmpresa like '%[1-8]%' and len(CedulaJuridicaEmpresa) between 10 and 20),
	NombreEmpresas varchar(50) not null,
	CorreoElectronico varchar(100) not null unique check(CorreoElectronico like '%@%.%'),--correo que sea unico
	NombrePersonal varchar(150) not null, 
	NumeroTelefono varchar(20) not null check(NumeroTelefono like '+506%' and NumeroTelefono not like '%[^0-9+ -]%') --permite el ingreso de numeros y el caracter + y - para el codigo
);

insert into EmpresaRecreativa (CedulaJuridicaEmpresa, NombreEmpresas, CorreoElectronico, NombrePersonal, NumeroTelefono)
values
	('3-101-234567', 'Caribe Aventura', 'info@caribeaventura.com', 'Roberto Mendez', '+506 2758-1234'),
	('3-102-345678', 'EcoTours Cahuita', 'reservas@ecotourscahuita.com', 'Maria Fern�ndez', '+506 2755-5678'),
	('3-103-456789', 'Dive Limon', 'contact@divelimon.com', 'Carlos Rodriguez', '+506 2750-9012'),
	('3-104-567890', 'Canopy del Caribe', 'aventuras@canopycaribe.com', 'Ana Vargas', '+506 2756-3456');


--select * from  EmpresaRecreativa 

---------------------------------------------------------------------------------
--Tabla de PersonalDeEmpresaRecreativa
create table PersonalDeEmpresaRecreativa  (
	IdPersonal int identity(1,1) primary key,
	IdEmpresaRecreativa int not null,
	NombrePersonalCompleto varchar(150) not null,
	Cargo varchar(50) not null,
	CorreoElectronico varchar(100) not null unique check(CorreoElectronico like '%_@_%._%'),
	Contrasena varchar(255),
	constraint FK_PersonalIdEmpresaRecreativa foreign key (IdEmpresaRecreativa) references EmpresaRecreativa(IdEmpresaRecreativa)
);

insert into PersonalDeEmpresaRecreativa  (IdEmpresaRecreativa, NombrePersonalCompleto, Cargo, CorreoElectronico, Contrasena)
values
(1, 'Juan Perez', 'Gerente General', 'juan.perez@hotel.com', 'Contrasena1'),
(1, 'Maria Lopez', 'Recepcionista', 'maria.lopez@hotel.com', 'Contrasena2'),
(1, 'Carlos Gomez', 'Jefe de Limpieza', 'carlos.gomez@hotel.com', 'Contrasena3'),
(1, 'Ana Martinez', 'Administrativa', 'ana.martinez@hotel.com', 'Contrasena4'),
(1, 'Luis Fernandez', 'Conserje', 'luis.fernandez@hotel.com', 'Contrasena5'),

(2, 'Sofia Ramirez', 'Recepcionista', 'sofia.ramirez@hotel.com', 'Contrasena6'),
(2, 'Miguel Torres', 'Jefe de Cocina', 'miguel.torres@hotel.com', 'Contrasena7'),
(2, 'Paula Castillo', 'Coordinadora de Eventos', 'paula.castillo@hotel.com', 'Contrasena8'),
(2, 'Ricardo Diaz', 'Seguridad', 'ricardo.diaz@hotel.com', 'Contrasena9'),
(2, 'Laura Herrera', 'Contadora', 'laura.herrera@hotel.com', 'Contrasena10'),

(3, 'Jorge Morales', 'Mantenimiento', 'jorge.morales@hotel.com', 'Contrasena11'),
(3, 'Claudia Vargas', 'Recepcionista', 'claudia.vargas@hotel.com', 'Contrasena12'),
(3, 'Pedro Alvarez', 'Gerente de Ventas', 'pedro.alvarez@hotel.com', 'Contrasena13'),
(3, 'Elena Soto', 'Limpieza', 'elena.soto@hotel.com', 'Contrasena14'),
(3, 'Andres Rubio', 'Camarero', 'andres.rubio@hotel.com', 'Contrasena15'),

(4, 'Isabel Cruz', 'Jefa de Recepción', 'isabel.cruz@hotel.com', 'Contrasena16'),
(4, 'Daniel Morales', 'Auxiliar Administrativo', 'daniel.morales@hotel.com', 'Contrasena17'),
(4, 'Natalia Vargas', 'Recepcionista', 'natalia.vargas@hotel.com', 'Contrasena18'),
(4, 'Felipe Castillo', 'Conserje', 'felipe.castillo@hotel.com', 'Contrasena19'),
(4, 'Gabriela Mendez', 'Administrativa', 'gabriela.mendez@hotel.com', 'Contrasena20');

--select * from PersonalDeEmpresaRecreativa 

---------------------------------------------------------------------------------
--Tabla de EmpresaServicio
create table EmpresaServicio(
	IdEmpresaServicio int identity(1,1) primary key,
	CostoAdicional decimal(10,2) null,
	Descripcion text not null,
	IdServicio int not null,
	IdEmpresaRecreativa int not null,
	constraint FK_ServicioEmpresa foreign key (IdServicio) references TipoServicio(IdServicio),
	constraint FK_EmpresaRecreativaServicio foreign key (IdEmpresaRecreativa) references EmpresaRecreativa(IdEmpresaRecreativa)
);

insert into EmpresaServicio (CostoAdicional, Descripcion, IdServicio, IdEmpresaRecreativa)
values 
	(15.00, 'Transporte desde hoteles en Limon centro', 1, 1),
	(25.00, 'Almuerzo tipico caribeño incluido', 2, 1),
	(10.00, 'Guia bilingue (español/ingles)', 3, 1),
	(0.00, 'Equipo de snorkeling incluido', 4, 2),
	(20.00, 'Fotografo profesional durante el tour', 5, 2),
	(0.00, 'Todo el equipo de buceo incluido', 4, 3),
	(15.00, 'Seguro de viaje para actividades acuaticas', 6, 3),
	(10.00, 'Bebidas refrescantes despues del tour', 7, 3),
	(0.00, 'Equipo de seguridad profesional incluido', 4, 4),
	(12.00, 'Transporte desde Puerto Viejo', 1, 4);

--select * from  EmpresaServicio

---------------------------------------------------------------------------------
--Tabla de EmpresaActividad
create table EmpresaActividad(
	IdEmpresaActividad int identity(1,1) primary key,
	precio decimal(10,2) not null check(Precio > 0),
	MaximoParticipantes int not null check(MaximoParticipantes > 0),
	MinimoParticipantes int not null check(MinimoParticipantes > 0),
	Duracion int not null check(Duracion > 0),
	Descripcion text null,
	Horarios text null,
	IdActividad int not null,
	IdEmpresaRecreativa int not null,
	constraint FK_actividadEmpresa foreign key (IdActividad) references TipoActividad(IdActividad),
	constraint FK_EmpresaRecreativaActividad foreign key (IdEmpresaRecreativa) references EmpresaRecreativa(IdEmpresaRecreativa),
	constraint CHK_MaxMinParticipantes check(MinimoParticipantes <= MaximoParticipantes)
);

insert into EmpresaActividad (precio, MaximoParticipantes, MinimoParticipantes, Duracion, Descripcion, Horarios, IdActividad, IdEmpresaRecreativa)
values 
	(65.00, 12, 4, 120, 'Tour en bote por los canales de Tortuguero con avistamiento de vida silvestre', 'Lunes a Sabado: 8:00 am y 1:00 pm', 1, 1),
	(85.00, 8, 2, 180, 'Tour en lancha rapida hacia Punta Uva con parada para snorkeling', 'Todos los dias: 9:00 am', 2, 1),
	(45.00, 15, 1, 90, 'Tour de snorkeling en el arrecife de Cahuita', 'Martes a Domingo: 8:00 am y 2:00 pm', 5, 2),
	(30.00, 20, 1, 120, 'Senderismo guiado por el Parque Nacional Cahuita', 'Todos los dias: 7:00 am y 3:00 pm', 7, 2),
	(120.00, 6, 2, 240, 'Tour de buceo en el arrecife de Manzanillo', 'Lunes, Miercoles, Viernes: 7:30 am', 6, 3),
	(75.00, 10, 1, 180, 'Curso de snorkeling para principiantes', 'Todos los dias: 10:00 am', 5, 3),
	(55.00, 8, 2, 150, 'Tour de canopy por la selva con 12 plataformas', 'Todos los dias: 8:00 am, 11:00 am, 2:00 pm', 10, 4),
	(40.00, 12, 4, 90, 'Tour de observacion de aves en la reserva privada', 'Martes a Domingo: 6:00 am y 4:00 pm', 11, 4);

--select * from  EmpresaActividad

---------------------------------------------------------------------------------
--Tabla de DireccionEmpresa
create table DireccionEmpresa (
    IdDireccionEmpresa int identity(1,1) primary key,
	IdEmpresaRecreativa int not null,
	SenasExactas varchar(255) not null,
    Provincia int not null,
    Canton varchar(50) not null,
    Distrito varchar(50) not null,
	constraint FK_DireccionEmpresaRecreativa foreign key (IdEmpresaRecreativa) references EmpresaRecreativa(IdEmpresaRecreativa),
	constraint FK_ProvinciaEmpresa foreign key (Provincia) references Provincia(IdProvincia)
);

insert into DireccionEmpresa (IdEmpresaRecreativa, SenasExactas, Provincia, Canton, Distrito)
values 
	(1, '200 metros oeste del muelle principal', 7, 'Limon', 'Limon'),
	(2, 'Frente a la entrada principal del Parque Nacional Cahuita', 7, 'Talamanca', 'Cahuita'),
	(3, '50 metros norte del Supermercado Puerto Viejo', 7, 'Talamanca', 'Puerto Viejo'),
	(4, '3 km al sur de la entrada a Veragua Rainforest', 7, 'Limon', 'Matama');

--select * from  DireccionEmpresa
---------------------------------------------------------------------------------


