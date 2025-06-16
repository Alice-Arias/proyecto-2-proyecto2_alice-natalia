using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class Pai
{
    public int IdPais { get; set; }

    public string NombrePais { get; set; } = null!;

    public string CodigoPais { get; set; } = null!;

    public string Abrebiacion { get; set; } = null!;

    public virtual ICollection<Cliente> Clientes { get; set; } = new List<Cliente>();
}
