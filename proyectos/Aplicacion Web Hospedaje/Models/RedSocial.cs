using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class RedSocial
{
    public int IdRedSocial { get; set; }

    public string NombreRedSocial { get; set; } = null!;

    public virtual ICollection<RedSocialHospedaje> RedSocialHospedajes { get; set; } = new List<RedSocialHospedaje>();
}
