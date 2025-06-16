using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class Facturacion
{
    public int IdFactura { get; set; }

    public string? NumeroFacturacion { get; set; }

    public int IdReserva { get; set; }

    public DateOnly FechaEmision { get; set; }

    public int? CantidadNoches { get; set; }

    public decimal? ImporteTotal { get; set; }

    public int IdTipoPago { get; set; }

    public string Estado { get; set; } = null!;

    public virtual Reservacion IdReservaNavigation { get; set; } = null!;

    public virtual TipoPago IdTipoPagoNavigation { get; set; } = null!;
}
