using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class TipoServicio
{
    public int IdServicio { get; set; }

    public string NombreServicio { get; set; } = null!;

    public string Descripcion { get; set; } = null!;

    public virtual ICollection<EmpresaServicio> EmpresaServicios { get; set; } = new List<EmpresaServicio>();
}
