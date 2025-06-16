using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class RedSocialHospedaje
{
    public int IdRedSocialHospedaje { get; set; }

    public int IdHospedaje { get; set; }

    public int IdRedSocial { get; set; }

    public string NombreUsuario { get; set; } = null!;

    public string UrlPerfil { get; set; } = null!;

    public virtual Hospedaje IdHospedajeNavigation { get; set; } = null!;

    public virtual RedSocial IdRedSocialNavigation { get; set; } = null!;
}
