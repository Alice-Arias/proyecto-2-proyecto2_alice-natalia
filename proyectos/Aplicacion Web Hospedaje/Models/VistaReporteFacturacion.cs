using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class VistaReporteFacturacion
{
    public string? NumeroFacturacion { get; set; }

    public DateOnly FechaEmision { get; set; }

    public int? CantidadNoches { get; set; }

    public decimal? ImporteTotal { get; set; }

    public int? EdadCliente { get; set; }

    public string NombreCompletoCliente { get; set; } = null!;

    public string IdentificacionCliente { get; set; } = null!;

    public string TelefonoCliente { get; set; } = null!;

    public string CorreoCliente { get; set; } = null!;

    public int IdHospedaje { get; set; }

    public string NombreHospedaje { get; set; } = null!;

    public string UbicacionCompletaHospedaje { get; set; } = null!;

    public int NumeroHabitacion { get; set; }

    public int IdTipoHabitacion { get; set; }

    public string NombreTipoHabitacion { get; set; } = null!;

    public string NombreTipoPago { get; set; } = null!;

    public string EstadoReserva { get; set; } = null!;
}
