using System;
using System.Collections.Generic;

namespace Aplicacion_Web_Hospedaje.Models;

public partial class Reservacion
{
    public int IdReserva { get; set; }

    public string NumeroReserva { get; set; } = null!;

    public int IdHabitacion { get; set; }

    public int CantidadPersonas { get; set; }

    public int IdCliente { get; set; }

    public DateOnly FechaIngreso { get; set; }

    public DateOnly FechaSalida { get; set; }

    public TimeOnly HoraIngreso { get; set; }

    public TimeOnly HoraSalida { get; set; }

    public bool PoseeVehiculo { get; set; }

    public string Estado { get; set; } = null!;

    public virtual Facturacion? Facturacion { get; set; }

    public virtual Cliente IdClienteNavigation { get; set; } = null!;

    public virtual Habitacion IdHabitacionNavigation { get; set; } = null!;
}
