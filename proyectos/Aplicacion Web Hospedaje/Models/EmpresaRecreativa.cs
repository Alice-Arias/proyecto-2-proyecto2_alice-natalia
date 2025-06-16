using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class EmpresaRecreativa
{
    public int IdEmpresaRecreativa { get; set; }

    public string CedulaJuridicaEmpresa { get; set; } = null!;

    public string NombreEmpresas { get; set; } = null!;

    public string CorreoElectronico { get; set; } = null!;

    public string NombrePersonal { get; set; } = null!;

    public string NumeroTelefono { get; set; } = null!;

    public virtual ICollection<DireccionEmpresa> DireccionEmpresas { get; set; } = new List<DireccionEmpresa>();

    public virtual ICollection<EmpresaActividad> EmpresaActividads { get; set; } = new List<EmpresaActividad>();

    public virtual ICollection<EmpresaServicio> EmpresaServicios { get; set; } = new List<EmpresaServicio>();

    public virtual ICollection<PersonalDeEmpresaRecreativa> PersonalDeEmpresaRecreativas { get; set; } = new List<PersonalDeEmpresaRecreativa>();
}
