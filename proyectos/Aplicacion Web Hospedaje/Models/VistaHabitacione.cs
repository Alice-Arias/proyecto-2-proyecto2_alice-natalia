using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class VistaHabitacione
{
    public int IdHabitacion { get; set; }

    public int NumeroHabitacion { get; set; }

    public int IdTipoHabitacion { get; set; }

    public string NombreTipoHabitacion { get; set; } = null!;

    public int IdHospedaje { get; set; }

    public string NombreHospedaje { get; set; } = null!;

    public int CantidadPersonas { get; set; }
}
