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
    // Controlador para gestionar las operaciones CRUD de habitaciones
    public class HabitacionsController : Controller
    {
        // Campo privado para acceder al contexto de la base de datos
        private readonly AppDbContext _context;

        // Constructor que recibe el contexto de base de datos mediante inyección de dependencias
        public HabitacionsController(AppDbContext context)
        {
            _context = context;
        }

        // GET: Habitacions
        // Muestra la lista de todas las habitaciones, incluyendo su hospedaje y tipo de habitación
        public async Task<IActionResult> Index()
        {
            var appDbContext = _context.Habitacions
                .Include(h => h.IdHospedajeNavigation)
                .Include(h => h.IdTipoHabitacionNavigation);
            return View(await appDbContext.ToListAsync());
        }
    // GET: Habitacions
// Muestra la lista de habitaciones, filtradas opcionalmente por hospedaje
public async Task<IActionResult> Index(int? idHospedaje)
{
    var habitaciones = _context.Habitacions
        .Include(h => h.IdHospedajeNavigation)
        .Include(h => h.IdTipoHabitacionNavigation)
        .AsQueryable();

    if (idHospedaje.HasValue)
    {
        habitaciones = habitaciones.Where(h => h.IdHospedaje == idHospedaje.Value);
        ViewBag.FiltradoPorHospedaje = true;
        ViewBag.NombreHospedaje = (await _context.Hospedajes
            .Where(h => h.IdHospedaje == idHospedaje.Value)
            .Select(h => h.NombreHospedaje)
            .FirstOrDefaultAsync()) ?? "Hospedaje";
    }

    return View(await habitaciones.ToListAsync());
}

        // GET: Habitacions/Details/5
        // Muestra los detalles de una habitación específica
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound(); // Retorna error si no se proporciona ID
            }

            var habitacion = await _context.Habitacions
                .Include(h => h.IdHospedajeNavigation)
                .Include(h => h.IdTipoHabitacionNavigation)
                .FirstOrDefaultAsync(m => m.IdHabitacion == id);

            if (habitacion == null)
            {
                return NotFound(); // Retorna error si no se encuentra la habitación
            }

            return View(habitacion); // Muestra la vista con los detalles
        }

        // GET: Habitacions/Create
        // Muestra el formulario para registrar una nueva habitación
        public IActionResult Create()
        {
            // Carga las listas desplegables para seleccionar hospedaje y tipo de habitación
            ViewData["IdHospedaje"] = new SelectList(_context.Hospedajes, "IdHospedaje", "IdHospedaje");
            ViewData["IdTipoHabitacion"] = new SelectList(_context.TipoHabitacions, "IdTipoHabitacion", "IdTipoHabitacion");
            return View();
        }

        // POST: Habitacions/Create
        // Procesa el formulario de creación de una nueva habitación
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("IdHabitacion,NumeroHabitacion,IdTipoHabitacion,IdHospedaje,CantidadPersonas")] Habitacion habitacion)
        {
            if (ModelState.IsValid)
            {
                _context.Add(habitacion); // Agrega la nueva habitación al contexto
                await _context.SaveChangesAsync(); // Guarda los cambios en la base de datos
                return RedirectToAction(nameof(Index)); // Redirige a la lista de habitaciones
            }

            // Si hay errores, vuelve a cargar las listas desplegables y muestra el formulario
            ViewData["IdHospedaje"] = new SelectList(_context.Hospedajes, "IdHospedaje", "IdHospedaje", habitacion.IdHospedaje);
            ViewData["IdTipoHabitacion"] = new SelectList(_context.TipoHabitacions, "IdTipoHabitacion", "IdTipoHabitacion", habitacion.IdTipoHabitacion);
            return View(habitacion);
        }

        // GET: Habitacions/Edit/5
        // Muestra el formulario para editar una habitación existente
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var habitacion = await _context.Habitacions.FindAsync(id);
            if (habitacion == null)
            {
                return NotFound();
            }

            // Carga las listas desplegables con los valores actuales seleccionados
            ViewData["IdHospedaje"] = new SelectList(_context.Hospedajes, "IdHospedaje", "IdHospedaje", habitacion.IdHospedaje);
            ViewData["IdTipoHabitacion"] = new SelectList(_context.TipoHabitacions, "IdTipoHabitacion", "IdTipoHabitacion", habitacion.IdTipoHabitacion);
            return View(habitacion);
        }

        // POST: Habitacions/Edit/5
        // Procesa la edición de una habitación
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("IdHabitacion,NumeroHabitacion,IdTipoHabitacion,IdHospedaje,CantidadPersonas")] Habitacion habitacion)
        {
            if (id != habitacion.IdHabitacion)
            {
                return NotFound(); // Retorna error si el ID no coincide
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(habitacion); // Actualiza la habitación en el contexto
                    await _context.SaveChangesAsync(); // Guarda los cambios
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!HabitacionExists(habitacion.IdHabitacion))
                    {
                        return NotFound(); // Si la habitación ya no existe, retorna error
                    }
                    else
                    {
                        throw; // Lanza la excepción si es otro tipo de error
                    }
                }

                return RedirectToAction(nameof(Index)); // Redirige a la lista de habitaciones
            }

            // Si hay errores, vuelve a cargar las listas desplegables y muestra el formulario
            ViewData["IdHospedaje"] = new SelectList(_context.Hospedajes, "IdHospedaje", "IdHospedaje", habitacion.IdHospedaje);
            ViewData["IdTipoHabitacion"] = new SelectList(_context.TipoHabitacions, "IdTipoHabitacion", "IdTipoHabitacion", habitacion.IdTipoHabitacion);
            return View(habitacion);
        }

        // GET: Habitacions/Delete/5
        // Muestra la vista de confirmación para eliminar una habitación
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var habitacion = await _context.Habitacions
                .Include(h => h.IdHospedajeNavigation)
                .Include(h => h.IdTipoHabitacionNavigation)
                .FirstOrDefaultAsync(m => m.IdHabitacion == id);

            if (habitacion == null)
            {
                return NotFound();
            }

            return View(habitacion); // Muestra la vista de confirmación
        }

        // POST: Habitacions/Delete/5
        // Elimina la habitación de la base de datos
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var habitacion = await _context.Habitacions.FindAsync(id);
            if (habitacion != null)
            {
                _context.Habitacions.Remove(habitacion); // Elimina la habitación del contexto
            }

            await _context.SaveChangesAsync(); // Guarda los cambios
            return RedirectToAction(nameof(Index)); // Redirige a la lista de habitaciones
        }

        // Método auxiliar para verificar si una habitación existe en la base de datos
        private bool HabitacionExists(int id)
        {
            return _context.Habitacions.Any(e => e.IdHabitacion == id);
        }
    }
}
