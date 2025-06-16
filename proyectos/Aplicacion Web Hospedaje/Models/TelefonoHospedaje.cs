using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class TelefonoHospedaje
{
    public int IdTelefonoHospedaje { get; set; }

    public string NumeroTelefono { get; set; } = null!;

    public int IdHospedaje { get; set; }

    public virtual Hospedaje IdHospedajeNavigation { get; set; } = null!;
}
