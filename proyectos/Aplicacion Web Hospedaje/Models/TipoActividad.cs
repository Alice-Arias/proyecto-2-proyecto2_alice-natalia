using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class TipoActividad
{
    public int IdActividad { get; set; }

    public string NombreActividad { get; set; } = null!;

    public string Descripcion { get; set; } = null!;

    public virtual ICollection<EmpresaActividad> EmpresaActividads { get; set; } = new List<EmpresaActividad>();
}
