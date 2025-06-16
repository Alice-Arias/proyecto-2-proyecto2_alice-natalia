using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class VistaFacturacion
{
    public int IdFactura { get; set; }

    public string? NumeroFacturacion { get; set; }

    public int IdReserva { get; set; }

    public string Numeroreserva { get; set; } = null!;

    public DateOnly FechaEmision { get; set; }

    public int? CantidadNoches { get; set; }

    public decimal? ImporteTotal { get; set; }

    public int IdTipoPago { get; set; }

    public string NombreTipoPago { get; set; } = null!;

    public int IdCliente { get; set; }

    public string NombreCliente { get; set; } = null!;

    public int NumeroHabitacion { get; set; }

    public string NombreHospedaje { get; set; } = null!;
}
