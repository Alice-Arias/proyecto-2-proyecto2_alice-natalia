using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class VistaTelefonosHospedaje
{
    public int IdTelefonoHospedaje { get; set; }

    public string NumeroTelefono { get; set; } = null!;

    public int IdHospedaje { get; set; }

    public string NombreHospedaje { get; set; } = null!;
}
