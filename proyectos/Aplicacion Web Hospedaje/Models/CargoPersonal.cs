using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class CargoPersonal
{
    public int IdCargo { get; set; }

    public string NombreCargo { get; set; } = null!;

    public virtual ICollection<PersonalDelHospedaje> PersonalDelHospedajes { get; set; } = new List<PersonalDelHospedaje>();
}
