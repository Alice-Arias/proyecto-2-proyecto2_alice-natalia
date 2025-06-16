using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class AppDbContext : DbContext
{
    public AppDbContext()
    {
    }

    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<CargoPersonal> CargoPersonals { get; set; }

    public virtual DbSet<Cliente> Clientes { get; set; }

    public virtual DbSet<Comodidad> Comodidads { get; set; }

    public virtual DbSet<ComodidadHabitacion> ComodidadHabitacions { get; set; }

    public virtual DbSet<DireccionCliente> DireccionClientes { get; set; }

    public virtual DbSet<DireccionEmpresa> DireccionEmpresas { get; set; }

    public virtual DbSet<DireccionHospedaje> DireccionHospedajes { get; set; }

    public virtual DbSet<EmpresaActividad> EmpresaActividads { get; set; }

    public virtual DbSet<EmpresaRecreativa> EmpresaRecreativas { get; set; }

    public virtual DbSet<EmpresaServicio> EmpresaServicios { get; set; }

    public virtual DbSet<Facturacion> Facturacions { get; set; }

    public virtual DbSet<FotoHabitacion> FotoHabitacions { get; set; }

    public virtual DbSet<Habitacion> Habitacions { get; set; }

    public virtual DbSet<Hospedaje> Hospedajes { get; set; }

    public virtual DbSet<Pai> Pais { get; set; }

    public virtual DbSet<PersonalDeEmpresaRecreativa> PersonalDeEmpresaRecreativas { get; set; }

    public virtual DbSet<PersonalDelHospedaje> PersonalDelHospedajes { get; set; }

    public virtual DbSet<Provincium> Provincia { get; set; }

    public virtual DbSet<RedSocial> RedSocials { get; set; }

    public virtual DbSet<RedSocialHospedaje> RedSocialHospedajes { get; set; }

    public virtual DbSet<Reservacion> Reservacions { get; set; }

    public virtual DbSet<Servicio> Servicios { get; set; }

    public virtual DbSet<ServicioHospedaje> ServicioHospedajes { get; set; }

    public virtual DbSet<TelefonoCliente> TelefonoClientes { get; set; }

    public virtual DbSet<TelefonoHospedaje> TelefonoHospedajes { get; set; }

    public virtual DbSet<TipoActividad> TipoActividads { get; set; }

    public virtual DbSet<TipoCama> TipoCamas { get; set; }

    public virtual DbSet<TipoHabitacion> TipoHabitacions { get; set; }

    public virtual DbSet<TipoHospedaje> TipoHospedajes { get; set; }

    public virtual DbSet<TipoIdentidad> TipoIdentidads { get; set; }

    public virtual DbSet<TipoPago> TipoPagos { get; set; }

    public virtual DbSet<TipoServicio> TipoServicios { get; set; }

    public virtual DbSet<VistaCliente> VistaClientes { get; set; }

    public virtual DbSet<VistaComodidadHabitacion> VistaComodidadHabitacions { get; set; }

    public virtual DbSet<VistaContarFacturasPagada> VistaContarFacturasPagadas { get; set; }

    public virtual DbSet<VistaContarFacturasPendiente> VistaContarFacturasPendientes { get; set; }

    public virtual DbSet<VistaDireccionesHospedaje> VistaDireccionesHospedajes { get; set; }

    public virtual DbSet<VistaEmpresaActividad> VistaEmpresaActividads { get; set; }

    public virtual DbSet<VistaEmpresaRecreativa> VistaEmpresaRecreativas { get; set; }

    public virtual DbSet<VistaEmpresaServicio> VistaEmpresaServicios { get; set; }

    public virtual DbSet<VistaFacturacion> VistaFacturacions { get; set; }

    public virtual DbSet<VistaFotoHabitacion> VistaFotoHabitacions { get; set; }

    public virtual DbSet<VistaHabitacione> VistaHabitaciones { get; set; }

    public virtual DbSet<VistaHospedaje> VistaHospedajes { get; set; }

    public virtual DbSet<VistaRedSocialHospedaje> VistaRedSocialHospedajes { get; set; }

    public virtual DbSet<VistaReporteFacturacion> VistaReporteFacturacions { get; set; }

    public virtual DbSet<VistaReservacione> VistaReservaciones { get; set; }

    public virtual DbSet<VistaServicioHospedaje> VistaServicioHospedajes { get; set; }

    public virtual DbSet<VistaTelefonoCliente> VistaTelefonoClientes { get; set; }

    public virtual DbSet<VistaTelefonosHospedaje> VistaTelefonosHospedajes { get; set; }

    public virtual DbSet<VistaTipoHabitacion> VistaTipoHabitacions { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.UseSqlServer("Server=ALICE_ARIAS;Database=SistemaGestionHotelera;Trusted_Connection=True;TrustServerCertificate=True;");
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<CargoPersonal>(entity =>
        {
            entity.HasKey(e => e.IdCargo).HasName("PK__CargoPer__6C985625A82857B8");

            entity.ToTable("CargoPersonal");

            entity.HasIndex(e => e.NombreCargo, "UQ__CargoPer__B281D7B5AC8B3C4B").IsUnique();

            entity.Property(e => e.NombreCargo)
                .HasMaxLength(100)
                .IsUnicode(false);
        });

        modelBuilder.Entity<Cliente>(entity =>
        {
            entity.HasKey(e => e.IdCliente).HasName("PK__Cliente__D59466427C3012CE");

            entity.ToTable("Cliente");

            entity.HasIndex(e => e.CorreoElectronico, "UQ__Cliente__531402F39D1CD0B0").IsUnique();

            entity.Property(e => e.CorreoElectronico)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.IdentificacionCliente)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.Nombre)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.PrimerApellido)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.SegundoApellido)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.HasOne(d => d.PaisResidenciaNavigation).WithMany(p => p.Clientes)
                .HasForeignKey(d => d.PaisResidencia)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PaisResidencia");

            entity.HasOne(d => d.TipoIdentidadNavigation).WithMany(p => p.Clientes)
                .HasForeignKey(d => d.TipoIdentidad)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_IdTipoIdentidad");
        });

        modelBuilder.Entity<Comodidad>(entity =>
        {
            entity.HasKey(e => e.IdComodidad).HasName("PK__Comodida__377BDF01F5A73A37");

            entity.ToTable("Comodidad");

            entity.Property(e => e.NombreComodidad)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<ComodidadHabitacion>(entity =>
        {
            entity.HasKey(e => e.IdComodidadHabitacion).HasName("PK__Comodida__A2C4CEECBB85A1D7");

            entity.ToTable("ComodidadHabitacion");

            entity.HasOne(d => d.IdComodidadNavigation).WithMany(p => p.ComodidadHabitacions)
                .HasForeignKey(d => d.IdComodidad)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ComodidadHabitacion");

            entity.HasOne(d => d.IdTipoHabitacionNavigation).WithMany(p => p.ComodidadHabitacions)
                .HasForeignKey(d => d.IdTipoHabitacion)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TipoHabitacionComodidad");
        });

        modelBuilder.Entity<DireccionCliente>(entity =>
        {
            entity.HasKey(e => e.IdDirreccionCliente).HasName("PK__Direccio__44D453D66842E58A");

            entity.ToTable("DireccionCliente");

            entity.HasIndex(e => e.IdCliente, "UQ__Direccio__D5946643C9A8D180").IsUnique();

            entity.Property(e => e.Canton)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Distrito)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.HasOne(d => d.IdClienteNavigation).WithOne(p => p.DireccionCliente)
                .HasForeignKey<DireccionCliente>(d => d.IdCliente)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DireccionCliente");

            entity.HasOne(d => d.ProvinciaNavigation).WithMany(p => p.DireccionClientes)
                .HasForeignKey(d => d.Provincia)
                .HasConstraintName("FK_ProvinciaCliente");
        });

        modelBuilder.Entity<DireccionEmpresa>(entity =>
        {
            entity.HasKey(e => e.IdDireccionEmpresa).HasName("PK__Direccio__EADAA747E60B666A");

            entity.ToTable("DireccionEmpresa");

            entity.Property(e => e.Canton)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Distrito)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.SenasExactas)
                .HasMaxLength(255)
                .IsUnicode(false);

            entity.HasOne(d => d.IdEmpresaRecreativaNavigation).WithMany(p => p.DireccionEmpresas)
                .HasForeignKey(d => d.IdEmpresaRecreativa)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DireccionEmpresaRecreativa");

            entity.HasOne(d => d.ProvinciaNavigation).WithMany(p => p.DireccionEmpresas)
                .HasForeignKey(d => d.Provincia)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ProvinciaEmpresa");
        });

        modelBuilder.Entity<DireccionHospedaje>(entity =>
        {
            entity.HasKey(e => e.IdDireccion).HasName("PK__Direccio__1F8E0C767084417A");

            entity.ToTable("DireccionHospedaje");

            entity.Property(e => e.Barrio)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.Canton)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Distrito)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.SenasExactas)
                .HasMaxLength(255)
                .IsUnicode(false);

            entity.HasOne(d => d.IdHospedajeNavigation).WithMany(p => p.DireccionHospedajes)
                .HasForeignKey(d => d.IdHospedaje)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DireccionHospedaje");

            entity.HasOne(d => d.ProvinciaNavigation).WithMany(p => p.DireccionHospedajes)
                .HasForeignKey(d => d.Provincia)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ProvinciaHospedaje");
        });

        modelBuilder.Entity<EmpresaActividad>(entity =>
        {
            entity.HasKey(e => e.IdEmpresaActividad).HasName("PK__EmpresaA__79C28691F852BF2A");

            entity.ToTable("EmpresaActividad");

            entity.Property(e => e.Descripcion).HasColumnType("text");
            entity.Property(e => e.Horarios).HasColumnType("text");
            entity.Property(e => e.Precio)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("precio");

            entity.HasOne(d => d.IdActividadNavigation).WithMany(p => p.EmpresaActividads)
                .HasForeignKey(d => d.IdActividad)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_actividadEmpresa");

            entity.HasOne(d => d.IdEmpresaRecreativaNavigation).WithMany(p => p.EmpresaActividads)
                .HasForeignKey(d => d.IdEmpresaRecreativa)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_EmpresaRecreativaActividad");
        });

        modelBuilder.Entity<EmpresaRecreativa>(entity =>
        {
            entity.HasKey(e => e.IdEmpresaRecreativa).HasName("PK__EmpresaR__0E73672753B14491");

            entity.ToTable("EmpresaRecreativa");

            entity.HasIndex(e => e.CorreoElectronico, "UQ__EmpresaR__531402F30D93851F").IsUnique();

            entity.Property(e => e.CedulaJuridicaEmpresa)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.CorreoElectronico)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.NombreEmpresas)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.NombrePersonal)
                .HasMaxLength(150)
                .IsUnicode(false);
            entity.Property(e => e.NumeroTelefono)
                .HasMaxLength(20)
                .IsUnicode(false);
        });

        modelBuilder.Entity<EmpresaServicio>(entity =>
        {
            entity.HasKey(e => e.IdEmpresaServicio).HasName("PK__EmpresaS__662982F4F5DC901F");

            entity.ToTable("EmpresaServicio");

            entity.Property(e => e.CostoAdicional).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.Descripcion).HasColumnType("text");

            entity.HasOne(d => d.IdEmpresaRecreativaNavigation).WithMany(p => p.EmpresaServicios)
                .HasForeignKey(d => d.IdEmpresaRecreativa)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_EmpresaRecreativaServicio");

            entity.HasOne(d => d.IdServicioNavigation).WithMany(p => p.EmpresaServicios)
                .HasForeignKey(d => d.IdServicio)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ServicioEmpresa");
        });

        modelBuilder.Entity<Facturacion>(entity =>
        {
            entity.HasKey(e => e.IdFactura).HasName("PK__Facturac__50E7BAF11FDC8B28");

            entity.ToTable("Facturacion", tb => tb.HasTrigger("trigger_FacturaPagada"));

            entity.HasIndex(e => e.IdReserva, "UQ__Facturac__0E49C69C7971838B").IsUnique();

            entity.Property(e => e.Estado)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasDefaultValue("Pendiente de pago ");
            entity.Property(e => e.FechaEmision).HasDefaultValueSql("(CONVERT([date],getdate()))");
            entity.Property(e => e.ImporteTotal).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.NumeroFacturacion)
                .HasMaxLength(12)
                .IsUnicode(false);

            entity.HasOne(d => d.IdReservaNavigation).WithOne(p => p.Facturacion)
                .HasForeignKey<Facturacion>(d => d.IdReserva)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ReservaFacturada");

            entity.HasOne(d => d.IdTipoPagoNavigation).WithMany(p => p.Facturacions)
                .HasForeignKey(d => d.IdTipoPago)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_MetodoPago");
        });

        modelBuilder.Entity<FotoHabitacion>(entity =>
        {
            entity.HasKey(e => e.IdFotoHabitacion).HasName("PK__FotoHabi__47158AE445F36894");

            entity.ToTable("FotoHabitacion");

            entity.Property(e => e.Foto).HasColumnType("image");

            entity.HasOne(d => d.IdTipoHabitacionNavigation).WithMany(p => p.FotoHabitacions)
                .HasForeignKey(d => d.IdTipoHabitacion)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_FotoTipoHabotacion");
        });

        modelBuilder.Entity<Habitacion>(entity =>
        {
            entity.HasKey(e => e.IdHabitacion).HasName("PK__Habitaci__8BBBF901E16DBB7F");

            entity.ToTable("Habitacion");

            entity.HasOne(d => d.IdHospedajeNavigation).WithMany(p => p.Habitacions)
                .HasForeignKey(d => d.IdHospedaje)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_HabitacionHospedaje");

            entity.HasOne(d => d.IdTipoHabitacionNavigation).WithMany(p => p.Habitacions)
                .HasForeignKey(d => d.IdTipoHabitacion)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TipoHabitacion");
        });

        modelBuilder.Entity<Hospedaje>(entity =>
        {
            entity.HasKey(e => e.IdHospedaje).HasName("PK__Hospedaj__34DE8B0E08ECAD78");

            entity.ToTable("Hospedaje");

            entity.HasIndex(e => e.CorreoElectronico, "UQ__Hospedaj__531402F3F3A9C719").IsUnique();

            entity.Property(e => e.CedulaJuridica)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.CorreoElectronico)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.NombreHospedaje)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.ReferenciasGps)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("ReferenciasGPS");
            entity.Property(e => e.UrlSitioWeb)
                .HasMaxLength(255)
                .IsUnicode(false);

            entity.HasOne(d => d.TipoHospedajeNavigation).WithMany(p => p.Hospedajes)
                .HasForeignKey(d => d.TipoHospedaje)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TipoHospedaje");
        });

        modelBuilder.Entity<Pai>(entity =>
        {
            entity.HasKey(e => e.IdPais).HasName("PK__Pais__FC850A7BB3BE4C74");

            entity.Property(e => e.Abrebiacion)
                .HasMaxLength(3)
                .IsUnicode(false);
            entity.Property(e => e.CodigoPais)
                .HasMaxLength(5)
                .IsUnicode(false);
            entity.Property(e => e.NombrePais)
                .HasMaxLength(75)
                .IsUnicode(false);
        });

        modelBuilder.Entity<PersonalDeEmpresaRecreativa>(entity =>
        {
            entity.HasKey(e => e.IdPersonal).HasName("PK__Personal__05A9201B8752913D");

            entity.ToTable("PersonalDeEmpresaRecreativa");

            entity.HasIndex(e => e.CorreoElectronico, "UQ__Personal__531402F36B29E377").IsUnique();

            entity.Property(e => e.Cargo)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Contrasena)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.CorreoElectronico)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.NombrePersonalCompleto)
                .HasMaxLength(150)
                .IsUnicode(false);

            entity.HasOne(d => d.IdEmpresaRecreativaNavigation).WithMany(p => p.PersonalDeEmpresaRecreativas)
                .HasForeignKey(d => d.IdEmpresaRecreativa)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PersonalIdEmpresaRecreativa");
        });

        modelBuilder.Entity<PersonalDelHospedaje>(entity =>
        {
            entity.HasKey(e => e.IdPersonal).HasName("PK__Personal__05A9201B73E28EB4");

            entity.ToTable("PersonalDelHospedaje");

            entity.HasIndex(e => e.CorreoElectronico, "UQ__Personal__531402F31BA6C670").IsUnique();

            entity.Property(e => e.Contrasena)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.CorreoElectronico)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.NombrePersonalCompleto)
                .HasMaxLength(150)
                .IsUnicode(false);

            entity.HasOne(d => d.IdCargoNavigation).WithMany(p => p.PersonalDelHospedajes)
                .HasForeignKey(d => d.IdCargo)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CargoPersonal");

            entity.HasOne(d => d.IdHospedajeNavigation).WithMany(p => p.PersonalDelHospedajes)
                .HasForeignKey(d => d.IdHospedaje)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PersonalHospedaje");
        });

        modelBuilder.Entity<Provincium>(entity =>
        {
            entity.HasKey(e => e.IdProvincia).HasName("PK__Provinci__EED74455F4FB7964");

            entity.Property(e => e.NombreProvincia)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<RedSocial>(entity =>
        {
            entity.HasKey(e => e.IdRedSocial).HasName("PK__RedSocia__FCCC51148BEF02FA");

            entity.ToTable("RedSocial");

            entity.Property(e => e.NombreRedSocial)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<RedSocialHospedaje>(entity =>
        {
            entity.HasKey(e => e.IdRedSocialHospedaje).HasName("PK__RedSocia__20F1AE30B437E49B");

            entity.ToTable("RedSocialHospedaje");

            entity.Property(e => e.NombreUsuario)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.UrlPerfil)
                .HasMaxLength(255)
                .IsUnicode(false);

            entity.HasOne(d => d.IdHospedajeNavigation).WithMany(p => p.RedSocialHospedajes)
                .HasForeignKey(d => d.IdHospedaje)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RedSocialHospedaje");

            entity.HasOne(d => d.IdRedSocialNavigation).WithMany(p => p.RedSocialHospedajes)
                .HasForeignKey(d => d.IdRedSocial)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RedSocial");
        });

        modelBuilder.Entity<Reservacion>(entity =>
        {
            entity.HasKey(e => e.IdReserva).HasName("PK__Reservac__0E49C69DF7988143");

            entity.ToTable("Reservacion");

            entity.HasIndex(e => e.NumeroReserva, "UQ__Reservac__2F21611C79E9C65B").IsUnique();

            entity.Property(e => e.Estado)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasDefaultValue("Activo");
            entity.Property(e => e.NumeroReserva)
                .HasMaxLength(12)
                .IsUnicode(false);

            entity.HasOne(d => d.IdClienteNavigation).WithMany(p => p.Reservacions)
                .HasForeignKey(d => d.IdCliente)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ReservaCliente");

            entity.HasOne(d => d.IdHabitacionNavigation).WithMany(p => p.Reservacions)
                .HasForeignKey(d => d.IdHabitacion)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ReservaHabitacion");
        });

        modelBuilder.Entity<Servicio>(entity =>
        {
            entity.HasKey(e => e.IdServicio).HasName("PK__Servicio__2DCCF9A2143BCB72");

            entity.ToTable("Servicio");

            entity.Property(e => e.Descripcion).HasColumnType("text");
            entity.Property(e => e.NombreServicio)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<ServicioHospedaje>(entity =>
        {
            entity.HasKey(e => e.IdServicioHospedaje).HasName("PK__Servicio__013B85E98924077B");

            entity.ToTable("ServicioHospedaje");

            entity.HasOne(d => d.IdHospedajeNavigation).WithMany(p => p.ServicioHospedajes)
                .HasForeignKey(d => d.IdHospedaje)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ServicioHospedaje");

            entity.HasOne(d => d.IdServicioNavigation).WithMany(p => p.ServicioHospedajes)
                .HasForeignKey(d => d.IdServicio)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Servicio");
        });

        modelBuilder.Entity<TelefonoCliente>(entity =>
        {
            entity.HasKey(e => e.IdTelefonoCliente).HasName("PK__Telefono__C37978470D489ADC");

            entity.ToTable("TelefonoCliente");

            entity.Property(e => e.NumeroTelefono)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.TipoTelefono)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.IdClienteNavigation).WithMany(p => p.TelefonoClientes)
                .HasForeignKey(d => d.IdCliente)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TelefonoCliente");
        });

        modelBuilder.Entity<TelefonoHospedaje>(entity =>
        {
            entity.HasKey(e => e.IdTelefonoHospedaje).HasName("PK__Telefono__8D0FA03BFD830B10");

            entity.ToTable("TelefonoHospedaje");

            entity.Property(e => e.NumeroTelefono)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.IdHospedajeNavigation).WithMany(p => p.TelefonoHospedajes)
                .HasForeignKey(d => d.IdHospedaje)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TelefonoHospedaje");
        });

        modelBuilder.Entity<TipoActividad>(entity =>
        {
            entity.HasKey(e => e.IdActividad).HasName("PK__TipoActi__5EAF86A4A05DE7F2");

            entity.ToTable("TipoActividad");

            entity.Property(e => e.Descripcion).HasColumnType("text");
            entity.Property(e => e.NombreActividad)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<TipoCama>(entity =>
        {
            entity.HasKey(e => e.IdTipoCama).HasName("PK__TipoCama__F1B84CEFA7DCC63A");

            entity.ToTable("TipoCama");

            entity.Property(e => e.Descripcion).HasColumnType("text");
            entity.Property(e => e.NombreTipoCama)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<TipoHabitacion>(entity =>
        {
            entity.HasKey(e => e.IdTipoHabitacion).HasName("PK__TipoHabi__AB75E87C3A1B36E5");

            entity.ToTable("TipoHabitacion");

            entity.Property(e => e.Descripcion).HasColumnType("text");
            entity.Property(e => e.NombreTipoHabitacion)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Precio).HasColumnType("decimal(10, 2)");

            entity.HasOne(d => d.IdHospedajeNavigation).WithMany(p => p.TipoHabitacions)
                .HasForeignKey(d => d.IdHospedaje)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TipoHabitacionHospedaje");

            entity.HasOne(d => d.IdTipoCamaNavigation).WithMany(p => p.TipoHabitacions)
                .HasForeignKey(d => d.IdTipoCama)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TipoCamaHabitacion");
        });

        modelBuilder.Entity<TipoHospedaje>(entity =>
        {
            entity.HasKey(e => e.IdTipoHospedaje).HasName("PK__TipoHosp__2DAB0DC602AA974D");

            entity.ToTable("TipoHospedaje");

            entity.Property(e => e.NombreTipoHospedaje)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<TipoIdentidad>(entity =>
        {
            entity.HasKey(e => e.IdTipoIdentidad).HasName("PK__TipoIden__C95DCF2C1A7A6396");

            entity.ToTable("TipoIdentidad");

            entity.Property(e => e.Descripcion).HasColumnType("text");
            entity.Property(e => e.NombreTipoIdentidad)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<TipoPago>(entity =>
        {
            entity.HasKey(e => e.IdTipoPago).HasName("PK__TipoPago__EB0AA9E7C962D82A");

            entity.ToTable("TipoPago");

            entity.Property(e => e.NombreTipoPago)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<TipoServicio>(entity =>
        {
            entity.HasKey(e => e.IdServicio).HasName("PK__TipoServ__2DCCF9A2AE6F732D");

            entity.ToTable("TipoServicio");

            entity.Property(e => e.Descripcion).HasColumnType("text");
            entity.Property(e => e.NombreServicio)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<VistaCliente>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("Vista_Clientes");

            entity.Property(e => e.CorreoElectronico)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.IdentificacionCliente)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.Nombre)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.NombreCompleto)
                .HasMaxLength(152)
                .IsUnicode(false);
            entity.Property(e => e.NombrePais)
                .HasMaxLength(75)
                .IsUnicode(false);
            entity.Property(e => e.NombreTipoIdentidad)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.PrimerApellido)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.SegundoApellido)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<VistaComodidadHabitacion>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("Vista_ComodidadHabitacion");

            entity.Property(e => e.Descripcion).HasColumnType("text");
            entity.Property(e => e.NombreComodidad)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.NombreTipoHabitacion)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<VistaContarFacturasPagada>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("Vista_ContarFacturasPagadas");
        });

        modelBuilder.Entity<VistaContarFacturasPendiente>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("Vista_ContarFacturasPendientes");
        });

        modelBuilder.Entity<VistaDireccionesHospedaje>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("Vista_DireccionesHospedaje");

            entity.Property(e => e.Barrio)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.Canton)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Distrito)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.NombreHospedaje)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.NombreProvincia)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.SenasExactas)
                .HasMaxLength(255)
                .IsUnicode(false);
        });

        modelBuilder.Entity<VistaEmpresaActividad>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("Vista_EmpresaActividad");

            entity.Property(e => e.Descripcion)
                .HasColumnType("text")
                .HasColumnName("descripcion");
            entity.Property(e => e.Horarios).HasColumnType("text");
            entity.Property(e => e.NombreActividad)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.NombreEmpresas)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Precio).HasColumnType("decimal(10, 2)");
        });

        modelBuilder.Entity<VistaEmpresaRecreativa>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("Vista_EmpresaRecreativa");

            entity.Property(e => e.CedulaJuridicaEmpresa)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.CorreoElectronico)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.IdEmpresaRecreativa).ValueGeneratedOnAdd();
            entity.Property(e => e.NombreEmpresas)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.NombrePersonal)
                .HasMaxLength(150)
                .IsUnicode(false);
            entity.Property(e => e.NumeroTelefono)
                .HasMaxLength(20)
                .IsUnicode(false);
        });

        modelBuilder.Entity<VistaEmpresaServicio>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("Vista_EmpresaServicio");

            entity.Property(e => e.CostoAdicional).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.Descripcion)
                .HasColumnType("text")
                .HasColumnName("descripcion");
            entity.Property(e => e.NombreEmpresas)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.NombreServicio)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<VistaFacturacion>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("Vista_Facturacion");

            entity.Property(e => e.ImporteTotal).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.NombreCliente)
                .HasMaxLength(101)
                .IsUnicode(false);
            entity.Property(e => e.NombreHospedaje)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.NombreTipoPago)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.NumeroFacturacion)
                .HasMaxLength(12)
                .IsUnicode(false);
            entity.Property(e => e.Numeroreserva)
                .HasMaxLength(12)
                .IsUnicode(false);
        });

        modelBuilder.Entity<VistaFotoHabitacion>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("Vista_FotoHabitacion");

            entity.Property(e => e.Foto).HasColumnType("image");
            entity.Property(e => e.IdFotoHabitacion).ValueGeneratedOnAdd();
        });

        modelBuilder.Entity<VistaHabitacione>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("Vista_Habitaciones");

            entity.Property(e => e.NombreHospedaje)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.NombreTipoHabitacion)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<VistaHospedaje>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("VistaHospedajes");

            entity.Property(e => e.CedulaJuridica)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.CorreoElectronico)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.NombreHospedaje)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.NombreTipoHospedaje)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.ReferenciasGps)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("ReferenciasGPS");
            entity.Property(e => e.UrlSitioWeb)
                .HasMaxLength(255)
                .IsUnicode(false);
        });

        modelBuilder.Entity<VistaRedSocialHospedaje>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("Vista_RedSocialHospedaje");

            entity.Property(e => e.NombreHospedaje)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.NombreRedSocial)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.NombreUsuario)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.UrlPerfil)
                .HasMaxLength(255)
                .IsUnicode(false);
        });

        modelBuilder.Entity<VistaReporteFacturacion>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("Vista_ReporteFacturacion");

            entity.Property(e => e.CorreoCliente)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.EstadoReserva)
                .HasMaxLength(8)
                .IsUnicode(false);
            entity.Property(e => e.IdentificacionCliente)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.ImporteTotal).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.NombreCompletoCliente)
                .HasMaxLength(152)
                .IsUnicode(false);
            entity.Property(e => e.NombreHospedaje)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.NombreTipoHabitacion)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.NombreTipoPago)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.NumeroFacturacion)
                .HasMaxLength(12)
                .IsUnicode(false);
            entity.Property(e => e.TelefonoCliente)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.UbicacionCompletaHospedaje)
                .HasMaxLength(256)
                .IsUnicode(false);
        });

        modelBuilder.Entity<VistaReservacione>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("Vista_Reservaciones");

            entity.Property(e => e.NombreCliente)
                .HasMaxLength(101)
                .IsUnicode(false);
            entity.Property(e => e.NombreHospedaje)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.NombreTipoHabitacion)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Numeroreserva)
                .HasMaxLength(12)
                .IsUnicode(false);
        });

        modelBuilder.Entity<VistaServicioHospedaje>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("Vista_ServicioHospedaje");

            entity.Property(e => e.Descripcion)
                .HasColumnType("text")
                .HasColumnName("descripcion");
            entity.Property(e => e.NombreHospedaje)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.NombreServicio)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<VistaTelefonoCliente>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("Vista_TelefonoCliente");

            entity.Property(e => e.IdTelefonoCliente).ValueGeneratedOnAdd();
            entity.Property(e => e.NumeroTelefono)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.TipoTelefono)
                .HasMaxLength(20)
                .IsUnicode(false);
        });

        modelBuilder.Entity<VistaTelefonosHospedaje>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("Vista_TelefonosHospedaje");

            entity.Property(e => e.NombreHospedaje)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.NumeroTelefono)
                .HasMaxLength(20)
                .IsUnicode(false);
        });

        modelBuilder.Entity<VistaTipoHabitacion>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("Vista_TipoHabitacion");

            entity.Property(e => e.Descripcion)
                .HasColumnType("text")
                .HasColumnName("descripcion");
            entity.Property(e => e.NombreHospedaje)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.NombreTipoCama)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.NombreTipoHabitacion)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Precio).HasColumnType("decimal(10, 2)");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
