using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class Comodidad
{
    public int IdComodidad { get; set; }

    public string NombreComodidad { get; set; } = null!;

    public virtual ICollection<ComodidadHabitacion> ComodidadHabitacions { get; set; } = new List<ComodidadHabitacion>();
}
