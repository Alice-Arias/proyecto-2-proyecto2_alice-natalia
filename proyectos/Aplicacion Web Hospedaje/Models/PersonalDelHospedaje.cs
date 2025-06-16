using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class PersonalDelHospedaje
{
    public int IdPersonal { get; set; }

    public int IdHospedaje { get; set; }

    public string NombrePersonalCompleto { get; set; } = null!;

    public int IdCargo { get; set; }

    public string CorreoElectronico { get; set; } = null!;

    public string? Contrasena { get; set; }

    public virtual CargoPersonal IdCargoNavigation { get; set; } = null!;

    public virtual Hospedaje IdHospedajeNavigation { get; set; } = null!;
}
