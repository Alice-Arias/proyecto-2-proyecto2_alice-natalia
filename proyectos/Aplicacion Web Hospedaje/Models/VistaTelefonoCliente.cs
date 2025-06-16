using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class VistaTelefonoCliente
{
    public int IdTelefonoCliente { get; set; }

    public int IdCliente { get; set; }

    public string NumeroTelefono { get; set; } = null!;

    public string TipoTelefono { get; set; } = null!;
}
