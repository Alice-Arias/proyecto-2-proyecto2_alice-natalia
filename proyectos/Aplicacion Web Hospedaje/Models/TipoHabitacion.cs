using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class TipoHabitacion
{
    public int IdTipoHabitacion { get; set; }

    public string NombreTipoHabitacion { get; set; } = null!;

    public int IdTipoCama { get; set; }

    public int IdHospedaje { get; set; }

    public int Capacidad { get; set; }

    public string Descripcion { get; set; } = null!;

    public decimal Precio { get; set; }

    public virtual ICollection<ComodidadHabitacion> ComodidadHabitacions { get; set; } = new List<ComodidadHabitacion>();

    public virtual ICollection<FotoHabitacion> FotoHabitacions { get; set; } = new List<FotoHabitacion>();

    public virtual ICollection<Habitacion> Habitacions { get; set; } = new List<Habitacion>();

    public virtual Hospedaje IdHospedajeNavigation { get; set; } = null!;

    public virtual TipoCama IdTipoCamaNavigation { get; set; } = null!;
}
