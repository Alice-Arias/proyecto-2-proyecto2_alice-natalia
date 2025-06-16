using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class VistaEmpresaRecreativa
{
    public int IdEmpresaRecreativa { get; set; }

    public string CedulaJuridicaEmpresa { get; set; } = null!;

    public string NombreEmpresas { get; set; } = null!;

    public string CorreoElectronico { get; set; } = null!;

    public string NombrePersonal { get; set; } = null!;

    public string NumeroTelefono { get; set; } = null!;
}
