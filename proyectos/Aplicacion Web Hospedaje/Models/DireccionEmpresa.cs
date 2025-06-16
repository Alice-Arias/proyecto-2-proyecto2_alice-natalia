using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class DireccionEmpresa
{
    public int IdDireccionEmpresa { get; set; }

    public int IdEmpresaRecreativa { get; set; }

    public string SenasExactas { get; set; } = null!;

    public int Provincia { get; set; }

    public string Canton { get; set; } = null!;

    public string Distrito { get; set; } = null!;

    public virtual EmpresaRecreativa IdEmpresaRecreativaNavigation { get; set; } = null!;

    public virtual Provincium ProvinciaNavigation { get; set; } = null!;
}
