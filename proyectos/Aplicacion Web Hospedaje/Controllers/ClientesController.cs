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
    public class ClientesController : Controller
    {
        private readonly AppDbContext _context;

        public ClientesController(AppDbContext context)
        {
            _context = context;
        }

        // GET: Clientes/LoginCliente
        [HttpGet]
        public IActionResult LoginCliente()
        {
            return View();
        }

        // POST: Clientes/LoginCliente
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> LoginCliente(LoginViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            var cliente = await _context.Clientes
                .FirstOrDefaultAsync(c => c.CorreoElectronico == model.CorreoElectronico);

            if (cliente == null)
            {
                ModelState.AddModelError(string.Empty, "Correo no registrado.");
                return View(model);
            }

            return RedirectToAction("VistaCliente", new { id = cliente.IdCliente });
        }

        // GET: Clientes/VistaCliente/5
        public async Task<IActionResult> VistaCliente(int id)
        {
            var cliente = await _context.Clientes
                .Include(c => c.PaisResidenciaNavigation)
                .Include(c => c.TipoIdentidadNavigation)
                .FirstOrDefaultAsync(c => c.IdCliente == id);

            if (cliente == null)
            {
                return NotFound();
            }

            return View(cliente);
        }

        // GET: Clientes
        public async Task<IActionResult> Index()
        {
            var appDbContext = _context.Clientes
                .Include(c => c.PaisResidenciaNavigation)
                .Include(c => c.TipoIdentidadNavigation);
            return View(await appDbContext.ToListAsync());
        }

        // GET: Clientes/Details/5
        public async Task<IActionResult> Details(int? id)
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

            return View(cliente);
        }

        // GET: Clientes/Create
        public IActionResult Create()
        {
            ViewData["PaisResidencia"] = new SelectList(_context.Pais, "IdPais", "IdPais");
            ViewData["TipoIdentidad"] = new SelectList(_context.TipoIdentidads, "IdTipoIdentidad", "IdTipoIdentidad");
            return View();
        }

        // POST: Clientes/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("IdCliente,IdentificacionCliente,PrimerApellido,SegundoApellido,Nombre,CorreoElectronico,FechaNacimiento,TipoIdentidad,PaisResidencia")] Cliente cliente)
        {
            if (ModelState.IsValid)
            {
                _context.Add(cliente);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["PaisResidencia"] = new SelectList(_context.Pais, "IdPais", "IdPais", cliente.PaisResidencia);
            ViewData["TipoIdentidad"] = new SelectList(_context.TipoIdentidads, "IdTipoIdentidad", "IdTipoIdentidad", cliente.TipoIdentidad);
            return View(cliente);
        }

        // GET: Clientes/Edit/5
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
            ViewData["PaisResidencia"] = new SelectList(_context.Pais, "IdPais", "IdPais", cliente.PaisResidencia);
            ViewData["TipoIdentidad"] = new SelectList(_context.TipoIdentidads, "IdTipoIdentidad", "IdTipoIdentidad", cliente.TipoIdentidad);
            return View(cliente);
        }

        // POST: Clientes/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("IdCliente,IdentificacionCliente,PrimerApellido,SegundoApellido,Nombre,CorreoElectronico,FechaNacimiento,TipoIdentidad,PaisResidencia")] Cliente cliente)
        {
            if (id != cliente.IdCliente)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(cliente);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ClienteExists(cliente.IdCliente))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            ViewData["PaisResidencia"] = new SelectList(_context.Pais, "IdPais", "IdPais", cliente.PaisResidencia);
            ViewData["TipoIdentidad"] = new SelectList(_context.TipoIdentidads, "IdTipoIdentidad", "IdTipoIdentidad", cliente.TipoIdentidad);
            return View(cliente);
        }

        // GET: Clientes/Delete/5
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

            return View(cliente);
        }

        // POST: Clientes/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var cliente = await _context.Clientes.FindAsync(id);
            if (cliente != null)
            {
                _context.Clientes.Remove(cliente);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool ClienteExists(int id)
        {
            return _context.Clientes.Any(e => e.IdCliente == id);
        }
    }
}
