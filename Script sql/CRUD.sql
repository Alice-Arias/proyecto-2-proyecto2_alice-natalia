--Bases de datos I
--Sistema de Gestion Hotelera
--CRUD de la base de datos

use SistemaGestionHotelera

--------------------
--Tabla Hospedajes
--------------------
--============================================= ============================================= =============================================
--Nombre: RegistrarHospedaje
--Descripción: Este procedimiento almacenado permite registrar un nuevo hospedaje en la base de datos. 
--Recibe como parámetros los datos del hospedaje, como cédula jurídica, nombre, tipo, sitio web (opcional), correo electrónico y referencias GPS.
--Si la inserción es exitosa, retorna el IdHospedaje recién generado.
--Si ocurre un error durante la ejecución, captura y retorna el número y mensaje del error.
--============================================= ============================================= =============================================
create procedure RegistrarHospedaje
    @CedulaJuridica varchar(20),
    @NombreHospedaje varchar(50),
    @TipoHospedaje int,
    @UrlSitioWeb varchar(255) = null,
    @CorreoElectronico varchar(100),
    @ReferenciasGPS varchar(100)
as
begin
    begin try
		insert into Hospedaje
        (CedulaJuridica, NombreHospedaje, TipoHospedaje, UrlSitioWeb, CorreoElectronico, ReferenciasGPS )
    values
        (@CedulaJuridica, @NombreHospedaje, @TipoHospedaje, @UrlSitioWeb, @CorreoElectronico, @ReferenciasGPS )
        select scope_identity() as IdHospedaje --Devuelve el último valor de una columna IDENTITY que fue generado automáticamente en la misma sesión y el mismo bloque de código después de hacer un INSERT.
	end try 
	begin catch 
        -- Captura y devuelve información del error
		select
        error_number() as NumeroError,
        error_message() as MensajeError
	end catch
end

--============================================= ============================================= =============================================
--Nombre: ActualizarInfoHospedaje
--Descripción: Este procedimiento almacenado permite actualizar la información de un hospedaje
--existente en la base de datos. 
--Recibe como parámetros todos los campos relevantes del hospedaje, incluyendo el IdHospedaje para identificarlo.
--En caso de éxito, retorna resultado = 1. Si ocurre un error, captura y retorna el número y mensaje de error.
--============================================= ============================================= =============================================
create procedure ActualizarInfoHospedaje
    @IdHospedaje int,
    @CedulaJuridica varchar(20),
    @NombreHospedaje varchar(50),
    @TipoHospedaje int,
    @UrlSitioWeb varchar(255) = null,
    @CorreoElectronico varchar(100),
    @ReferenciasGPS varchar(100)
as
begin
    begin try 
		update Hospedaje set
            CedulaJuridica = @CedulaJuridica,
            NombreHospedaje = @NombreHospedaje,
            TipoHospedaje = @TipoHospedaje,
            UrlSitioWeb = @UrlSitioWeb,
            CorreoElectronico = @CorreoElectronico,
            ReferenciasGPS = @ReferenciasGPS
        where IdHospedaje = @IdHospedaje
        
		select 1 as resultado --para que el procedimiento salio bien.
    end try
	begin catch
		select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end

--===========================================================================================
--Nombre: EliminarHospedaje
--Descripción: Este procedimiento elimina un hospedaje solo si no tiene reservas activas asociadas
--a sus habitaciones. Una reserva se considera activa si la fecha actual está entre la
--fecha de ingreso (FechaInicio) y la fecha de salida (FechaFin), inclusive.
--
--Si existen reservas activas en alguna de sus habitaciones, no se elimina y lanza error.
--Si no hay reservas activas, elimina en cascada todos los datos relacionados.
--Si la operación es exitosa, retorna resultado = 1.
--En caso de error, se captura y devuelve el número y el mensaje del error.
--===========================================================================================
create procedure EliminarHospedaje
    @IdHospedaje int
as
begin
    begin try
        
        if exists (
            select 1
    from Reservacion r
        inner join Habitacion h on r.IdHabitacion = h.IdHabitacion
    where h.IdHospedaje = @IdHospedaje
        and r.FechaSalida >= CAST(GETDATE() as date)  -- reservas de hoy o futuras
        )
        begin
        raiserror('No se puede eliminar el hospedaje porque tiene reservas activas o futuras asociadas.', 16, 1);
        return;
    end
        -- Borrar fotos relacionadas a tipos de habitación
        delete fh from FotoHabitacion fh
        inner join TipoHabitacion th on fh.IdTipoHabitacion = th.IdTipoHabitacion
        where th.IdHospedaje = @IdHospedaje;

        -- Borrar comodidades de tipos de habitación
        delete ch from ComodidadHabitacion ch
        inner join TipoHabitacion th on ch.IdTipoHabitacion = th.IdTipoHabitacion
        where th.IdHospedaje = @IdHospedaje;

        delete from Habitacion where IdHospedaje = @IdHospedaje;
        delete from TipoHabitacion where IdHospedaje = @IdHospedaje;
        delete from TelefonoHospedaje where IdHospedaje = @IdHospedaje;
        delete from DireccionHospedaje where IdHospedaje = @IdHospedaje;
        delete from ServicioHospedaje where IdHospedaje = @IdHospedaje;
        delete from RedSocialHospedaje where IdHospedaje = @IdHospedaje;
        delete from Hospedaje where IdHospedaje = @IdHospedaje;

        select 1 as Resultado; 
    end try
    begin catch
		select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end;

--===========================================================================================
--INDICES
--Se crean índices para mejorar el rendimiento de las consultas en la tabla Hospedaje,
--agilizando la búsqueda por id, tipo y nombre del hospedaje.
--===========================================================================================
create index IX_Hospedaje_IdHospedaje on Hospedaje(IdHospedaje);
create index IX_Hospedaje_TipoHospedaje on Hospedaje(TipoHospedaje);
create index IX_Hospedaje_NombreHospedaje on Hospedaje(NombreHospedaje);

/* ============================================= ============================================= =============================================
Nombre: VistaHospedajes
Descripción: Vista que muestra información completa de los hospedajes, incluyendo datos principales y el nombre del tipo de hospedaje. 
Combina la tabla Hospedaje con TipoHospedaje para mostrar el nombre del tipo.
============================================= ============================================= =============================================*/
create view VistaHospedajes
as
    select
        h.IdHospedaje,
        h.CedulaJuridica,
        h.NombreHospedaje,
        t.NombreTipoHospedaje,
        h.UrlSitioWeb,
        h.CorreoElectronico,
        h.ReferenciasGPS
    from Hospedaje h
        inner join TipoHospedaje t ON h.TipoHospedaje = t.IdTipoHospedaje;

--============================================= ============================================= =============================================
--Nombre: ConsultarHospedajes
--Descripción: Este procedimiento almacenado permite obtener la lista completa de hospedajes
--desde la tabla Hospedaje, mostrando sus datos principales como IdHospedaje, CedulaJuridica, 
--NombreHospedaje, TipoHospedaje, UrlSitioWeb, CorreoElectronico y ReferenciasGPS.
--No recibe parámetros y retorna todos los registros almacenados.
--============================================= ============================================= =============================================
create procedure ConsultarHospedajes
as
begin
    select *
    from VistaHospedajes;
end

--============================================= ============================================= =============================================
--Nombre: ConsultarHospedajePorId
--Descripción: Este procedimiento almacenado permite obtener la información de un hospedaje 
--específico a partir de su IdHospedaje. 
--Recibe como parámetro el IdHospedaje y retorna los datos correspondientes a ese hospedaje,
--incluyendo CedulaJuridica, NombreHospedaje, TipoHospedaje, UrlSitioWeb, CorreoElectronico y ReferenciasGPS.
-- ============================================= ============================================= =============================================
create procedure ConsultarHospedajePorId
    @IdHospedaje int
as
begin
    select *
    from VistaHospedajes
    where IdHospedaje = @IdHospedaje
end

--============================================= ============================================= =============================================
--Nombre: ConsultarHospedajePorTipo
--Descripción: Este procedimiento almacenado permite obtener una lista de hospedajes filtrados 
--por un tipo específico. 
--Recibe como parámetro el TipoHospedaje y retorna los hospedajes que coinciden con ese tipo.
--============================================= ============================================= =============================================
create procedure ConsultarHospedajePorTipo
    @TipoHospedaje int
as
begin
    select IdHospedaje, CedulaJuridica, NombreHospedaje, TipoHospedaje, UrlSitioWeb, CorreoElectronico, ReferenciasGPS
    from Hospedaje
    where TipoHospedaje = @TipoHospedaje
end

--============================================= ============================================= =============================================
--Nombre: ConsultarHospedajesPorNombre
--Descripción: Este procedimiento almacenado permite buscar hospedajes cuyo nombre contenga
--una cadena específica. 
--Recibe como parámetro @NombreHospedaje y retorna todos los hospedajes cuyo nombre incluya ese texto.
--============================================= ============================================= =============================================
create procedure ConsultarHospeajesPorNombre
    @NombreHospedaje varchar(50)
as
begin
    select *
    from VistaHospedajes
    where NombreHospedaje like '%' + @NombreHospedaje + '%'
end

------------------------------
--Tabla DireccionHospeadaje
------------------------------
--============================================= ============================================= =============================================
--Nombre: RegistrarDireccionHospedaje
--Descripción: Este procedimiento almacenado permite registrar la dirección correspondiente a un hospedaje.
--Recibe como parámetros el IdHospedaje y los datos detallados de la dirección como señas exactas, barrio,
--provincia, cantón y distrito.
--Si la inserción es exitosa, retorna el Id de la dirección recién generado.
--Si ocurre un error durante la ejecución, captura y retorna el número y mensaje del error.
--============================================= ============================================= =============================================
create procedure RegistrarDireccionHospedaje
    @IdHospedaje int,
    @SenasExactas varchar(255),
    @Barrio varchar(100),
    @Provincia int,
    @Canton varchar(50),
    @Distrito varchar(50)
as
begin
    begin try
		insert into DireccionHospedaje
        (IdHospedaje, SenasExactas, Barrio, Provincia, Canton, Distrito)
    values
        ( @IdHospedaje, @SenasExactas, @Barrio, @Provincia, @Canton, @Distrito)
        
		select scope_identity() as IdDireccion
	end try
	begin catch
		select
        error_number() as NumeroError,
        error_message() as MensajeErro
	end catch
end

--============================================= ============================================= =============================================
--Nombre: ActualizarDireccionHospedaje
--Descripción: Permite actualizar los datos de una dirección de hospedaje existente, a partir del IdDireccion.
--Recibe como parámetros las nuevas señas exactas, barrio, provincia, cantón y distrito.
--Si la actualización es exitosa, retorna 1 como resultado.
--En caso de error, captura y retorna el número y mensaje del error.
--============================================= ============================================= =============================================
create procedure ActualizarDireccionHospedaje
    @IdDireccion int,
    @SenasExactas varchar(255),
    @Barrio varchar(100),
    @Provincia int,
    @Canton varchar(50),
    @Distrito varchar(50)
as
begin
    begin try
		update DireccionHospedaje set
            SenasExactas = @SenasExactas,
            Barrio = @Barrio,
            Provincia = @Provincia,
            Canton = @Canton,
            Distrito = @Distrito
		where IdDireccion = @IdDireccion
		select 1 as resultado
    end try
    begin catch
		select
        error_number() as NumeroError,
        error_message() as MensajeErro
	end catch
end

--============================================= ============================================= =============================================
--Nombre: EliminarDireccionHospedaje
--Descripción: Elimina una dirección de hospedaje a partir de su IdDireccion,sin importar si el hospedaje asociado queda sin direcciones.
--Si la eliminación es exitosa, retorna 1.
--Si ocurre un error en tiempo de ejecución, retorna el número y mensaje del error.
--============================================= ============================================= =============================================
create procedure EliminarDireccionHospedaje
    @IdDireccion int
as
begin
    begin try
        --Eliminar la dirección directamente
        delete from DireccionHospedaje
        where IdDireccion = @IdDireccion
        --Retornar resultado exitoso, aunque no exista la direccion se va a retornar 1
        select 1 as Resultado
    end try
    begin catch
        select
        error_number() as NumeroError,
        error_message() as MensajeErro
    end catch
end

--===========================================================================================
--INDICES
--Se crean índices para mejorar el rendimiento de las consultas en la tabla direccionHospedaje,
--agilizando la búsqueda por IdDireccion, IdHospedaje y Provincia.
--===========================================================================================
create index IX_DireccionHospedaje_IdDireccion on DireccionHospedaje(IdDireccion);
create index IX_DireccionHospedaje_IdHospedaje on DireccionHospedaje(IdHospedaje);
create index IX_DireccionHospedaje_IdProvincia on DireccionHospedaje(IdProvincia);

--============================================= ============================================= =============================================
--Nombre: Vista_DireccionesHospedaje
--Descripción: Esta vista muestra todas las direcciones registradas de hospedajes. Incluye datos como:
--Id de la dirección, Id del hospedaje, nombre del hospedaje, señas exactas, barrio, provincia (código y nombre),
--cantón y distrito. Se realiza un JOIN con la tabla Hospedaje y la tabla Provincia para obtener nombres asociados.
--============================================= ============================================= =============================================
create view Vista_DireccionesHospedaje
as
    select
        d.IdDireccion,
        d.IdHospedaje,
        h.NombreHospedaje,
        d.SenasExactas,
        d.Barrio,
        d.Provincia,
        p.NombreProvincia,
        d.Canton,
        d.Distrito
    from DireccionHospedaje d
        inner join Hospedaje h on d.IdHospedaje = h.IdHospedaje
        inner join Provincia p on d.Provincia = p.IdProvincia

--============================================= ============================================= =============================================
--Nombre: ConsultarDireccionesHospedaje
--Descripción: Este procedimiento permite consultar todas las direcciones de hospedajes registradas,
--utilizando la vista 'Vista_DireccionesHospedaje' para retornar información completa, incluyendo nombre del hospedaje
--y nombre de la provincia.
--============================================= ============================================= =============================================
create procedure ConsultarDireccionesHospedaje
as
begin
    select *
    from Vista_DireccionesHospedaje
end

--============================================= ============================================= =============================================
--Nombre: ConsultarDireccionHospedajePorId
--Descripción: Consulta una dirección específica de hospedaje a partir del IdDireccion proporcionado.
--Utiliza la vista 'Vista_DireccionesHospedaje' para devolver la información completa relacionada a la dirección.
--============================================= ============================================= =============================================
create procedure ConsultarDireccionHospedajePorId
    @IdDireccion int
as
begin
    select *
    from Vista_DireccionesHospedaje
    where d.IdDireccion = @IdDireccion
end

--============================================= ============================================= =============================================
--Nombre: ConsultarDireccionPorHospedaje
--Descripción: Consulta la dirección asociada a un hospedaje específico, filtrando por el IdHospedaje.
--Utiliza la vista 'Vista_DireccionesHospedaje' para obtener toda la información relacionada.
--============================================= ============================================= =============================================
create procedure ConsultarDireccionPorHospedaje
    @IdHospedaje int
as
begin
    select *
    from Vista_DireccionesHospedaje
    where d.IdHospedaje = @IdHospedaje
end

------------------------------
--Tabla TelefonoHospedaje
------------------------------
--============================================= ============================================= =============================================
--Nombre: RegistarTelefonoHospedaje
--Descripción: Registra un nuevo número de teléfono y lo asocia a un hospedaje existente.
--Parámetros:
--Si el registro es exitoso, retorna el Id del nuevo teléfono insertado.
--Si ocurre un error en tiempo de ejecución, retorna el número y mensaje del error.
--============================================= ============================================= =============================================
create procedure RegistarTelefonoHospedaje
    @NumeroTelefono varchar(20),
    @IdHospedaje int
as
begin
    begin try
		insert into TelefonoHospedaje
        ( NumeroTelefono, IdHospedaje )
    values
        ( @NumeroTelefono, @IdHospedaje)
        
		select scope_identity() as IdTelefonoHospedaje
    end try
	begin catch
		select
        error_number() as NumeroError,
        error_message() as MensajeErro
	end catch
end

--============================================= ============================================= =============================================
--Nombre: ActualizarTelefonoHospedaje
--Descripción: Actualiza el número telefónico de un registro existente de teléfono de hospedaje.
--Parámetros:
--Si la actualización es exitosa, retorna 1.
--Si ocurre un error en tiempo de ejecución, retorna el número y mensaje del error.
--============================================= ============================================= =============================================
create procedure ActualizarTelefonoHospedaje
    @IdTelefonoHospedaje int,
    @NumeroTelefono varchar(20)
as
begin
    begin try
        update TelefonoHospedaje set NumeroTelefono = @NumeroTelefono
        where IdTelefonoHospedaje = @IdTelefonoHospedaje
        
        select 1 as resultado 
	end try
	begin catch
		select
        error_number() as NumeroError,
        error_message() as MensajeErro
	end catch
end

--============================================= ============================================= =============================================
--Nombre: EliminarTelefonoHospedaje
--Descripción: Elimina un número de teléfono de hospedaje a partir de su IdTelefonoHospedaje.
--Si la eliminación es exitosa, retorna 1.
--Si ocurre un error en tiempo de ejecución, retorna el número y mensaje del error.
--============================================= ============================================= =============================================
create procedure EliminarTelefonoHospedaje
    @IdTelefonoHospedaje int
as
begin
    begin try
		delete from TelefonoHospedaje
        where IdTelefonoHospedaje = @IdTelefonoHospedaje

        select 1 as resultado 
    end try
    begin catch
		select
        error_number() as NumeroError,
        error_message() as MensajeErro
    end catch
end

--===========================================================================================
--INDICES
--Se crean índices para mejorar el rendimiento de las consultas en la tabla TelefonoHospedaje,
--agilizando la búsqueda por IdTelefonoHospedaje y IdHospedaje.
--===========================================================================================
create index IX_TelefonoHospedaje_IdTelefonoHospedaje on TelefonoHospedaje(IdTelefonoHospedaje);
create index IX_TelefonoHospedaje_IdHospedaje on TelefonoHospedaje(IdHospedaje);

--============================================= ============================================= =============================================
--Nombre: Vista_TelefonosHospedaje
--Descripción: Vista que muestra todos los teléfonos registrados junto con el nombre del hospedaje al que pertenecen.
--============================================= ============================================= =============================================
create view Vista_TelefonosHospedaje
as
    select
        t.IdTelefonoHospedaje,
        t.NumeroTelefono,
        t.IdHospedaje,
        h.NombreHospedaje
    from TelefonoHospedaje t
        inner join Hospedaje h on t.IdHospedaje = h.IdHospedaje

--============================================= ============================================= =============================================
--Nombre: ConsultarTelefonosHospedaje
--Descripción: Consulta todos los teléfonos de hospedaje registrados en la base de datos.
--Utiliza la vista Vista_TelefonosHospedaje para incluir información del hospedaje asociado.
--============================================= ============================================= =============================================
create procedure ConsultarTelefonosHospedaje
as
begin
    select *
    from Vista_TelefonosHospedaje
end

--============================================= ============================================= =============================================
--Nombre: ConsultarTelefonoHospedajePorId
--Descripción: Consulta los datos de un teléfono de hospedaje específico por su Id.
--Parámetros:
--  @IdTelefonoHospedaje: identificador del teléfono que se desea consultar.
--Utiliza la vista Vista_TelefonosHospedaje para mostrar la información asociada.
--============================================= ============================================= =============================================
create procedure ConsultarTelefonoHospedajePorId
    @IdTelefonoHospedaje int
as
begin
    select *
    from Vista_TelefonosHospedaje
    where t.IdTelefonoHospedaje = @IdTelefonoHospedaje
end

------------------------------
--Tabla ServicioHospedaje
------------------------------
--============================================= ============================================= =============================================
--Nombre: RegistrarServicioHospedaje
--Descripción: Registra la asociación de un servicio a un hospedaje si no existe previamente.
--Si la relación no existe, la inserta y retorna el nuevo IdServicioHospedaje.
--Si la relación ya existe, retorna -1 para indicar que no se realizó la inserción.
--Si ocurre un error en tiempo de ejecución, retorna el número y mensaje del error.
--============================================= ============================================= =============================================
create procedure RegistrarServicioHospedaje
    @IdHospedaje int,
    @IdServicio int
as
begin
    begin try
		if not exists (select 1
    from ServicioHospedaje
    where IdHospedaje = @IdHospedaje and IdServicio = @IdServicio) 
            begin
        insert into ServicioHospedaje
            ( IdHospedaje, IdServicio)
        values
            ( @IdHospedaje, @IdServicio)

        select scope_identity() as IdServicioHospedaje
    end
        else
            begin
        select -1 as IdServicioHospedaje
    end
	    end try
	    begin catch
		    select
        error_number() as NumeroError,
        error_message() as MensajeErro
    end catch
end

--============================================= ============================================= =============================================
--Nombre: ActualizarServicioHospedaje
--Descripción: Actualiza el IdServicio de una relación ServicioHospedaje existente.
--Evita duplicados: si la nueva combinación ya existe, retorna -1.
--Si la actualización es exitosa, retorna 1.
--Si ocurre un error, retorna el número y mensaje del error.
--============================================= ============================================= =============================================
create procedure ActualizarServicioHospedaje
    @IdServicioHospedaje int,
    @IdHospedaje int,
    @IdServicio int
as
begin
    if exists(
        select 1
        from ServicioHospedaje
        where IdServicioHospedaje = @IdServicioHospedaje
    )
    begin
        update ServicioHospedaje
        set IdHospedaje = @IdHospedaje,
            IdServicio = @IdServicio
        where IdServicioHospedaje = @IdServicioHospedaje;
    end
    else
    begin
        raiserror('No se encontró el registro con el IdServicioHospedaje proporcionado.', 16, 1);
    end
end;

--============================================= ============================================= =============================================
--Nombre: EliminarServicioHospedajePorId
--Descripción: Elimina la asociación entre un hospedaje y un servicio específico.
--Si la eliminación es exitosa, retorna 1.
--Si ocurre un error en tiempo de ejecución, retorna el número y mensaje del error.
--============================================= ============================================= =============================================
create procedure EliminarServicioHospedajePorId
    @IdHospedaje int,
    @IdServicio int
as
begin
    begin try
		delete from ServicioHospedaje
        where IdHospedaje = @IdHospedaje and IdServicio = @IdServicio

		select 1 as resultado
	end try
	begin catch
		select
        error_number() as NumeroError,
        error_message() as MensajeErro
    end catch
end

--===========================================================================================
--INDICES
--Se crean índices para mejorar el rendimiento de las consultas en la tabla ServicioHospedaje,
--agilizando la búsqueda por IdServicio y IdHospedaje.
--===========================================================================================
create nonclustered index idx_ServicioHospedaje_IdHospedaje on ServicioHospedaje(IdHospedaje);
create nonclustered index idx_ServicioHospedaje_IdServicio on ServicioHospedaje(IdServicio);

--============================================= ============================================= =============================================
--Nombre: Vista_ServicioHospedaje
--Descripción: Vista que muestra los servicios asociados a cada hospedaje.
--============================================= ============================================= =============================================
create view Vista_ServicioHospedaje
as
    select
        sh.IdServicioHospedaje,
        sh.IdHospedaje,
        h.NombreHospedaje,
        sh.IdServicio,
        s.NombreServicio,
        s.descripcion
    from ServicioHospedaje sh
        inner join Hospedaje h on sh.IdHospedaje = h.IdHospedaje
        inner join Servicio s on sh.IdServicio = s.IdServicio

--============================================= ============================================= =============================================
--Nombre: ConsultarServiciosHospedajes
--Descripción: Consulta todos los servicios asociados a todos los hospedajes.
--Utiliza la vista Vista_ServicioHospedaje para mostrar la información relacionada.
--============================================= ============================================= =============================================
create procedure ConsultarServiciosHospedajes
as
begin
    select *
    from Vista_ServicioHospedaje
end

--============================================= ============================================= =============================================
--Nombre: ConsultarServiciosPorHospedaje
--Descripción: Consulta todos los servicios asociados a un hospedaje específico.
--Parámetros:
--Utiliza la vista Vista_ServicioHospedaje para mostrar la información detallada.
--============================================= ============================================= =============================================
create procedure ConsultarServiciosPorHospedaje
    @IdHospedaje int
as
begin
    select *
    from Vista_ServicioHospedaje
    where IdHospedaje = @IdHospedaje
end

---------------------------------
--Tabla RedSocialHospedaje
---------------------------------
--============================================= ============================================= =============================================
--Nombre: RegistrarRedSocialHospedaje
--Descripción: Registra una red social asociada a un hospedaje con su nombre de usuario y URL de perfil.
--Verifica que la combinación IdHospedaje e IdRedSocial no exista previamente para evitar duplicados.
--Si la inserción es exitosa, retorna el Id generado (IdRedSocialHospedaje).
--Si la combinación ya existe, retorna -1.
--Si ocurre un error en tiempo de ejecución, retorna el número y mensaje del error.
--============================================= ============================================= =============================================
create procedure RegistrarRedSocialHospedaje
    @IdHospedaje int,
    @IdRedSocial int,
    @NombreUsuario varchar(50),
    @UrlPerfil varchar(255)
as
begin
    begin try
        if not exists (select 1
    from RedSocialHospedaje
    where IdHospedaje = @IdHospedaje and IdRedSocial = @IdRedSocial)
        begin
        insert into RedSocialHospedaje
            ( IdHospedaje, IdRedSocial,NombreUsuario, UrlPerfil)
        values
            ( @IdHospedaje, @IdRedSocial, @NombreUsuario, @UrlPerfil)

        select scope_identity() as IdRedSocialHospedaje
    end 
		else
		begin
        select -1 as IdRedSocialHospedaje
    end
    end try
	begin catch
		select
        error_number() as NumeroError,
        error_message() as MensajeErro
    end catch
end

--============================================= ============================================= =============================================
--Nombre: ActualizarRedSocialHospedaje
--Descripción: Actualiza el nombre de usuario y la URL del perfil de una red social asociada a un hospedaje, identificada por IdRedSocialHospedaje.
--Si la actualización es exitosa, retorna 1.
--Si ocurre un error en tiempo de ejecución, retorna el número y mensaje del error.
-- ============================================= ============================================= =============================================
create procedure ActualizarRedSocialHospedaje
    @IdRedSocialHospedaje int,
    @NombreUsuario varchar(50),
    @UrlPerfil varchar(255)
as
begin
    begin try
        update RedSocialHospedaje set NombreUsuario = @NombreUsuario, UrlPerfil = @UrlPerfil
        where IdRedSocialHospedaje = @IdRedSocialHospedaje
        
		select 1 as resultado
	end try
	begin catch
		select
        error_number() as NumeroError,
        error_message() as MensajeErro
    end catch
end

--============================================= ============================================= =============================================
--Nombre: EliminarRedSocialHospedajePorIds
--Descripción: Elimina la asociación entre un hospedaje y una red social específica.
--Si la eliminación es exitosa, retorna 1.
--Si ocurre un error en tiempo de ejecución, retorna el número y mensaje del error.
--============================================= ============================================= =============================================
create procedure EliminarRedSocialHospedajePorIds
    @IdHospedaje int,
    @IdRedSocial int
as
begin
    begin try
		delete from RedSocialHospedaje
		where  IdHospedaje = @IdHospedaje and IdRedSocial = @IdRedSocial 

        select 1 as resultado
	end try
	begin catch
		select
        error_number() as NumeroError,
        error_message() as MensajeErro
    end catch
end

--===========================================================================================
--INDICES
--Se crean índices para mejorar el rendimiento de las consultas en la tabla RedSocialHospedaje,
--agilizando la búsqueda por IdRedSocialHospedaje, IdHospedaje e IdRedSocial.
--===========================================================================================
create noncloustered index idx_RedSocialHospedaje_IdRedSocial on RedSocialHospedaje(IdRedSocial);
create noncloustered index idx_RedSocialHospedaje_IdHospedaje on RedSocialHospedaje(IdHospedaje);

--============================================= ============================================= =============================================
--Nombre: Vista_RedSocialHospedaje
--Descripción: Vista que muestra la relación entre hospedajes y sus redes sociales, incluyendo información del hospedaje, la red social, el nombre de usuario y la URL del perfil.
--============================================= ============================================= =============================================
create view Vista_RedSocialHospedaje
as
    select
        rsh.IdRedSocialHospedaje,
        rsh.IdHospedaje,
        h.NombreHospedaje,
        rsh.IdRedSocial,
        rs.NombreRedSocial,
        rsh.NombreUsuario,
        rsh.UrlPerfil
    from RedSocialHospedaje rsh
        inner join Hospedaje h on rsh.IdHospedaje = h.IdHospedaje
        inner join RedSocial rs on rsh.IdRedSocial = rs.IdRedSocial

--============================================= ============================================= =============================================
--Nombre: ConsultarRedesSocialesHospedajes
--Descripción: Consulta todas las redes sociales asociadas a los hospedajes.
--============================================= ============================================= =============================================
create procedure ConsultarRedesSocialesHospedajes
as
begin
    select *
    from Vista_RedSocialHospedaje
end

--============================================= ============================================= =============================================
--Nombre: ConsultarHospedajesPorRedSocial
--Descripción: Consulta todos los hospedajes que están asociados a una red social específica.
--Retorna: Todas las filas de la vista Vista_RedSocialHospedaje filtradas por la red social indicada.
--============================================= ============================================= =============================================
create procedure ConsultarHospedajesPorRedSocial
    @IdRedSocial int
as
begin
    select *
    from Vista_RedSocialHospedaje
    where IdRedSocial = @IdRedSocial
end

------------------------------
--Tabla TipoHabitacion
------------------------------
--============================================= ============================================= =============================================
--Nombre: RegistrarTipoHabitacion
--Descripción: Registra un nuevo tipo de habitación para un hospedaje específico, incluyendo el tipo de cama, la capacidad, la descripción y el precio.
--Si es exitoso, devuelve el ID insertado.
--Si ocurre un error, devuelve el número y mensaje del error.
--============================================= ============================================= =============================================
create procedure RegistrarTipoHabitacion
    @NombreTipoHabitacion varchar(50),
    @IdTipoCama int,
    @IdHospedaje int,
    @Capacidad int,
    @descripcion text,
    @Precio decimal(10,2)
as
begin
    begin try
		insert into TipoHabitacion
        ( NombreTipoHabitacion, IdTipoCama,IdHospedaje,Capacidad,descripcion,Precio)
    values
        ( @NombreTipoHabitacion, @IdTipoCama, @IdHospedaje, @Capacidad, @descripcion, @Precio)
        
		select scope_identity() as IdTipoHabitacion
	end try
	begin catch
		select
        error_number() as NumeroError,
        error_message() as MensajeError
	end catch
end

--============================================= ============================================= =============================================
--Nombre: ActualizarTipoHabitacion
--Descripción: Actualiza los datos de una habitación existente como su nombre, tipo de cama, capacidad, descripción y precio.
--Retorna 1 si la actualización fue exitosa.
--En caso de error, retorna el número y mensaje del error.
--============================================= ============================================= =============================================
create procedure ActualizarTipoHabitacion
    @IdTipoHabitacion int,
    @NombreTipoHabitacion varchar(50),
    @IdTipoCama int,
    @Capacidad int,
    @descripcion text,
    @Precio decimal(10,2)
as
begin
    begin try
        update TipoHabitacion set
            NombreTipoHabitacion = @NombreTipoHabitacion,
            IdTipoCama = @IdTipoCama,
            Capacidad = @Capacidad,
            descripcion = @descripcion,
            Precio = @Precio
        where IdTipoHabitacion = @IdTipoHabitacion
        
        select 1 as resultado 
    end try
	begin catch
		select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end

--============================================= ============================================= =============================================
--Nombre: EliminarTipoHabitacion
--Descripción: Elimina un tipo de habitación de la tabla TipoHabitacion basado en su ID. si se eliminó correctamente.
--Si ocurre un error, retorna el número y mensaje del error.
--============================================= ============================================= =============================================
create procedure EliminarTipoHabitacion
    @IdTipoHabitacion int
as
begin
    begin try
    delete from TipoHabitacion
        where IdTipoHabitacion = @IdTipoHabitacion

    select 1 as resultado
    end try
	begin catch
    select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end

--===========================================================================================
--INDICES
--Se crean índices para mejorar el rendimiento de las consultas en la tabla TipoHabitacion,
--agilizando la búsqueda por IdTipoHabitacion, IdHospedaje e IdTipoCama.
--===========================================================================================
create noncloustered index idx_TipoHabitacion_IdTipoHabitacion on TipoHabitacion(IdTipoHabitacion);
create noncloustered index idx_TipoHabitacion_IdHospedaje on TipoHabitacion(IdHospedaje);
create noncloustered index idx_TipoHabitacion_IdTipoCama on TipoHabitacion(IdTipoCama);

--============================================= ============================================= =============================================
--Nombre: Vista_TipoHabitacion
--Descripción: Vista que muestra los tipos de habitación disponibles, combinando información del tipo de cama, hospedaje, capacidad, 
--descripción y precio.
--============================================= ============================================= =============================================
create view Vista_TipoHabitacion
as
    select
        th.IdTipoHabitacion,
        th.NombreTipoHabitacion,
        th.IdTipoCama,
        tc.NombreTipoCama,
        th.IdHospedaje,
        h.NombreHospedaje,
        th.Capacidad,
        th.descripcion,
        th.Precio
    from TipoHabitacion th
        inner join TipoCama tc on th.IdTipoCama = tc.IdTipoCama
        inner join Hospedaje h on th.IdHospedaje = h.IdHospedaje

--============================================= ============================================= =============================================
--Nombre: ConsultarTiposHabitacion
--Descripción: Consulta todos los tipos de habitación disponibles en la vista Vista_TipoHabitacion.
--============================================= ============================================= =============================================
create procedure ConsultarTiposHabitacion
as
begin
    select *
    from Vista_TipoHabitacion
end

--============================================= ============================================= =============================================
--Nombre: ConsultarTipoHabitacionPorId
--Descripción: Consulta un tipo de habitación específico según su identificador.
--============================================= ============================================= =============================================
create procedure ConsultarTipoHabitacionPorId
    @IdTipoHabitacion int
as
begin
    select *
    from Vista_TipoHabitacion
    where IdTipoHabitacion = @IdTipoHabitacion
end

--============================================= ============================================= =============================================
--Nombre: ConsutalarTiposHabitacionPorHospedaje
--Descripción: Consulta todos los tipos de habitación asociados a un hospedaje específico.
--Retorna: Todos los tipos de habitación registrados bajo ese hospedaje.
--============================================= ============================================= =============================================
create procedure ConsutalarTiposHabitacionPorHospedaje
    @IdHospedaje int
as
begin
    select *
    from Vista_TipoHabitacion
    where IdHospedaje = @IdHospedaje
end

----------------------------
--Tabla ComodidadHabitacion
----------------------------
--===============================================================================================
--Nombre: RegistrarComodidadHabitacion
--Descripción: Inserta una nueva relación entre una comodidad y un tipo de habitación,
--validando que no exista previamente. Si ya existe, retorna -1.
--Si ocurre un error, retorna el número y mensaje del error.
--===============================================================================================
create procedure RegistrarComodidadHabitacion
    @IdComodidad int,
    @IdTipoHabitacion int
as
begin
    begin try
		if not exists (select 1
    from ComodidadHabitacion
    where IdComodidad = @IdComodidad and IdTipoHabitacion = @IdTipoHabitacion)
		begin
        insert to
        ComodidadHabitacion
        (IdComodidad,IdTipoHabitacion
        )
        values
        (@IdComodidad,@IdTipoHabitacion)

        select scope_identity() as IdComodidadHabitacion
    end
		else
		begin
        select -1 as IdComodidadHabitacion
    end
    end try
    begin catch
		select
        error_number() as NumeroError,
        error_message() as MensajeError
	end catch
end

--===============================================================================================
--Nombre: ActualizarComodidadHabitacion
--Descripción: Actualiza la relación entre una comodidad y un tipo de habitación en la tabla
--ComodidadHabitacion, identificada por el parámetro @IdComodidadHabitacion. Permite modificar
--tanto la comodidad como el tipo de habitación relacionados.
--===============================================================================================
create procedure ActualizarComodidadHabitacion
    @IdComodidadHabitacion int,
    @IdComodidad int,
    @IdTipoHabitacion int
as
begin
    begin try
        update ComodidadHabitacion
        set IdComodidad = @IdComodidad,
            IdTipoHabitacion = @IdTipoHabitacion
        where IdComodidadHabitacion = @IdComodidadHabitacion

        select 1 as resultado  
    end try
    begin catch
        select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end

--===============================================================================================
--Nombre: EliminarComodidadHabitacion
--Descripción: Elimina una relación específica entre una comodidad y un tipo de habitación,
--===============================================================================================
create procedure EliminarComodidadHabitacion
    @IdComodidadHabitacion int
as
begin
    begin try
		delete from ComodidadHabitacion
        where IdComodidadHabitacion = @IdComodidadHabitacion
        
        select 1 as resultado 
	end try
	begin catch
		select
        error_number() as NumeroError,
        error_message() as MensajeError
	end catch
end

--===========================================================================================
--INDICES
--Se crean índices para mejorar el rendimiento de las consultas en la tabla TipoHabitacion,
--agilizando la búsqueda por IdTipoHabitacion, IdHospedaje e IdTipoCama.
--===========================================================================================
create nonclustered index idx_ComodidadHabitacion_IdComodidad on ComodidadHabitacion(IdComodidad);
create nonclustered index idx_ComodidadHabitacion_IdTipoHabitacion on ComodidadHabitacion(IdTipoHabitacion);

--===============================================================================================
--Nombre: Vista_ComodidadHabitacion
--Descripción: Vista que muestra la relación entre las comodidades y los tipos de habitación,
--información completa y legible sobre las comodidades asociadas a cada tipo de habitación.
--===============================================================================================
create view Vista_ComodidadHabitacion
as
    select
        ch.IdComodidadHabitacion,
        ch.IdComodidad,
        c.NombreComodidad,
        th.Descripcion,
        ch.IdTipoHabitacion,
        th.NombreTipoHabitacion
    from ComodidadHabitacion ch
        inner join Comodidad c on ch.IdComodidad = c.IdComodidad
        inner join TipoHabitacion th on ch.IdTipoHabitacion = th.IdTipoHabitacion

--===============================================================================================
--Nombre: ConsultarComodidadesHabitaciones
--Descripción: Devuelve todas las relaciones entre tipos de habitación y comodidades,
--consultando directamente la vista Vista_ComodidadHabitacion.
--===============================================================================================
create procedure ConsultarComodidadesHabitaciones
as
begin
    select *
    from Vista_ComodidadHabitacion
end

--===============================================================================================
--Nombre: ConsultarComodidadesPorTipoHabitacion
--Descripción: Devuelve todas las comodidades asociadas a un tipo de habitación específico,
--===============================================================================================
create procedure ConsultarComodidadesPorTipoHabitacion
    @IdTipoHabitacion int
as
begin
    select *
    from Vista_ComodidadHabitacion
    where IdTipoHabitacion = @IdTipoHabitacion
end

--------------------------
--Tabla FotoHabitacion
----------------------------===============================================================================================
--Nombre: AgregarFotoHabitacion
--Descripción: Inserta una nueva foto asociada a un tipo de habitación específico.
--Retorna el ID de la nueva foto insertada o el número y mensaje de error si falla.
--===============================================================================================
create procedure AgregarFotoHabitacion
    @IdTipoHabitacion int,
    @Foto image
as
begin
    begin try
		insert into FotoHabitacion
        (IdTipoHabitacion, Foto)
    values(@IdTipoHabitacion, @Foto)

		select scope_identity() as IdFotoHabitacion
	end try
	begin catch
		select
        error_number() as NumeroError,
        error_message() as MensajeError
	end catch
end

--===============================================================================================
--Nombre: ActualizarFotoHabitacion
--Descripción: Actualiza una foto de habitación específica en la tabla FotoHabitacion,
--identificada por el parámetro @IdFotoHabitacion. Retorna 1 si tuvo éxito o muestra el error.
--===============================================================================================
create procedure ActualizarFotoHabitacion
    @IdFotoHabitacion int,
    @Foto image
as
begin
    begin try
		update FotoHabitacion
		set Foto = @Foto
		where @IdFotoHabitacion = @IdFotoHabitacion

		select 1 as resultado
	end try
	begin catch
		select
        error_number() as NumeroError,
        error_message() as MensajeError
	end catch
end

--===============================================================================================
--Nombre: EliminarFotoHabitacion
--Descripción: Elimina una foto de habitación específica de la tabla FotoHabitacion,
--identificada por el parámetro @IdFotoHabitacion. Retorna 1 si tuvo éxito o el error.
--===============================================================================================
create procedure EliminarFotoHabitacion
    @IdFotoHabitacion int
as
begin
    begin try 
		delete from FotaHabitacion
		where @IdFotoHabitacion = @IdFotoHabitacion

		select 1 as resultado
	end try
	begin catch
		select
        error_number() as NumeroError,
        error_message() as MensajeError
	end catch
end

--===============================================================================================
--Nombre: Vista_FotoHabitacion
--Descripción: Vista que muestra las fotos asociadas a cada tipo de habitación. Se extrae
--directamente desde la tabla FotoHabitacion.
--===============================================================================================
create view Vista_FotoHabitacion
as
    select
        IdFotoHabitacion,
        IdTipoHabitacion,
        Foto
    from FotoHabitacion

--===============================================================================================
--Nombre: ConsultarTodasFotosHabitacion
--Descripción: Devuelve todas las fotos de habitaciones registradas, utilizando la vista
--Vista_FotoHabitacion.
--===============================================================================================
create procedure ConsultarTodasFotosHabitacion
as
begin
    select *
    from Vista_FotoHabitacion
end

--===============================================================================================
--Nombre: ConsultarFotosPorTipoHabitacion
--Descripción: Devuelve todas las fotos asociadas a un tipo de habitación específico,
--filtrando por el parámetro @IdTipoHabitacion.
--===============================================================================================
create procedure ConsultarFotosPorTipoHabitacion
    @IdTipoHabitacion int
as
begin
    select *
    from Vista_FotoHabitacion
    where IdTipoHabitacion = @IdTipoHabitacion
end

-------------------
--Tabla Habitacion
-------------------
--================================================================================================
--Nombre: RegistrarHabitacion
--Descripción: Registra una nueva habitación siempre y cuando no exista otra habitación con el 
--mismo número en el mismo hospedaje. Si se inserta exitosamente, retorna el ID de la habitación 
--registrada. Si ya existe, retorna -1. En caso de error, se captura el mensaje.
--================================================================================================
create procedure RegistrarHabitacion
    @NumeroHabitacion int,
    @IdTipoHabitacion int,
    @IdHospedaje int,
    @CantidadPersonas int
as
begin
    begin try
		if not exists (select 1
    from Habitacion
    where NumeroHabitacion = @NumeroHabitacion
        and IdHospedaje = @IdHospedaje)
        begin
        insert into Habitacion
            (NumeroHabitacion,IdTipoHabitacion,IdHospedaje,CantidadPersonas)
        values
            (@NumeroHabitacion, @IdTipoHabitacion, @IdHospedaje, @CantidadPersonas)

        select scope_identity() as IdHabitacion
    end 
		else
		begin
        select -1 as IdHabitacion
    end
	end try
	begin catch
		select
        error_number() as NumeroError,
        error_message() as MensajeError
	end catch
end

--===============================================================================================
--Nombre: ActualizarHabitacion
--Descripción: Actualiza la información de una habitación si no existe otra habitación con el 
--mismo número en el mismo hospedaje. Retorna 1 si se actualizó, -1 si el número ya existe o 
--muestra el error.
--===============================================================================================
create procedure ActualizarHabitacion
    @IdHabitacion int,
    @NumeroHabitacion int,
    @IdTipoHabitacion int,
    @CantidadPersonas int
as
begin
    begin try
        declare @IdHospedaje int --Se utiliza para guardar temporalmente el IdHospedaje 

        --Obtener el IdHospedaje de la habitación actual
        select @IdHospedaje = IdHospedaje
    from Habitacion
    where IdHabitacion = @IdHabitacion
        
        if not exists ( select 1
    from Habitacion
    where NumeroHabitacion = @NumeroHabitacion
        and IdHospedaje = @IdHospedaje
        and IdHabitacion <> @IdHabitacion --que el IdHabitacion sea distinto del que estamos actualizando.
        )
        begin
        update Habitacion
            set NumeroHabitacion = @NumeroHabitacion,
                IdTipoHabitacion = @IdTipoHabitacion,
                CantidadPersonas = @CantidadPersonas
            where IdHabitacion = @IdHabitacion

        select 1 as resultado
    end
        else
        begin
        select -1 as resultado
    end
    end try
    begin catch
        select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end

--===========================================================================================
--Nombre: EliminarHabitacion
--Descripción:Este procedimiento elimina una habitación solo si no tiene reservas activas o futuras.
--Una reserva activa o futura es aquella cuya FechaFin es igual o posterior a la fecha actual.
--Si existen reservas activas o futuras, no elimina y lanza un error.
--Si no existen, elimina la habitación.
--Si la operación es exitosa, retorna resultado = 1.
--===========================================================================================
create procedure EliminarHabitacion
    @IdHabitacion int
as
begin
    begin try
        if exists ( select 1
    from Reservacion
    where IdHabitacion = @IdHabitacion
        and FechaSalida >= cast(getdate() as date))
        begin
        raiserror('No se puede eliminar la habitación porque tiene reservas activas o futuras.', 16, 1);
        return;
    end
        -- Si no tiene reservas, eliminar la habitación
        delete from Habitacion
        where IdHabitacion = @IdHabitacion;

        select 1 as resultado;
    end try
    begin catch
        select
        error_number() as NumeroError,
        error_message() as MensajeError;
    end catch
end

--===========================================================================================
--INDICES
--Se crean índices para mejorar el rendimiento de las consultas en la tabla Habitacion,
--agilizando la búsqueda por IdHabitacion, NumeroHabitacion, IdHospedaje e IdTipoHabitacion.
--===========================================================================================
create nonclustered index idx_Habitacion_IdHabitacion on Habitacion(IdHabitacion);
create nonclustered index idx_Habitacion_IdHospedaje_NumeroHabitacion on Habitacion(IdHospedaje, NumeroHabitacion);
create nonclustered index idx_Habitacion_IdTipoHabitacion on Habitacion(IdTipoHabitacion);

--================================================================================================
--Nombre: Vista_Habitaciones
--Descripción: Vista que muestra información detallada de las habitaciones
--================================================================================================
create view Vista_Habitaciones
as
    select
        h.IdHabitacion,
        h.NumeroHabitacion,
        h.IdTipoHabitacion,
        th.NombreTipoHabitacion,
        h.IdHospedaje,
        hp.NombreHospedaje,
        h.CantidadPersonas
    from Habitacion h
        inner join TipoHabitacion th on h.IdTipoHabitacion = th.IdTipoHabitacion
        inner join Hospedaje hp on h.IdHospedaje = hp.IdHospedaje

--================================================================================================
--Nombre: ConsultarTodasHabitaciones
--Descripción: Devuelve todas las habitaciones registradas en el sistema, utilizando la vista 
--Vista_Habitaciones para presentar la información completa.
--================================================================================================
create procedure ConsultarTodasHabitaciones
as
begin
    select *
    from Vista_Habitaciones
end

--================================================================================================
--Nombre: ConsultarHabitacionPorId
--Descripción: Consulta los detalles de una habitación específica según su ID, mostrando información
--completa gracias a la vista Vista_Habitaciones.
--================================================================================================
create procedure ConsultarHabitacionPorId
    @IdHabitacion int
as
begin
    select *
    from Vista_Habitaciones
    where IdHabitacion = @IdHabitacion
end

--================================================================================================
--Nombre: ConsultarHabitacionesPorHospedaje
--Descripción: Devuelve la lista de habitaciones que pertenecen a un hospedaje específico, 
--ordenadas por número de habitación.
--================================================================================================
create procedure ConsultarHabitacionesPorHospedaje
    @IdHospedaje int
as
begin
    select *
    from Vista_Habitaciones
    where IdHospedaje = @IdHospedaje
    order by NumeroHabitacion
end

----------------
--Tabla Cliente
----------------
--===========================================================================================
--Nombre: RegistrarCliente
--Descripción: Registra un nuevo cliente si no existe previamente en la base de datos.
--Valida que no exista otro cliente con la misma identificación o correo electrónico.
--Si se registra exitosamente, retorna el Id del nuevo cliente.
--Si ya existe la identificación o el correo, retorna -1.
--En caso de error, retorna información del error capturado.
--===========================================================================================
create procedure RegistrarCliente
    @IdentificacionCliente varchar(20),
    @PrimerApellido varchar(50),
    @SegundoApellido varchar(50),
    @Nombre varchar(50),
    @CorreoElectronico varchar(100),
    @FechaNacimiento date,
    @TipoIdentidad int,
    @PaisResidencia int
as
begin
    begin try
		if not exists (select 1
    from Cliente
    where IdentificacionCliente = @IdentificacionCliente)

		begin
        if not exists (select 1
        from Cliente
        where CorreoElectronico = @CorreoElectronico)

            begin
            insert into Cliente
                (IdentificacionCliente,PrimerApellido,SegundoApellido, Nombre,CorreoElectronico, FechaNacimiento,TipoIdentidad,PaisResidencia)
            values
                (@IdentificacionCliente, @PrimerApellido, @SegundoApellido, @Nombre, @CorreoElectronico, @FechaNacimiento, @TipoIdentidad, @PaisResidencia)

            select scope_identity() as IdCliente
        end
			else
			begin
            select -1 as IdCliente
        end
    end
		else
		begin
        select -1 as IdCliente
    end 
	end try
	begin catch
		select
        error_number() as NumeroError,
        error_message() as MensajeError
	end catch
end

--===========================================================================================
--Nombre: ActualizarCliente
--Descripción: Actualiza los datos de un cliente existente.
--Valida que la nueva identificación y correo electrónico no estén repetidos en otro cliente.
--Si la operación es exitosa, retorna resultado = 1.
--Si hay conflicto con identificación, retorna -1.
--Si hay conflicto con correo electrónico, retorna -2.
--===========================================================================================
create procedure ActualizarCliente
    @IdCliente int,
    @IdentificacionCliente varchar(20),
    @PrimerApellido varchar(50),
    @SegundoApellido varchar(50),
    @Nombre varchar(50),
    @CorreoElectronico varchar(100),
    @FechaNacimiento date,
    @TipoIdentidad int,
    @PaisResidencia int
as
begin
    begin try
        if not exists(select 1
    from Cliente
    where IdentificacionCliente = @IdentificacionCliente
        and IdCliente <> @IdCliente)

        begin
        if not exists(select 1
        from Cliente
        where CorreoElectronico = @CorreoElectronico
            and IdCliente <> @IdCliente)

            begin
            update Cliente set
                    IdentificacionCliente = @IdentificacionCliente,
                    PrimerApellido = @PrimerApellido,
                    SegundoApellido = @SegundoApellido,
                    Nombre = @Nombre,
                    CorreoElectronico = @CorreoElectronico,
                    FechaNacimiento = @FechaNacimiento,
                    TipoIdentidad = @TipoIdentidad,
                    PaisResidencia = @PaisResidencia
                where IdCliente = @IdCliente

            select 1 as resultado
        end
            else
            begin
            select -2 as resultado
        end
    end
        else
        begin
        select -1 as resultado
    end
    end try
    begin catch
        select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end

--===========================================================================================
--INDICES
--Se crean índices para mejorar el rendimiento de las consultas en la tabla Cliente,
--agilizando la búsqueda por IdCliente, TipoIdentidad, Nombre, PrimerApellido,
--SegundoApellido y PaisResidencia.
--===========================================================================================
create nonclustered index idx_Cliente_IdCliente on Cliente(IdCliente);
create nonclustered index idx_Cliente_TipoIdentidad on Cliente(TipoIdentidad);
create nonclustered index idx_Cliente_PaisResidencia on Cliente(PaisResidencia);
create nonclustered index idx_Cliente_Nombre on Cliente(Nombre);
create nonclustered index idx_Cliente_PrimerApellido on Cliente(PrimerApellido);
create nonclustered index idx_Cliente_SegundoApellido on Cliente(SegundoApellido);

--===========================================================================================
--Nombre: Vista_Clientes
--Descripción: Vista que muestra la información completa de los clientes,
--incluyendo nombre completo, edad calculada, tipo de identidad y país de residencia.
--Combina datos de las tablas Cliente, TipoIdentidad y Pais para ofrecer
--una vista consolidada con datos legibles y completos.
--===========================================================================================
create view Vista_Clientes
as
    select
        c.IdCliente,
        c.IdentificacionCliente,
        c.PrimerApellido,
        c.SegundoApellido,
        c.Nombre,
        concat(c.Nombre, ' ', c.PrimerApellido, ' ', c.SegundoApellido) as NombreCompleto,
        c.CorreoElectronico,
        c.FechaNacimiento,
        datediff(year, c.FechaNacimiento, getdate()) as Edad,
        c.TipoIdentidad,
        ti.NombreTipoIdentidad,
        c.PaisResidencia,
        p.NombrePais
    from Cliente c
        inner join TipoIdentidad ti on c.TipoIdentidad = ti.IdTipoIdentidad
        inner join Pais p on c.PaisResidencia = p.IdPais

--===========================================================================================
--Nombre: ConsultarTodosClientes
--Descripción: Consulta y devuelve todos los clientes registrados en el sistema,
--utilizando la vista Vista_Clientes para mostrar la información completa y legible.
--===========================================================================================
create procedure ConsultarTodosClientes
as
begin
    select *
    from Vista_Clientes
end

--===========================================================================================
--Nombre: ConsultarClientePorId
--Descripción: Consulta un cliente específico por su IdCliente, utilizando la vista Vista_Clientes.
--Retorna los datos completos del cliente si existe.
--===========================================================================================
create procedure ConsultarClientePorId
    @IdCliente int
as
begin
    select *
    from Vista_Clientes
    where IdCliente = @IdCliente
end

--===========================================================================================
--Nombre: ConsultarClientesPorNombre
--Descripción: Consulta clientes cuyo nombre o apellidos coincidan parcialmente
--con el valor enviado en el parámetro @Busqueda.
--Utiliza LIKE para realizar coincidencias parciales en Vista_Clientes.
--===========================================================================================
create procedure ConsultarClientesPorNombre
    @Busqueda varchar(100)
as
begin
    select *
    from Vista_Clientes
    where c.Nombre like '%' + @Busqueda + '%'
        or c.PrimerApellido like '%' + @Busqueda + '%'
        or c.SegundoApellido like '%' + @Busqueda + '%'
end

--------------------------
--Tabla TelefonoCliente
--------------------------
--===========================================================================================
--Nombre: ResgistrarTelefonoCliente
--Descripción: Procedimiento para registrar un nuevo teléfono para un cliente.
--Valida que el número no exista ya para el cliente antes de insertarlo.
--Retorna el Id del teléfono insertado o -1 si el número ya está registrado.
--===========================================================================================
create procedure ResgistrarTelefonoCliente
    @IdCliente int,
    @NumeroTelefono varchar(20),
    @TipoTelefono varchar(20)
as
begin
    begin try
        if not exists (select 1
    from TelefonoCliente
    where IdCliente = @IdCliente
        and NumeroTelefono = @NumeroTelefono)

        begin
        insert into TelefonoCliente
            (IdCliente,NumeroTelefono,TipoTelefono)
        values
            ( @IdCliente, @NumeroTelefono, @TipoTelefono)

        select scope_identity() as IdTelefonoCliente
    end
        else
        begin
        select -1 as IdTelefonoCliente
    end
    end try
    begin catch
        select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end

--===========================================================================================
--Nombre: ActualizarTelefonoCliente
--Descripción: Actualiza el número y tipo de teléfono de un registro existente.
--Valida que el nuevo número no exista para el mismo cliente en otro registro.
--Retorna 1 si la actualización fue exitosa, -1 si el número ya existe para el cliente.
--En caso de error, devuelve el número y mensaje del error.
--===========================================================================================
create procedure ActualizarTelefonoCliente
    @IdTelefonoCliente int,
    @NumeroTelefono varchar(20),
    @TipoTelefono varchar(20)
as
begin
    begin try
        declare @IdCliente int

        select @IdCliente = IdCliente
    from TelefonoCliente
    where IdTelefonoCliente = @IdTelefonoCliente
        
        if not exists (select 1
    from TelefonoCliente
    where IdCliente = @IdCliente
        and NumeroTelefono = @NumeroTelefono
        and IdTelefonoCliente <> @IdTelefonoCliente)

        begin
        update TelefonoCliente set
                NumeroTelefono = @NumeroTelefono,
                TipoTelefono = @TipoTelefono
        where IdTelefonoCliente = @IdTelefonoCliente

        select 1 as resultado
    end
        else
        begin
        select -1 as resultado
    end
    end try
    begin catch
        select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end

--===========================================================================================
--Nombre: EliminarTelefonoCliente
--Descripción: Elimina un teléfono asociado a un cliente dado su Id.
--Retorna 1 si la eliminación fue exitosa.
--En caso de error, devuelve el número y mensaje del error.
--===========================================================================================
create procedure EliminarTelefonoCliente
    @IdTelefonoCliente int
as
begin
    begin try
        delete from TelefonoCliente
        where IdTelefonoCliente = @IdTelefonoCliente
        
        select 1 as resultado 
    end try
    begin catch
        select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end

--===========================================================================================
--Nombre: Vista_TelefonoCliente
--Descripción: Vista que muestra todos los teléfonos registrados para cada cliente.
--Incluye Id del teléfono, Id del cliente, número de teléfono y tipo de teléfono.
--===========================================================================================
create view Vista_TelefonoCliente
as
    select
        IdTelefonoCliente,
        IdCliente,
        NumeroTelefono,
        TipoTelefono
    from TelefonoCliente

--===========================================================================================
--Nombre: ConsultarTelefonosCliente
--Descripción: Devuelve los teléfonos asociados a un cliente ordenados alfabéticamente por tipo.
--===========================================================================================
create procedure ConsultarTelefonosCliente
    @IdCliente int
as
begin
    select *
    from Vista_TelefonoCliente
    where IdCliente = @IdCliente
    order by TipoTelefono
end

---------------------
--Tabla Reservacion
---------------------
--===========================================================================================
--Nombre: RegistrarReservacion
--Descripción: Registra una nueva reservación si no hay traslape de fechas con la misma habitación.
--Retorna el ID de la reservación si se crea exitosamente, -1 si hay traslape de fechas.
--En caso de error, devuelve el número y mensaje del error.
--===========================================================================================
create procedure RegistrarReservacion
    @Numeroreserva varchar(12),
    @IdHabitacion int,
    @CantidadPersonas int,
    @IdCliente int,
    @FechaIngreso date,
    @Fechasalida date,
    @HoraIngreso time,
    @Horasalida time,
    @PoseeVehiculo bit = 0
as
begin
    begin try
        if not exists (select 1
    from Reservacion
    where IdHabitacion = @IdHabitacion
        and ( (@FechaIngreso between FechaIngreso and Fechasalida)
        or (@Fechasalida between FechaIngreso and Fechasalida)
        or (FechaIngreso between @FechaIngreso and @Fechasalida) ) )
        
        begin
        insert into Reservacion
            (Numeroreserva,IdHabitacion,CantidadPersonas,IdCliente, FechaIngreso,Fechasalida,HoraIngreso,Horasalida,PoseeVehiculo)
        values
            (@Numeroreserva, @IdHabitacion, @CantidadPersonas, @IdCliente, @FechaIngreso, @Fechasalida, @HoraIngreso, @Horasalida, @PoseeVehiculo)

        select scope_identity() as IdReserva
    end
        else
        begin
        select -1 as IdReserva
    end
    end try
    begin catch
        select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end

--===========================================================================================
--Nombre: ActualizarReservacion
--Descripción: Actualiza los datos de una reservación si no hay traslape con otra reservación
--en la misma habitación y fechas.
--Retorna 1 si la actualización fue exitosa, -1 si hay traslape.
--En caso de error, devuelve el número y mensaje del error.
--===========================================================================================
create procedure ActualizarReservacion
    @IdReserva int,
    @IdHabitacion int,
    @CantidadPersonas int,
    @FechaIngreso date,
    @Fechasalida date,
    @HoraIngreso time,
    @Horasalida time,
    @PoseeVehiculo bit
as
begin
    begin try
        if not exists ( select 1
    from Reservacion
    where IdHabitacion = @IdHabitacion
        and IdReserva <> @IdReserva
        and ((@FechaIngreso between FechaIngreso and Fechasalida) or(@Fechasalida between FechaIngreso and Fechasalida) or (FechaIngreso between @FechaIngreso and @Fechasalida)))
        
        begin
        update Reservacion set
                IdHabitacion = @IdHabitacion,
                CantidadPersonas = @CantidadPersonas,
                FechaIngreso = @FechaIngreso,
                Fechasalida = @Fechasalida,
                HoraIngreso = @HoraIngreso,
                Horasalida = @Horasalida,
                PoseeVehiculo = @PoseeVehiculo
            where IdReserva = @IdReserva

        select 1 as resultado
    end
        else
        begin
        select -1 as resultado
    end
    end try
    begin catch
        select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end

--===========================================================================================
--INDICES
--Se crean índices para mejorar el rendimiento de las consultas en la tabla Reservacion,
--agilizando la búsqueda por IdReserva, IdHabitacion, FechaIngreso y Fechasalida.
--===========================================================================================
create nonclustered index idx_Reservacion_IdReserva on Reservacion(IdReserva);
create nonclustered index idx_Reservacion_IdCliente_FechaIngreso on Reservacion(IdCliente, FechaIngreso DESC);
create nonclustered index idx_Reservacion_Fechas on Reservacion(FechaIngreso, Fechasalida);
create nonclustered index idx_Reservacion_IdHabitacion on Reservacion(IdHabitacion);
create nonclustered index idx_Reservacion_IdReserva_IdCliente on Reservacion(IdReserva, IdCliente);

--===========================================================================================
--Nombre: Vista_Reservaciones
--Descripción: Vista que muestra información detallada de las reservaciones, incluyendo
--datos del cliente, habitación, tipo de habitación y hospedaje.
--Calcula el número de noches entre la fecha de ingreso y salida.
--===========================================================================================
create view Vista_Reservaciones
as
    select
        r.IdReserva,
        r.Numeroreserva,
        r.IdHabitacion,
        h.NumeroHabitacion,
        th.NombreTipoHabitacion,
        hp.NombreHospedaje,
        r.CantidadPersonas,
        r.IdCliente,
        c.Nombre + ' ' + c.PrimerApellido as NombreCliente,
        r.FechaIngreso,
        r.Fechasalida,
        datediff(day, r.FechaIngreso, r.Fechasalida) as Noches,
        r.HoraIngreso,
        r.Horasalida,
        r.PoseeVehiculo
    from Reservacion r
        inner join Habitacion h on r.IdHabitacion = h.IdHabitacion
        inner join TipoHabitacion th on h.IdTipoHabitacion = th.IdTipoHabitacion
        inner join Hospedaje hp on h.IdHospedaje = hp.IdHospedaje
        inner join Cliente c on r.IdCliente = c.IdCliente

--===========================================================================================
--Nombre: ConsultarTodasReservaciones
--Descripción: Retorna todas las reservaciones registradas usando la vista Vista_Reservaciones.
--===========================================================================================
create procedure ConsultarTodasReservaciones
as
begin
    select *
    from Vista_Reservaciones
end

--===========================================================================================
--Nombre: ConsultarReservacionPorId
--Descripción: Retorna los datos completos de una reservación dado su Id.
--Utiliza la vista Vista_Reservaciones.
--===========================================================================================
create procedure ConsultarReservacionPorId
    @IdReserva int
as
begin
    select *
    from Vista_Reservaciones
    where IdReserva = @IdReserva
end

--===========================================================================================
--Nombre: ConsultarReservacionesPorCliente
--Descripción: Retorna todas las reservaciones asociadas a un cliente específico.
--Ordena los resultados por la fecha de ingreso en orden descendente.
--===========================================================================================
create procedure ConsultarReservacionesPorCliente
    @IdCliente int
as
begin
    select *
    from Vista_Reservaciones
    where IdCliente = @IdCliente
    order by FechaIngreso desc
end

--===========================================================================================
--Nombre: ConsultarReservacionesPorFecha
--Descripción: Retorna todas las reservaciones cuyo rango de fechas de ingreso o salida
--se encuentra entre las fechas proporcionadas.
--Ordena por fecha de ingreso.
--===========================================================================================
create procedure ConsultarReservacionesPorFecha
    @FechaInicio date,
    @FechaFin date
as
begin
    select *
    from Vista_Reservaciones
    where FechaIngreso between @FechaInicio and @FechaFin
        or Fechasalida between @FechaInicio and @FechaFin
    order by FechaIngreso
end

---------------------
--Tabla Facturacion
---------------------
--===========================================================================================
--Nombre: RegistrarFacturacion
--Descripción: Registra una factura asociada a una reservación, siempre que aún no haya sido facturada.
--Si no se proporcionan la cantidad de noches o el importe total, estos se calculan automáticamente
--con base en las fechas de ingreso y salida, y el precio por noche del tipo de habitación.
--Retorna el ID de la factura generada si el registro fue exitoso, o -1 si ya existía una factura.
--En caso de error, devuelve el número y mensaje del error.
--===========================================================================================
create procedure RegistrarFacturacion
    @NumeroFacturacion varchar(12),
    @IdReserva int,
    @IdTipoPago int,
    @CantidadNoches int = null,
    @ImporteTotal decimal(10,2) = null
as
begin
    begin try
        --Debe existir una reservacion para hacer la factura
        if not exists (select 1
    from Facturacion
    where IdReserva = @IdReserva)
        begin
        --Si no se proporcionan cantidad de noches o importe total, se calculan
        if @CantidadNoches is null or @ImporteTotal is null
        begin
            --Obtener las fechas de ingreso y salida, y el precio por noche del tipo de habitación
            declare @FechaIngreso date, @Fechasalida date, @Precionoche decimal(10,2)

            select
                @FechaIngreso = r.FechaIngreso,
                @Fechasalida = r.Fechasalida,
                @Precionoche = th.Precio
            from Reservacion r
                inner join Habitacion h on r.IdHabitacion = h.IdHabitacion
                inner join TipoHabitacion th on h.IdTipoHabitacion = th.IdTipoHabitacion
            where r.IdReserva = @IdReserva

            --Calcular cantidad de noches y importe total
            set @CantidadNoches = datediff(day, @FechaIngreso, @Fechasalida)
            set @ImporteTotal = @CantidadNoches * @Precionoche
        end

        insert into Facturacion
            ( NumeroFacturacion,IdReserva, FechaEmision, CantidadNoches,ImporteTotal,IdTipoPago )
        values
            (@NumeroFacturacion, @IdReserva, getdate(), @CantidadNoches, @ImporteTotal, @IdTipoPago)

        select scope_identity() as IdFactura
    end
        --Si ya existe una factura para la reservación, retornar -1
        else
        begin
        select -1 as IdFactura
    end
    end try
    begin catch
        select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end

--===========================================================================================
--Nombre: ActualizarFacturacion
--Descripción: Actualiza los datos de facturación (tipo de pago, cantidad de noches, 
--importe total). Si no se proporcionan los valores, se calculan automáticamente según la 
--reservación. Retorna 1 si es exitoso, o muestra el número y mensaje del error.
-- ===========================================================================================
create procedure ActualizarFacturacion
    @IdFactura int,
    @IdTipoPago int,
    @CantidadNoches int = null,
    @ImporteTotal decimal(10,2) = null
as
begin
    begin try
        if @CantidadNoches is null or @ImporteTotal is null

        begin
        declare @FechaIngreso date, @Fechasalida date, @Precionoche decimal(10,2)

        select
            @FechaIngreso = r.FechaIngreso,
            @Fechasalida = r.Fechasalida,
            @Precionoche = th.Precio
        from Facturacion f
            inner join Reservacion r on f.IdReserva = r.IdReserva
            inner join Habitacion h on r.IdHabitacion = h.IdHabitacion
            inner join TipoHabitacion th on h.IdTipoHabitacion = th.IdTipoHabitacion
        where f.IdFactura = @IdFactura

        set @CantidadNoches = datediff(day, @FechaIngreso, @Fechasalida)
        set @ImporteTotal = @CantidadNoches * @Precionoche
    end
        
        update Facturacion set
            IdTipoPago = @IdTipoPago,
            CantidadNoches = @CantidadNoches,
            ImporteTotal = @ImporteTotal
        where IdFactura = @IdFactura
        
        select 1 as resultado 
    end try
    begin catch
        select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end

--===========================================================================================
--INDICES
--Se crean índices para mejorar el rendimiento de las consultas en la tabla Facturacion,
--agilizando la búsqueda por IdFactura, IdReserva y NumeroFacturacion.
--===========================================================================================
create nonclustered index idx_Facturacion_IdFactura on Facturacion(IdFactura);
create nonclustered index idx_Facturacion_IdReserva on Facturacion(IdReserva);
create nonclustered index idx_Facturacion_FechaEmision on Facturacion(FechaEmision);
create nonclustered index idx_Facturacion_IdTipoPago on Facturacion(IdTipoPago);

--===========================================================================================
--Nombre: Vista_Facturacion
--Descripción: Vista que muestra información consolidada de las facturas, incluyendo detalles 
--del cliente, la habitación, el tipo de pago, la reservación y el hospedaje.
--Utilizada para consultas generales y específicas sobre facturación.
--===========================================================================================
create view Vista_Facturacion
as
    select
        f.IdFactura,
        f.NumeroFacturacion,
        f.IdReserva,
        r.Numeroreserva,
        f.FechaEmision,
        f.CantidadNoches,
        f.ImporteTotal,
        f.IdTipoPago,
        tp.NombreTipoPago,
        c.IdCliente,
        c.Nombre + ' ' + c.PrimerApellido as NombreCliente,
        h.NumeroHabitacion,
        hp.NombreHospedaje
    from Facturacion f
        inner join Reservacion r on f.IdReserva = r.IdReserva
        inner join TipoPago tp on f.IdTipoPago = tp.IdTipoPago
        inner join Cliente c on r.IdCliente = c.IdCliente
        inner join Habitacion h on r.IdHabitacion = h.IdHabitacion
        inner join Hospedaje hp on h.IdHospedaje = hp.IdHospedaje

--===========================================================================================
--Nombre: ConsultarTodasFacturas
--Descripción: Devuelve todas las facturas registradas en el sistema usando la vista 
--Vista_Facturacion.
--===========================================================================================
create procedure ConsultarTodasFacturas
as
begin
    select *
    from Vista_Facturacion
end

--===========================================================================================
--Nombre: ConsultarFacturaPorId
--Descripción: Devuelve los detalles de una factura específica, identificada por su ID.
--===========================================================================================
create procedure ConsultarFacturaPorId
    @IdFactura int
as
begin
    select *
    from Vista_Facturacion
    where IdFactura = @IdFactura
end

--===========================================================================================
--Nombre: ConsultarFacturasPorCliente
--Descripción: Devuelve las facturas asociadas a un cliente específico, ordenadas por fecha 
--de emisión en orden descendente.
--===========================================================================================
create procedure ConsultarFacturasPorCliente
    @IdCliente int
as
begin
    select *
    from Vista_Facturacion
    where IdCliente = @IdCliente
    order by FechaEmision desc
end

--===========================================================================================
--Nombre: ConsultarFacturasPorFecha
--Descripción: Devuelve todas las facturas emitidas en un rango específico de fechas.
--Ordena los resultados por la fecha de emisión de forma ascendente.
--===========================================================================================
create procedure ConsultarFacturasPorFecha
    @FechaInicio date,
    @FechaFin date
as
begin
    select *
    from Vista_Facturacion
    where FechaEmision between @FechaInicio and @FechaFin
    order by FechaEmision
end

----------------------------
--Tabla EmpresaRecreativa
----------------------------
-- ===========================================================================================
-- Nombre: Vista_EmpresaRecreativa
-- Descripción: Vista que muestra los datos principales de todas las empresas recreativas
-- registradas en el sistema, incluyendo nombre, cédula jurídica, contacto, encargado y teléfono.
-- Facilita la consulta directa sin exponer la estructura completa de la tabla base.
-- ===========================================================================================
create view Vista_EmpresaRecreativa
as
    select
        IdEmpresaRecreativa,
        CedulaJuridicaEmpresa,
        NombreEmpresas,
        CorreoElectronico,
        NombrePersonal,
        NumeroTelefono
    from EmpresaRecreativa

-- ===========================================================================================
-- Nombre: RegistrarEmpresaRecreativa
-- Descripción: Registra una nueva empresa recreativa, siempre y cuando su cédula jurídica
-- y correo electrónico no estén ya registrados en el sistema.
-- Retorna el ID generado si se registra con éxito, -1 si ya existe la cédula jurídica
-- y -2 si el correo electrónico ya está registrado.
-- En caso de error, devuelve el número y mensaje del error.
-- ===========================================================================================
create procedure RegistrarEmpresaRecreativa
    @CedulaJuridicaEmpresa varchar(20),
    @NombreEmpresas varchar(50),
    @CorreoElectronico varchar(100),
    @NombrePersonal varchar(150),
    @NumeroTelefono varchar(20)
as
begin
    begin try
        if not exists (select 1
    from EmpresaRecreativa
    where CedulaJuridicaEmpresa = @CedulaJuridicaEmpresa)

        begin
        if not exists (select 1
        from EmpresaRecreativa
        where CorreoElectronico = @CorreoElectronico)

            begin
            insert into EmpresaRecreativa
                (CedulaJuridicaEmpresa, NombreEmpresas, CorreoElectronico, NombrePersonal,NumeroTelefono )
            values
                (@CedulaJuridicaEmpresa, @NombreEmpresas, @CorreoElectronico, @NombrePersonal, @NumeroTelefono)

            select scope_identity() as IdEmpresaRecreativa
        end
            else
            begin
            select -2 as IdEmpresaRecreativa
        end
    end
        else
        begin
        select -1 as IdEmpresaRecreativa
    end
    end try
    begin catch
        select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end

-- ===========================================================================================
-- Nombre: ConsultarEmpresasRecreativas
-- Descripción: Devuelve una lista de todas las empresas recreativas registradas,
-- ordenadas alfabéticamente por nombre.
-- ===========================================================================================
create procedure ConsultarEmpresasRecreativas
as
begin
    select *
    from Vista_EmpresaRecreativa
    order by NombreEmpresas
end

-- ===========================================================================================
-- Nombre: ConsultarEmpresaRecreativaPorId
-- Descripción: Consulta los datos de una empresa recreativa específica por su ID.
-- ===========================================================================================
create procedure ConsultarEmpresaRecreativaPorId
    @IdEmpresaRecreativa int
as
begin
    select *
    from Vista_EmpresaRecreativa
    where IdEmpresaRecreativa = @IdEmpresaRecreativa
end

-- ===========================================================================================
-- Nombre: ConsultarEmpresasRecreativasPorNombre
-- Descripción: Busca empresas recreativas cuyo nombre contenga el texto proporcionado,
-- utilizando una búsqueda parcial (`LIKE`). Ordena los resultados alfabéticamente.
-- ===========================================================================================
create procedure ConsultarEmpresasRecreativasPorNombre
    @Nombre varchar(50)
as
begin
    select *
    from Vista_EmpresaRecreativa
    where NombreEmpresas like '%' + @Nombre + '%'
    order by NombreEmpresas
end

-- ===========================================================================================
-- Nombre: ActualizarEmpresaRecreativa
-- Descripción: Actualiza los datos de una empresa recreativa si no existe otra empresa con
-- el mismo correo electrónico. 
-- Retorna 1 si la actualización fue exitosa, -1 si el correo ya está registrado en otra empresa.
-- En caso de error, devuelve el número y mensaje del error.
-- ===========================================================================================
create procedure ActualizarEmpresaRecreativa
    @IdEmpresaRecreativa int,
    @NombreEmpresas varchar(50),
    @CorreoElectronico varchar(100),
    @NombrePersonal varchar(150),
    @NumeroTelefono varchar(20)
as
begin
    begin try
        --Verificar que no exista otra empresa con la misma cedula juridica
        if not exists (select 1
    from EmpresaRecreativa
    where CorreoElectronico = @CorreoElectronico
        and IdEmpresaRecreativa <> @IdEmpresaRecreativa)

        begin
        update EmpresaRecreativa set
                NombreEmpresas = @NombreEmpresas,
                CorreoElectronico = @CorreoElectronico,
                NombrePersonal = @NombrePersonal,
                NumeroTelefono = @NumeroTelefono
            where IdEmpresaRecreativa = @IdEmpresaRecreativa

        select 1 as resultado
    end
        else
        begin
        select -1 as resultado
    end
    end try
    begin catch
        select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end

-- ===========================================================================================
-- Nombre: EliminarEmpresaRecreativa
-- Descripción: Elimina una empresa recreativa si no tiene servicios asociados en la tabla 
-- `Empresaservicio`. 
-- Retorna 1 si la eliminación fue exitosa, -1 si hay dependencias que lo impiden.
-- En caso de error, devuelve el número y mensaje del error.
-- ===========================================================================================
create procedure EliminarEmpresaRecreativa
    @IdEmpresaRecreativa int
as
begin
    begin try
        --Verificar que no existan servicios asociados a la empresa
        if not exists (select 1
    from Empresaservicio
    where IdEmpresaRecreativa = @IdEmpresaRecreativa)
        begin

        delete from EmpresaRecreativa
            where IdEmpresaRecreativa = @IdEmpresaRecreativa

        select 1 as resultado
    end
        else
        begin
        select -1 as resultado
    end
    end try
    begin catch
        select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end


---------------------------
--Tabla Empresaservicio
---------------------------

-- ===========================================================================================
-- Nombre: Vista_EmpresaServicio
-- Descripción: Vista que combina los datos de los servicios ofrecidos por las empresas
-- recreativas con la información del tipo de servicio y la empresa correspondiente.
-- Muestra el ID del servicio ofrecido, su costo adicional, descripción, tipo de servicio,
-- y la empresa asociada.
-- ===========================================================================================
create view Vista_EmpresaServicio
as
    select
        es.IdEmpresaservicio,
        es.CostoAdicional,
        es.descripcion,
        es.IdServicio,
        ts.NombreServicio,
        es.IdEmpresaRecreativa,
        er.NombreEmpresas
    from Empresaservicio es
        inner join TipoServicio ts on es.IdServicio = ts.IdServicio
        inner join EmpresaRecreativa er on es.IdEmpresaRecreativa = er.IdEmpresaRecreativa

-- ===========================================================================================
-- Nombre: RegistrarEmpresaservicio
-- Descripción: Registra un nuevo servicio que ofrece una empresa recreativa.
-- Verifica que no exista previamente la misma combinación de empresa y tipo de servicio.
-- Retorna el ID generado si el registro es exitoso, y -1 si ya existe la combinación.
-- En caso de error, devuelve el número y mensaje del error.
-- ===========================================================================================
create procedure RegistrarEmpresaservicio
    @CostoAdicional decimal(10,2),
    @descripcion text,
    @IdServicio int,
    @IdEmpresaRecreativa int
as
begin
    begin try
        if not exists (select 1
    from Empresaservicio
    where IdServicio = @IdServicio
        and IdEmpresaRecreativa = @IdEmpresaRecreativa)

        begin
        insert into Empresaservicio
            (CostoAdicional,descripcion,IdServicio,IdEmpresaRecreativa)
        values
            ( @CostoAdicional, @descripcion, @IdServicio, @IdEmpresaRecreativa )

        select scope_identity() as IdEmpresaservicio
    end
        else
        begin
        select -1 as IdEmpresaservicio
    end
    end try
    begin catch
        select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end

-- ===========================================================================================
-- Nombre: ConsultarEmpresaservicios
-- Descripción: Devuelve la lista completa de todos los servicios ofrecidos por las empresas
-- recreativas, mostrando información relacionada del servicio y la empresa.
-- ===========================================================================================
create procedure ConsultarEmpresaservicios
as
begin
    select *
    from Vista_EmpresaServicio
end

-- ===========================================================================================
-- Nombre: ConsultarServiciosPorEmpresa
-- Descripción: Devuelve todos los servicios que ofrece una empresa recreativa específica,
-- identificada por su ID.
-- ===========================================================================================
create procedure ConsultarServiciosPorEmpresa
    @IdEmpresaRecreativa int
as
begin
    select *
    from Vista_EmpresaServicio
    where IdEmpresaRecreativa = @IdEmpresaRecreativa
end

-- ===========================================================================================
-- Nombre: ConsultarEmpresasPorServicio
-- Descripción: Devuelve todas las empresas recreativas que ofrecen un tipo de servicio
-- específico, identificado por su ID.
-- ===========================================================================================
create procedure ConsultarEmpresasPorServicio
    @IdServicio int
as
begin
    select *
    from Vista_EmpresaServicio
    where IdServicio = @IdServicio
end

-- ===========================================================================================
-- Nombre: ActualizarEmpresaservicio
-- Descripción: Actualiza los datos de un servicio ofrecido por una empresa recreativa,
-- específicamente el costo adicional y la descripción.
-- Retorna 1 si la actualización es exitosa. En caso de error, devuelve el número y mensaje.
-- ===========================================================================================
create procedure ActualizarEmpresaservicio
    @IdEmpresaservicio int,
    @CostoAdicional decimal(10,2),
    @descripcion text
as
begin
    begin try
        update Empresaservicio set
            CostoAdicional = @CostoAdicional,
            descripcion = @descripcion
        where IdEmpresaservicio = @IdEmpresaservicio
        
        select 1 as resultado 
    end try
    begin catch
        select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end

-- ===========================================================================================
-- Nombre: EliminarEmpresaservicio
-- Descripción: Elimina el registro de un servicio ofrecido por una empresa recreativa.
-- Retorna 1 si se elimina correctamente. En caso de error, devuelve el número y mensaje.
-- ===========================================================================================
create procedure EliminarEmpresaservicio
    @IdEmpresaservicio int
as
begin
    begin try
        delete from Empresaservicio
        where IdEmpresaservicio = @IdEmpresaservicio
        
        select 1 as resultado
    end try
    begin catch
        select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end

---------------------------
--Tabla EmpresaActividad
---------------------------
-- ===========================================================================================
-- Nombre: Vista_EmpresaActividad
-- Descripción: Muestra información detallada de las actividades ofrecidas por las empresas,
--              incluyendo nombre de la actividad y nombre de la empresa.
-- ===========================================================================================
create view Vista_EmpresaActividad
as
    select
        ea.IdEmpresaActividad,
        ea.Precio,
        ea.MaximoParticipantes,
        ea.MinimoParticipantes,
        ea.Duracion,
        ea.descripcion,
        ea.Horarios,
        ea.IdActividad,
        ta.NombreActividad,
        ea.IdEmpresaRecreativa,
        er.NombreEmpresas
    from EmpresaActividad ea
        inner join TipoActividad ta on ea.IdActividad = ta.IdActividad
        inner join EmpresaRecreativa er on ea.IdEmpresaRecreativa = er.IdEmpresaRecreativa

-- ===========================================================================================
-- Nombre: RegistrarEmpresaActividad
-- Descripción: Registra una nueva actividad ofrecida por una empresa recreativa.Si ya existe una relación entre empresa y actividad, retorna -1.
-- De lo contrario, inserta el registro y retorna el ID generado.
-- ===========================================================================================
create procedure RegistrarEmpresaActividad
    @Precio decimal(10,2),
    @MaximoParticipantes int,
    @MinimoParticipantes int,
    @Duracion int,
    @descripcion text = null,
    @Horarios text = null,
    @IdActividad int,
    @IdEmpresaRecreativa int
as
begin
    begin try
        if not exists (select 1
    from EmpresaActividad
    where IdActividad = @IdActividad and IdEmpresaRecreativa = @IdEmpresaRecreativa)

        begin
        insert into EmpresaActividad
            (Precio,MaximoParticipantes,MinimoParticipantes,Duracion,descripcion,Horarios,IdActividad,IdEmpresaRecreativa)
        values
            (@Precio, @MaximoParticipantes, @MinimoParticipantes, @Duracion, @descripcion, @Horarios, @IdActividad, @IdEmpresaRecreativa)

        select scope_identity() as IdEmpresaActividad
    end
        else
        begin
        select -1 as IdEmpresaActividad
    end
    end try
    begin catch
        select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end

-- ===========================================================================================
-- Nombre: ConsultarEmpresaActividades
-- Descripción: Devuelve todas las actividades registradas por las empresas recreativas.
-- ===========================================================================================
create procedure ConsultarEmpresaActividades
as
begin
    select *
    from Vista_EmpresaActividad
end

-- ===========================================================================================
-- Nombre: ConsultarActividadesPorEmpresa
-- Descripción: Devuelve todas las actividades ofrecidas por una empresa específica.
-- ===========================================================================================
create procedure ConsultarActividadesPorEmpresa
    @IdEmpresaRecreativa int
as
begin
    select *
    from Vista_EmpresaActividad
    where IdEmpresaRecreativa = @IdEmpresaRecreativa
end

-- ===========================================================================================
-- Nombre: ConsultarEmpresasPorActividad
-- Descripción: Devuelve todas las empresas que ofrecen una actividad específica.
-- ===========================================================================================
create procedure ConsultarEmpresasPorActividad
    @IdActividad int
as
begin
    select *
    from Vista_EmpresaActividad
    where IdActividad = @IdActividad
end

-- ===========================================================================================
-- Nombre: ConsultarEmpresaActividadPorId
-- Descripción: Devuelve la información completa de una actividad específica registrada
-- por una empresa, usando su ID.
-- ===========================================================================================
create procedure ConsultarEmpresaActividadPorId
    @IdEmpresaActividad int
as
begin
    select *
    from Vista_EmpresaActividad
    where IdEmpresaActividad = @IdEmpresaActividad
end

-- ===========================================================================================
-- Nombre: ActualizarEmpresaActividad
-- Descripción: Actualiza la información de una actividad registrada por una empresa recreativa.
-- Retorna 1 si se actualiza correctamente. En caso de error, devuelve detalles.
-- ===========================================================================================
create procedure ActualizarEmpresaActividad
    @IdEmpresaActividad int,
    @Precio decimal(10,2),
    @MaximoParticipantes int,
    @MinimoParticipantes int,
    @Duracion int,
    @descripcion text = null,
    @Horarios text = null
as
begin
    begin try
        update EmpresaActividad set
            Precio = @Precio,
            MaximoParticipantes = @MaximoParticipantes,
            MinimoParticipantes = @MinimoParticipantes,
            Duracion = @Duracion,
            descripcion = @descripcion,
            Horarios = @Horarios
        where IdEmpresaActividad = @IdEmpresaActividad
        
        select 1 as resultado
    end try
    begin catch
        select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end

-- ===========================================================================================
-- Nombre: EliminarEmpresaActividad
-- Descripción: Elimina el registro de una actividad ofrecida por una empresa recreativa.
-- Retorna 1 si se elimina correctamente. En caso de error, retorna detalles.
-- ===========================================================================================
create procedure EliminarEmpresaActividad
    @IdEmpresaActividad int
as
begin
    begin try
        delete from EmpresaActividad
        where IdEmpresaActividad = @IdEmpresaActividad
        
        select 1 as resultado 
    end try
    begin catch
        select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end

-------------------------
--Tabla DireccionEmpresa
-------------------------
-- ===========================================================================================
-- Nombre: RegistrarDireccionEmpresa
-- Descripción: Registra la dirección de una empresa recreativa. 
-- Si la empresa ya tiene una dirección registrada, retorna -1.
--  De lo contrario, inserta el registro y retorna el ID generado.
-- ===========================================================================================
create procedure RegistrarDireccionEmpresa
    @IdEmpresaRecreativa int,
    @SenasExactas varchar(255),
    @Provincia int,
    @Canton varchar(50),
    @Distrito varchar(50)
as
begin
    begin try
        if not exists (select 1
    from DireccionEmpresa
    where IdEmpresaRecreativa = @IdEmpresaRecreativa)

        begin
        insert into DireccionEmpresa
            ( IdEmpresaRecreativa, SenasExactas, Provincia, Canton, Distrito )
        values
            (@IdEmpresaRecreativa, @SenasExactas, @Provincia, @Canton, @Distrito)

        select scope_identity() as IdDireccionEmpresa
    end
        else
        begin
        select -1 as IdDireccionEmpresa
    end
    end try
    begin catch
        select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end

-- ===========================================================================================
-- Nombre: Vista_DireccionesEmpresas
-- Descripción: Muestra información detallada de las direcciones de empresas recreativas,
-- incluyendo nombre de la empresa y nombre de la provincia.
-- ===========================================================================================
create view Vista_DireccionesEmpresas
as
    select
        de.IdDireccionEmpresa,
        de.IdEmpresaRecreativa,
        er.NombreEmpresas,
        de.SenasExactas,
        de.Provincia,
        p.NombreProvincia,
        de.Canton,
        de.Distrito
    from DireccionEmpresa de
        inner join EmpresaRecreativa er on de.IdEmpresaRecreativa = er.IdEmpresaRecreativa
        inner join Provincia p on de.Provincia = p.IdProvincia

-- ===========================================================================================
-- Nombre: ConsultarDireccionesEmpresas
-- Descripción: Devuelve todas las direcciones registradas de las empresas recreativas.
-- ===========================================================================================
create procedure ConsultarDireccionesEmpresas
as
begin
    select *
    from Vista_DireccionesEmpresas
end

-- ===========================================================================================
-- Nombre: ConsultarDireccionPorEmpresa
-- Descripción: Devuelve la dirección de una empresa recreativa específica.
-- ===========================================================================================
create procedure ConsultarDireccionPorEmpresa
    @IdEmpresaRecreativa int
as
begin
    select *
    from Vista_DireccionesEmpresas
    where de.IdEmpresaRecreativa = @IdEmpresaRecreativa
end

-- ===========================================================================================
-- Nombre: ConsultarEmpresasPorProvincia
-- Descripción: Devuelve todas las empresas recreativas ubicadas en una provincia específica.
-- ===========================================================================================
create procedure ConsultarEmpresasPorProvincia
    @IdProvincia int
as
begin
    select *
    from Vista_DireccionesEmpresas
    where Provincia = @IdProvincia
end

-- ===========================================================================================
-- Nombre: ActualizarDireccionEmpresa
-- Descripción: Actualiza los datos de la dirección de una empresa recreativa.
-- Retorna 1 si se actualiza correctamente. En caso de error, retorna detalles.
-- ===========================================================================================
create procedure ActualizarDireccionEmpresa
    @IdDireccionEmpresa int,
    @SenasExactas varchar(255),
    @Provincia int,
    @Canton varchar(50),
    @Distrito varchar(50)
as
begin
    begin try
        update DireccionEmpresa set
            SenasExactas = @SenasExactas,
            Provincia = @Provincia,
            Canton = @Canton,
            Distrito = @Distrito
        where IdDireccionEmpresa = @IdDireccionEmpresa
        
        select 1 as resultado 
    end try
    begin catch
        select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end

-- ===========================================================================================
-- Nombre: EliminarDireccionEmpresa
-- Descripción: Elimina el registro de la dirección de una empresa recreativa.
-- Retorna 1 si se elimina correctamente. En caso de error, retorna detalles.
-- ===========================================================================================
create procedure EliminarDireccionEmpresa
    @IdDireccionEmpresa int
as
begin
    begin try
        delete from DireccionEmpresa
        where IdDireccionEmpresa = @IdDireccionEmpresa
        
        select 1 as resultado
    end try
    begin catch
        select
        error_number() as NumeroError,
        error_message() as MensajeError
    end catch
end

----------------------------------
--Reportes Nueva Funcionalidad
----------------------------------
--===========================================================================================
--Nombre: Vista_ReporteFacturacion
--Descripción: Vista que muestra información consolidada de facturación,
--Se utiliza para generar reportes específicos.
--===========================================================================================
create view Vista_ReporteFacturacion
as
    select
        F.NumeroFacturacion,
        F.FechaEmision,
        F.CantidadNoches,
        F.ImporteTotal,
        datediff(year, C.FechaNacimiento, getdate()) AS EdadCliente,
        C.Nombre + ' ' + C.PrimerApellido + ' ' + C.SegundoApellido AS NombreCompletoCliente,
        C.IdentificacionCliente,
        tc.NumeroTelefono as TelefonoCliente,
        C.CorreoElectronico as CorreoCliente,
        ho.IdHospedaje,
        ho.NombreHospedaje,
        concat(DH.Barrio, ', ', DH.Distrito, ', ', DH.Canton,', ',p.NombreProvincia) AS UbicacionCompletaHospedaje,
        H.NumeroHabitacion,
        th.IdTipoHabitacion,
        TH.NombreTipoHabitacion,
        TP.NombreTipoPago,
        case --CASE es una estructura condicional que permite evaluar una o varias condiciones y devolver un valor diferente según cuál condición se cumpla
            when r.FechaIngreso <= getdate() and r.Fechasalida >= getdate() then 'En curso'
            when r.FechaIngreso > getdate() THEN 'Futura'
            when r.FechaSalida < getdate() THEN 'Pasada'
            else 'Actual'
        end as EstadoReserva

    from Facturacion f
        inner join Reservacion r on f.IdReserva = r.IdReserva
        inner join Cliente c on r.IdCliente = c.IdCliente
        inner join Habitacion h on r.IdHabitacion = h.IdHabitacion
        inner join TipoHabitacion th on h.IdTipoHabitacion = th.IdTipoHabitacion
        inner join TipoPago tp on f.IdTipoPago = tp.IdTipoPago
        inner join TelefonoCliente tc on C.IdCliente = tc.IdCliente
        inner join Hospedaje ho on h.IdHospedaje = ho.IdHospedaje
        inner join DireccionHospedaje DH on DH.IdHospedaje = ho.IdHospedaje
        inner join Provincia p on p.IdProvincia = DH.Provincia
    where f.ImporteTotal > 0

--===========================================================================================
--Nombre: ReportePorDia
--Descripción: Muestra las facturas emitidas en un día específico para un hospedaje.
--También devuelve el total facturado y la cantidad de facturas del día.
--===========================================================================================
create procedure ReportePorDia
    @DiaReporte int
as
begin

    select *
    from Vista_ReporteFacturacion
    where day(FechaEmision) = @DiaReporte

    select
        sum(ImporteTotal) as TotalImporte,
        @DiaReporte as Dia,
        count(*) as CantidadFacturas
    from Vista_ReporteFacturacion
    where day(FechaEmision) = @DiaReporte
end

--===========================================================================================
--Nombre: ReportePorMes
--Descripción: Muestra las facturas emitidas en un mes específico para un hospedaje.
--También devuelve el total facturado y la cantidad de facturas del mes.
--===========================================================================================
create procedure ReportePorMes
    @MesReporte int
as
begin

    select
        sum(ImporteTotal) as TotalImporte,
        @MesReporte as Mes,
        count(*) as CantidadFacturas
    from Vista_ReporteFacturacion
    where month(FechaEmision) = @MesReporte
end

--===========================================================================================
--Nombre: ReportePorYear
--Descripción: Muestra las facturas emitidas en un año específico para un hospedaje.
--También devuelve el total facturado y la cantidad de facturas del año.
--===========================================================================================
create procedure ReportePorYear
    @YearReporte int
as
begin


    select *
    from Vista_ReporteFacturacion
    where Year(FechaEmision) = @YearReporte

    select
        sum(ImporteTotal) as TotalImporte,
        @YearReporte as Año,
        count(*) as CantidadFacturas
    from Vista_ReporteFacturacion
    where Year(FechaEmision) = @YearReporte

end

--===========================================================================================
--Nombre: ReportePorRangoFechas
--Descripción: Muestra las facturas emitidas en un rango de fechas para un hospedaje.
--También devuelve el total facturado y la cantidad de facturas en ese periodo.
--===========================================================================================
create procedure ReportePorRangoFechas
    @FechaInicioReporte date,
    @FechaFinReporte date
as
begin

    select *
    from Vista_ReporteFacturacion
    where FechaEmision between @FechaInicioReporte and @FechaFinReporte
    order by FechaEmision desc;

    select
        sum(ImporteTotal) as TotalImporte,
        convert(varchar, @FechaInicioReporte, 23) + ' a ' + convert(varchar, @FechaFinReporte, 23) as RangoConsultado,
        count(*) as CantidadFacturas
    from Vista_ReporteFacturacion
    where FechaEmision between @FechaInicioReporte and @FechaFinReporte

end

--===========================================================================================
--Nombre: ReportePorNumeroHabitacion
--Descripción: Muestra las facturas asociadas a un número de habitación específico.
--Incluye el total facturado y la cantidad de facturas agrupadas por habitación.
--===========================================================================================
create procedure ReportePorNumeroHabitacion
    @NumeroHabitacion int
as
begin

    select *
    from Vista_ReporteFacturacion
    where NumeroHabitacion = @NumeroHabitacion
    order by FechaEmision desc;

    select
        NumeroHabitacion,
        count(*) AS CantidadFacturas,
        sum(ImporteTotal) AS TotalFacturado
    from Vista_ReporteFacturacion
    where NumeroHabitacion = @NumeroHabitacion
    group by NumeroHabitacion
    order by  TotalFacturado DESC;

end
