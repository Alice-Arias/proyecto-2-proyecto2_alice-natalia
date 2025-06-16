using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class ServicioHospedaje
{
    public int IdServicioHospedaje { get; set; }

    public int IdHospedaje { get; set; }

    public int IdServicio { get; set; }

    public virtual Hospedaje IdHospedajeNavigation { get; set; } = null!;

    public virtual Servicio IdServicioNavigation { get; set; } = null!;
}
