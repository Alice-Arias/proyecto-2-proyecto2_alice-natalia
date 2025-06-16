using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class TipoHospedaje
{
    public int IdTipoHospedaje { get; set; }

    public string NombreTipoHospedaje { get; set; } = null!;

    public virtual ICollection<Hospedaje> Hospedajes { get; set; } = new List<Hospedaje>();
}
