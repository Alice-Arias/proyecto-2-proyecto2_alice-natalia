using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class VistaComodidadHabitacion
{
    public int IdComodidadHabitacion { get; set; }

    public int IdComodidad { get; set; }

    public string NombreComodidad { get; set; } = null!;

    public string Descripcion { get; set; } = null!;

    public int IdTipoHabitacion { get; set; }

    public string NombreTipoHabitacion { get; set; } = null!;
}
