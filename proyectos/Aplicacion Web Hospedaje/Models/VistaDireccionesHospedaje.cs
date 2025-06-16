using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class VistaDireccionesHospedaje
{
    public int IdDireccion { get; set; }

    public int IdHospedaje { get; set; }

    public string NombreHospedaje { get; set; } = null!;

    public string SenasExactas { get; set; } = null!;

    public string Barrio { get; set; } = null!;

    public int Provincia { get; set; }

    public string NombreProvincia { get; set; } = null!;

    public string Canton { get; set; } = null!;

    public string Distrito { get; set; } = null!;
}
