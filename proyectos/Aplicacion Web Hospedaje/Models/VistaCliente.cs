using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class VistaCliente
{
    public int IdCliente { get; set; }

    public string IdentificacionCliente { get; set; } = null!;

    public string PrimerApellido { get; set; } = null!;

    public string SegundoApellido { get; set; } = null!;

    public string Nombre { get; set; } = null!;

    public string NombreCompleto { get; set; } = null!;

    public string CorreoElectronico { get; set; } = null!;

    public DateOnly FechaNacimiento { get; set; }

    public int? Edad { get; set; }

    public int TipoIdentidad { get; set; }

    public string NombreTipoIdentidad { get; set; } = null!;

    public int PaisResidencia { get; set; }

    public string NombrePais { get; set; } = null!;
}
