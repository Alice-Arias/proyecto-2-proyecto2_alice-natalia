using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class PersonalDeEmpresaRecreativa
{
    public int IdPersonal { get; set; }

    public int IdEmpresaRecreativa { get; set; }

    public string NombrePersonalCompleto { get; set; } = null!;

    public string Cargo { get; set; } = null!;

    public string CorreoElectronico { get; set; } = null!;

    public string? Contrasena { get; set; }

    public virtual EmpresaRecreativa IdEmpresaRecreativaNavigation { get; set; } = null!;
}
