using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class TipoIdentidad
{
    public int IdTipoIdentidad { get; set; }

    public string NombreTipoIdentidad { get; set; } = null!;

    public string Descripcion { get; set; } = null!;

    public virtual ICollection<Cliente> Clientes { get; set; } = new List<Cliente>();
}
