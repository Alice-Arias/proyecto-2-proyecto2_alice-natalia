using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class Habitacion
{
    public int IdHabitacion { get; set; }

    public int NumeroHabitacion { get; set; }

    public int IdTipoHabitacion { get; set; }

    public int IdHospedaje { get; set; }

    public int CantidadPersonas { get; set; }

    public virtual Hospedaje IdHospedajeNavigation { get; set; } = null!;

    public virtual TipoHabitacion IdTipoHabitacionNavigation { get; set; } = null!;

    public virtual ICollection<Reservacion> Reservacions { get; set; } = new List<Reservacion>();
}
