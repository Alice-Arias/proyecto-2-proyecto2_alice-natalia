using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class VistaHospedaje
{
    public int IdHospedaje { get; set; }

    public string CedulaJuridica { get; set; } = null!;

    public string NombreHospedaje { get; set; } = null!;

    public string NombreTipoHospedaje { get; set; } = null!;

    public string? UrlSitioWeb { get; set; }

    public string CorreoElectronico { get; set; } = null!;

    public string ReferenciasGps { get; set; } = null!;
}
