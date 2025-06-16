using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class Hospedaje
{
    public int IdHospedaje { get; set; }

    public string CedulaJuridica { get; set; } = null!;

    public string NombreHospedaje { get; set; } = null!;

    public int TipoHospedaje { get; set; }

    public string? UrlSitioWeb { get; set; }

    public string CorreoElectronico { get; set; } = null!;

    public string ReferenciasGps { get; set; } = null!;

    public virtual ICollection<DireccionHospedaje> DireccionHospedajes { get; set; } = new List<DireccionHospedaje>();

    public virtual ICollection<Habitacion> Habitacions { get; set; } = new List<Habitacion>();

    public virtual ICollection<PersonalDelHospedaje> PersonalDelHospedajes { get; set; } = new List<PersonalDelHospedaje>();

    public virtual ICollection<RedSocialHospedaje> RedSocialHospedajes { get; set; } = new List<RedSocialHospedaje>();

    public virtual ICollection<ServicioHospedaje> ServicioHospedajes { get; set; } = new List<ServicioHospedaje>();

    public virtual ICollection<TelefonoHospedaje> TelefonoHospedajes { get; set; } = new List<TelefonoHospedaje>();

    public virtual ICollection<TipoHabitacion> TipoHabitacions { get; set; } = new List<TipoHabitacion>();
    
    public virtual TipoHospedaje TipoHospedajeNavigation { get; set; } = null!;
}
