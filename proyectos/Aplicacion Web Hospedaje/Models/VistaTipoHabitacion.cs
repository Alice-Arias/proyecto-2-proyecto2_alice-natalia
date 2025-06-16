using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class VistaTipoHabitacion
{
    public int IdTipoHabitacion { get; set; }

    public string NombreTipoHabitacion { get; set; } = null!;

    public int IdTipoCama { get; set; }

    public string NombreTipoCama { get; set; } = null!;

    public int IdHospedaje { get; set; }

    public string NombreHospedaje { get; set; } = null!;

    public int Capacidad { get; set; }

    public string Descripcion { get; set; } = null!;

    public decimal Precio { get; set; }
}
