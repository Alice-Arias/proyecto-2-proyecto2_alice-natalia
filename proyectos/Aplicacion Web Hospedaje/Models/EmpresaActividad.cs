using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class EmpresaActividad
{
    public int IdEmpresaActividad { get; set; }

    public decimal Precio { get; set; }

    public int MaximoParticipantes { get; set; }

    public int MinimoParticipantes { get; set; }

    public int Duracion { get; set; }

    public string? Descripcion { get; set; }

    public string? Horarios { get; set; }

    public int IdActividad { get; set; }

    public int IdEmpresaRecreativa { get; set; }

    public virtual TipoActividad IdActividadNavigation { get; set; } = null!;

    public virtual EmpresaRecreativa IdEmpresaRecreativaNavigation { get; set; } = null!;
}
