using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class VistaFotoHabitacion
{
    public int IdFotoHabitacion { get; set; }

    public int IdTipoHabitacion { get; set; }

    public byte[] Foto { get; set; } = null!;
}
