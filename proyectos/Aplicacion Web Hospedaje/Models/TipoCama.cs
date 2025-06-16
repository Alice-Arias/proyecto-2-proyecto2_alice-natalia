using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class TipoCama
{
    public int IdTipoCama { get; set; }

    public string NombreTipoCama { get; set; } = null!;

    public string Descripcion { get; set; } = null!;

    public virtual ICollection<TipoHabitacion> TipoHabitacions { get; set; } = new List<TipoHabitacion>();
}
