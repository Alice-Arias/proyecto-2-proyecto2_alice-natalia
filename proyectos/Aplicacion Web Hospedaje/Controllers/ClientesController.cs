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
    // Controlador para gestionar las operaciones CRUD de los clientes
    public class ClientesController : Controller
    {
        // Campo para acceder al contexto de la base de datos
        private readonly AppDbContext _context;

        // Constructor que recibe el contexto de base de datos mediante inyección de dependencias
        public ClientesController(AppDbContext context)
        {
            _context = context;
        }

        // GET: Clientes
        // Muestra la lista de todos los clientes, incluyendo sus relaciones con país y tipo de identidad
        public async Task<IActionResult> Index()
        {
            var appDbContext = _context.Clientes
                .Include(c => c.PaisResidenciaNavigation)
                .Include(c => c.TipoIdentidadNavigation);
            return View(await appDbContext.ToListAsync());
        }

        // GET: Clientes/Details/5
        // Muestra los detalles de un cliente específico
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound(); // Si no se proporciona ID, retorna error 404
            }

            var cliente = await _context.Clientes
                .Include(c => c.PaisResidenciaNavigation)
                .Include(c => c.TipoIdentidadNavigation)
                .FirstOrDefaultAsync(m => m.IdCliente == id);

            if (cliente == null)
            {
                return NotFound(); // Si no se encuentra el cliente, retorna error 404
            }

            return View(cliente); // Muestra la vista con los detalles del cliente
        }

        // GET: Clientes/Create
        // Muestra el formulario para crear un nuevo cliente
        public IActionResult Create()
        {
            // Carga las listas desplegables para país y tipo de identidad
            ViewData["PaisResidencia"] = new SelectList(_context.Pais, "IdPais", "IdPais");
            ViewData["TipoIdentidad"] = new SelectList(_context.TipoIdentidads, "IdTipoIdentidad", "IdTipoIdentidad");
            return View();
        }

        // POST: Clientes/Create
        // Procesa el formulario de creación de cliente
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("IdCliente,IdentificacionCliente,PrimerApellido,SegundoApellido,Nombre,CorreoElectronico,FechaNacimiento,TipoIdentidad,PaisResidencia")] Cliente cliente)
        {
            if (ModelState.IsValid)
            {
                _context.Add(cliente); // Agrega el nuevo cliente al contexto
                await _context.SaveChangesAsync(); // Guarda los cambios en la base de datos
                return RedirectToAction(nameof(Index)); // Redirige a la lista de clientes
            }

            // Si hay errores, vuelve a cargar las listas desplegables y muestra el formulario
            ViewData["PaisResidencia"] = new SelectList(_context.Pais, "IdPais", "IdPais", cliente.PaisResidencia);
            ViewData["TipoIdentidad"] = new SelectList(_context.TipoIdentidads, "IdTipoIdentidad", "IdTipoIdentidad", cliente.TipoIdentidad);
            return View(cliente);
        }

        // GET: Clientes/Edit/5
        // Muestra el formulario para editar un cliente existente
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var cliente = await _context.Clientes.FindAsync(id);
            if (cliente == null)
            {
                return NotFound();
            }

            // Carga las listas desplegables con los valores actuales seleccionados
            ViewData["PaisResidencia"] = new SelectList(_context.Pais, "IdPais", "IdPais", cliente.PaisResidencia);
            ViewData["TipoIdentidad"] = new SelectList(_context.TipoIdentidads, "IdTipoIdentidad", "IdTipoIdentidad", cliente.TipoIdentidad);
            return View(cliente);
        }

        // POST: Clientes/Edit/5
        // Procesa la edición de un cliente
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("IdCliente,IdentificacionCliente,PrimerApellido,SegundoApellido,Nombre,CorreoElectronico,FechaNacimiento,TipoIdentidad,PaisResidencia")] Cliente cliente)
        {
            if (id != cliente.IdCliente)
            {
                return NotFound(); // Si el ID no coincide, retorna error
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(cliente); // Actualiza el cliente en el contexto
                    await _context.SaveChangesAsync(); // Guarda los cambios
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ClienteExists(cliente.IdCliente))
                    {
                        return NotFound(); // Si el cliente ya no existe, retorna error
                    }
                    else
                    {
                        throw; // Lanza la excepción si es otro tipo de error
                    }
                }
                return RedirectToAction(nameof(Index)); // Redirige a la lista de clientes
            }

            // Si hay errores, vuelve a cargar las listas desplegables y muestra el formulario
            ViewData["PaisResidencia"] = new SelectList(_context.Pais, "IdPais", "IdPais", cliente.PaisResidencia);
            ViewData["TipoIdentidad"] = new SelectList(_context.TipoIdentidads, "IdTipoIdentidad", "IdTipoIdentidad", cliente.TipoIdentidad);
            return View(cliente);
        }

        // GET: Clientes/Delete/5
        // Muestra la vista de confirmación para eliminar un cliente
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var cliente = await _context.Clientes
                .Include(c => c.PaisResidenciaNavigation)
                .Include(c => c.TipoIdentidadNavigation)
                .FirstOrDefaultAsync(m => m.IdCliente == id);

            if (cliente == null)
            {
                return NotFound();
            }

            return View(cliente); // Muestra la vista de confirmación
        }

        // POST: Clientes/Delete/5
        // Elimina el cliente de la base de datos
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var cliente = await _context.Clientes.FindAsync(id);
            if (cliente != null)
            {
                _context.Clientes.Remove(cliente); // Elimina el cliente del contexto
            }

            await _context.SaveChangesAsync(); // Guarda los cambios
            return RedirectToAction(nameof(Index)); // Redirige a la lista de clientes
        }

        // Método auxiliar para verificar si un cliente existe en la base de datos
        private bool ClienteExists(int id)
        {
            return _context.Clientes.Any(e => e.IdCliente == id);
        }
    }
}
