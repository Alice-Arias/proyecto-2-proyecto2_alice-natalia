using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class Cliente
{
    public int IdCliente { get; set; }

    public string IdentificacionCliente { get; set; } = null!;

    public string PrimerApellido { get; set; } = null!;

    public string SegundoApellido { get; set; } = null!;

    public string Nombre { get; set; } = null!;

    public string CorreoElectronico { get; set; } = null!;

    public DateOnly FechaNacimiento { get; set; }

    public int TipoIdentidad { get; set; }

    public int PaisResidencia { get; set; }

    public virtual DireccionCliente? DireccionCliente { get; set; }

    public virtual Pai PaisResidenciaNavigation { get; set; } = null!;

    public virtual ICollection<Reservacion> Reservacions { get; set; } = new List<Reservacion>();

    public virtual ICollection<TelefonoCliente> TelefonoClientes { get; set; } = new List<TelefonoCliente>();

    public virtual TipoIdentidad TipoIdentidadNavigation { get; set; } = null!;
}
