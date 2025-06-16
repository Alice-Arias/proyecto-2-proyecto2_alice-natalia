using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class EmpresaServicio
{
    public int IdEmpresaServicio { get; set; }

    public decimal? CostoAdicional { get; set; }

    public string Descripcion { get; set; } = null!;

    public int IdServicio { get; set; }

    public int IdEmpresaRecreativa { get; set; }

    public virtual EmpresaRecreativa IdEmpresaRecreativaNavigation { get; set; } = null!;

    public virtual TipoServicio IdServicioNavigation { get; set; } = null!;
}
