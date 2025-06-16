using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class VistaRedSocialHospedaje
{
    public int IdRedSocialHospedaje { get; set; }

    public int IdHospedaje { get; set; }

    public string NombreHospedaje { get; set; } = null!;

    public int IdRedSocial { get; set; }

    public string NombreRedSocial { get; set; } = null!;

    public string NombreUsuario { get; set; } = null!;

    public string UrlPerfil { get; set; } = null!;
}
