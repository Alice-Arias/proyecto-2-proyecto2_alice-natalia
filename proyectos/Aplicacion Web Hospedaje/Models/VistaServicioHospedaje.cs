using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class VistaServicioHospedaje
{
    public int IdServicioHospedaje { get; set; }

    public int IdHospedaje { get; set; }

    public string NombreHospedaje { get; set; } = null!;

    public int IdServicio { get; set; }

    public string NombreServicio { get; set; } = null!;

    public string Descripcion { get; set; } = null!;
}
