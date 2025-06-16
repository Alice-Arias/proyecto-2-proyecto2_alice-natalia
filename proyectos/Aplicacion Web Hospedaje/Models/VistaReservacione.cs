using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class VistaReservacione
{
    public int IdReserva { get; set; }

    public string Numeroreserva { get; set; } = null!;

    public int IdHabitacion { get; set; }

    public int NumeroHabitacion { get; set; }

    public string NombreTipoHabitacion { get; set; } = null!;

    public string NombreHospedaje { get; set; } = null!;

    public int CantidadPersonas { get; set; }

    public int IdCliente { get; set; }

    public string NombreCliente { get; set; } = null!;

    public DateOnly FechaIngreso { get; set; }

    public DateOnly Fechasalida { get; set; }

    public int? Noches { get; set; }

    public TimeOnly HoraIngreso { get; set; }

    public TimeOnly Horasalida { get; set; }

    public bool PoseeVehiculo { get; set; }
}
