using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Aplicacion_Web_Hospedaje.Models;

namespace Aplicacion_Web_Hospedaje.Controllers
{
    // Controlador para gestionar las operaciones CRUD de las reservaciones
    public class ReservacionsController : Controller
    {
        private readonly AppDbContext _context;

        // Constructor que recibe el contexto de base de datos mediante inyección de dependencias
        public ReservacionsController(AppDbContext context)
        {
            _context = context;
        }

        // GET: Reservacions
        // Muestra la lista de todas las reservaciones, incluyendo cliente y habitación asociada
        public async Task<IActionResult> Index()
        {
            var appDbContext = _context.Reservacions
                .Include(r => r.IdClienteNavigation)
                .Include(r => r.IdHabitacionNavigation);
            return View(await appDbContext.ToListAsync());
        }

        // GET: Reservacions/Details/5
        // Muestra los detalles de una reservación específica
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
                return NotFound();

            var reservacion = await _context.Reservacions
                .Include(r => r.IdClienteNavigation)
                .Include(r => r.IdHabitacionNavigation)
                .FirstOrDefaultAsync(m => m.IdReserva == id);

            if (reservacion == null)
                return NotFound();

            return View(reservacion);
        }

        // GET: Reservacions/Create
        // Muestra el formulario para crear una nueva reservación
        public IActionResult Create()
        {
            ViewData["IdCliente"] = new SelectList(_context.Clientes, "IdCliente", "IdCliente");
            ViewData["IdHabitacion"] = new SelectList(_context.Habitacions, "IdHabitacion", "IdHabitacion");
            return View();
        }

        // POST: Reservacions/Create
        // Procesa el formulario de creación de una nueva reservación
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("IdReserva,NumeroReserva,IdHabitacion,CantidadPersonas,IdCliente,FechaIngreso,FechaSalida,HoraIngreso,HoraSalida,PoseeVehiculo,Estado")] Reservacion reservacion)
        {
            if (ModelState.IsValid)
            {
                _context.Add(reservacion);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }

            // Si hay errores, vuelve a cargar las listas desplegables y muestra el formulario
            ViewData["IdCliente"] = new SelectList(_context.Clientes, "IdCliente", "IdCliente", reservacion.IdCliente);
            ViewData["IdHabitacion"] = new SelectList(_context.Habitacions, "IdHabitacion", "IdHabitacion", reservacion.IdHabitacion);
            return View(reservacion);
        }

        // GET: Reservacions/Edit/5
        // Muestra el formulario para editar una reservación existente
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
                return NotFound();

            var reservacion = await _context.Reservacions.FindAsync(id);
            if (reservacion == null)
                return NotFound();

            ViewData["IdCliente"] = new SelectList(_context.Clientes, "IdCliente", "IdCliente", reservacion.IdCliente);
            ViewData["IdHabitacion"] = new SelectList(_context.Habitacions, "IdHabitacion", "IdHabitacion", reservacion.IdHabitacion);
            return View(reservacion);
        }

        // POST: Reservacions/Edit/5
        // Procesa la edición de una reservación
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("IdReserva,NumeroReserva,IdHabitacion,CantidadPersonas,IdCliente,FechaIngreso,FechaSalida,HoraIngreso,HoraSalida,PoseeVehiculo,Estado")] Reservacion reservacion)
        {
            if (id != reservacion.IdReserva)
                return NotFound();

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(reservacion);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ReservacionExists(reservacion.IdReserva))
                        return NotFound();
                    else
                        throw;
                }
                return RedirectToAction(nameof(Index));
            }

            ViewData["IdCliente"] = new SelectList(_context.Clientes, "IdCliente", "IdCliente", reservacion.IdCliente);
            ViewData["IdHabitacion"] = new SelectList(_context.Habitacions, "IdHabitacion", "IdHabitacion", reservacion.IdHabitacion);
            return View(reservacion);
        }

        // GET: Reservacions/Delete/5
        // Muestra la vista de confirmación para eliminar una reservación
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
                return NotFound();

            var reservacion = await _context.Reservacions
                .Include(r => r.IdClienteNavigation)
                .Include(r => r.IdHabitacionNavigation)
                .FirstOrDefaultAsync(m => m.IdReserva == id);

            if (reservacion == null)
                return NotFound();

            return View(reservacion);
        }

        // POST: Reservacions/Delete/5
        // Elimina la reservación de la base de datos
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var reservacion = await _context.Reservacions.FindAsync(id);
            if (reservacion != null)
            {
                _context.Reservacions.Remove(reservacion);
                await _context.SaveChangesAsync();
            }

            return RedirectToAction(nameof(Index));
        }

        // Método auxiliar para verificar si una reservación existe en la base de datos
        private bool ReservacionExists(int id)
        {
            return _context.Reservacions.Any(e => e.IdReserva == id);
        }
    }
}
