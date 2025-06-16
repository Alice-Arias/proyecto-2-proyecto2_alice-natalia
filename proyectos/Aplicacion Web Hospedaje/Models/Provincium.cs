using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class Provincium
{
    public int IdProvincia { get; set; }

    public string NombreProvincia { get; set; } = null!;

    public virtual ICollection<DireccionCliente> DireccionClientes { get; set; } = new List<DireccionCliente>();

    public virtual ICollection<DireccionEmpresa> DireccionEmpresas { get; set; } = new List<DireccionEmpresa>();

    public virtual ICollection<DireccionHospedaje> DireccionHospedajes { get; set; } = new List<DireccionHospedaje>();
}
