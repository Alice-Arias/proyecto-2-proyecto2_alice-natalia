using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class TipoPago
{
    public int IdTipoPago { get; set; }

    public string NombreTipoPago { get; set; } = null!;

    public virtual ICollection<Facturacion> Facturacions { get; set; } = new List<Facturacion>();
}
