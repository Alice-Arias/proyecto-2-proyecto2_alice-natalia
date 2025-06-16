using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class DireccionHospedaje
{
    public int IdDireccion { get; set; }

    public int IdHospedaje { get; set; }

    public string SenasExactas { get; set; } = null!;

    public string Barrio { get; set; } = null!;

    public int Provincia { get; set; }

    public string Canton { get; set; } = null!;

    public string Distrito { get; set; } = null!;

    public virtual Hospedaje IdHospedajeNavigation { get; set; } = null!;

    public virtual Provincium ProvinciaNavigation { get; set; } = null!;
}
