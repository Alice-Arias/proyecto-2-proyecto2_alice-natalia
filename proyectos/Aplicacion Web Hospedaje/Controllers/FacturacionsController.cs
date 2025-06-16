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
    // Controlador encargado de gestionar las operaciones CRUD para las facturaciones
    public class FacturacionsController : Controller
    {
        // Campo privado para acceder al contexto de la base de datos
        private readonly AppDbContext _context;

        // Constructor que recibe el contexto de base de datos mediante inyección de dependencias
        public FacturacionsController(AppDbContext context)
        {
            _context = context;
        }

        // GET: Facturacions
        // Muestra la lista de todas las facturas registradas, incluyendo sus relaciones con reserva y tipo de pago
        public async Task<IActionResult> Index()
        {
            var appDbContext = _context.Facturacions
                .Include(f => f.IdReservaNavigation)
                .Include(f => f.IdTipoPagoNavigation);
            return View(await appDbContext.ToListAsync());
        }

        // GET: Facturacions/Details/5
        // Muestra los detalles de una factura específica
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound(); // Retorna error si no se proporciona ID
            }

            var facturacion = await _context.Facturacions
                .Include(f => f.IdReservaNavigation)
                .Include(f => f.IdTipoPagoNavigation)
                .FirstOrDefaultAsync(m => m.IdFactura == id);

            if (facturacion == null)
            {
                return NotFound(); // Retorna error si no se encuentra la factura
            }

            return View(facturacion); // Muestra la vista con los detalles de la factura
        }

        // GET: Facturacions/Create
        // Muestra el formulario para crear una nueva factura
        public IActionResult Create()
        {
            // Carga las listas desplegables para seleccionar reserva y tipo de pago
            ViewData["IdReserva"] = new SelectList(_context.Reservacions, "IdReserva", "IdReserva");
            ViewData["IdTipoPago"] = new SelectList(_context.TipoPagos, "IdTipoPago", "IdTipoPago");
            return View();
        }

        // POST: Facturacions/Create
        // Procesa el formulario de creación de una nueva factura
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("IdFactura,NumeroFacturacion,IdReserva,FechaEmision,CantidadNoches,ImporteTotal,IdTipoPago,Estado")] Facturacion facturacion)
        {
            if (ModelState.IsValid)
            {
                _context.Add(facturacion); // Agrega la nueva factura al contexto
                await _context.SaveChangesAsync(); // Guarda los cambios en la base de datos
                return RedirectToAction(nameof(Index)); // Redirige a la lista de facturas
            }

            // Si hay errores, vuelve a cargar las listas desplegables y muestra el formulario
            ViewData["IdReserva"] = new SelectList(_context.Reservacions, "IdReserva", "IdReserva", facturacion.IdReserva);
            ViewData["IdTipoPago"] = new SelectList(_context.TipoPagos, "IdTipoPago", "IdTipoPago", facturacion.IdTipoPago);
            return View(facturacion);
        }

        // GET: Facturacions/Edit/5
        // Muestra el formulario para editar una factura existente
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var facturacion = await _context.Facturacions.FindAsync(id);
            if (facturacion == null)
            {
                return NotFound();
            }

            // Carga las listas desplegables con los valores actuales seleccionados
            ViewData["IdReserva"] = new SelectList(_context.Reservacions, "IdReserva", "IdReserva", facturacion.IdReserva);
            ViewData["IdTipoPago"] = new SelectList(_context.TipoPagos, "IdTipoPago", "IdTipoPago", facturacion.IdTipoPago);
            return View(facturacion);
        }

        // POST: Facturacions/Edit/5
        // Procesa la edición de una factura
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("IdFactura,NumeroFacturacion,IdReserva,FechaEmision,CantidadNoches,ImporteTotal,IdTipoPago,Estado")] Facturacion facturacion)
        {
            if (id != facturacion.IdFactura)
            {
                return NotFound(); // Retorna error si el ID no coincide
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(facturacion); // Actualiza la factura en el contexto
                    await _context.SaveChangesAsync(); // Guarda los cambios
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!FacturacionExists(facturacion.IdFactura))
                    {
                        return NotFound(); // Si la factura ya no existe, retorna error
                    }
                    else
                    {
                        throw; // Lanza la excepción si es otro tipo de error
                    }
                }

                return RedirectToAction(nameof(Index)); // Redirige a la lista de facturas
            }

            // Si hay errores, vuelve a cargar las listas desplegables y muestra el formulario
            ViewData["IdReserva"] = new SelectList(_context.Reservacions, "IdReserva", "IdReserva", facturacion.IdReserva);
            ViewData["IdTipoPago"] = new SelectList(_context.TipoPagos, "IdTipoPago", "IdTipoPago", facturacion.IdTipoPago);
            return View(facturacion);
        }

        // GET: Facturacions/Delete/5
        // Muestra la vista de confirmación para eliminar una factura
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var facturacion = await _context.Facturacions
                .Include(f => f.IdReservaNavigation)
                .Include(f => f.IdTipoPagoNavigation)
                .FirstOrDefaultAsync(m => m.IdFactura == id);

            if (facturacion == null)
            {
                return NotFound();
            }

            return View(facturacion); // Muestra la vista de confirmación
        }

        // POST: Facturacions/Delete/5
        // Elimina la factura de la base de datos
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var facturacion = await _context.Facturacions.FindAsync(id);
            if (facturacion != null)
            {
                _context.Facturacions.Remove(facturacion); // Elimina la factura del contexto
            }

            await _context.SaveChangesAsync(); // Guarda los cambios
            return RedirectToAction(nameof(Index)); // Redirige a la lista de facturas
        }

        // Método auxiliar para verificar si una factura existe en la base de datos
        private bool FacturacionExists(int id)
        {
            return _context.Facturacions.Any(e => e.IdFactura == id);
        }
    }
}
