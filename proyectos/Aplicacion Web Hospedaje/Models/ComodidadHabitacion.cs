using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class ComodidadHabitacion
{
    public int IdComodidadHabitacion { get; set; }

    public int IdComodidad { get; set; }

    public int IdTipoHabitacion { get; set; }

    public virtual Comodidad IdComodidadNavigation { get; set; } = null!;

    public virtual TipoHabitacion IdTipoHabitacionNavigation { get; set; } = null!;
}
