using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class Servicio
{
    public int IdServicio { get; set; }

    public string NombreServicio { get; set; } = null!;

    public string Descripcion { get; set; } = null!;

    public virtual ICollection<ServicioHospedaje> ServicioHospedajes { get; set; } = new List<ServicioHospedaje>();
}
