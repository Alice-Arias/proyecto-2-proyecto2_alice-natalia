using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class FotoHabitacion
{
    public int IdFotoHabitacion { get; set; }

    public int IdTipoHabitacion { get; set; }

    public byte[] Foto { get; set; } = null!;

    public virtual TipoHabitacion IdTipoHabitacionNavigation { get; set; } = null!;
}
