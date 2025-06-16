using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class VistaEmpresaServicio
{
    public int IdEmpresaservicio { get; set; }

    public decimal? CostoAdicional { get; set; }

    public string Descripcion { get; set; } = null!;

    public int IdServicio { get; set; }

    public string NombreServicio { get; set; } = null!;

    public int IdEmpresaRecreativa { get; set; }

    public string NombreEmpresas { get; set; } = null!;
}
