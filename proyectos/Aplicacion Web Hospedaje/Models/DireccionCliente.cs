using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class DireccionCliente
{
    public int IdDirreccionCliente { get; set; }

    public int IdCliente { get; set; }

    public int? Provincia { get; set; }

    public string? Canton { get; set; }

    public string? Distrito { get; set; }

    public virtual Cliente IdClienteNavigation { get; set; } = null!;

    public virtual Provincium? ProvinciaNavigation { get; set; }
}
