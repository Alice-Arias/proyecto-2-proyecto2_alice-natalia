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
    public class HospedajesController : Controller
    {
        private readonly AppDbContext _context;

        public HospedajesController(AppDbContext context)
        {
            _context = context;
        }

        // GET: Hospedajes
        // Agregamos parámetro searchString para buscar por nombre
        public async Task<IActionResult> Index(string searchString)
        {
            ViewData["CurrentFilter"] = searchString;

            var hospedajes = _context.Hospedajes
                .Include(h => h.TipoHospedajeNavigation)
                .AsQueryable();

            if (!String.IsNullOrEmpty(searchString))
            {
                hospedajes = hospedajes.Where(h => h.NombreHospedaje.Contains(searchString));
            }

            return View(await hospedajes.ToListAsync());
        }

        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
                return NotFound();

            var hospedaje = await _context.Hospedajes
                .Include(h => h.TipoHospedajeNavigation)
                .Include(h => h.Habitacions)
                    .ThenInclude(h => h.IdTipoHabitacionNavigation)
                .FirstOrDefaultAsync(m => m.IdHospedaje == id);

            if (hospedaje == null)
                return NotFound();

            return View(hospedaje);
        }

        public IActionResult Create()
        {
            ViewData["TipoHospedaje"] = new SelectList(_context.TipoHospedajes, "IdTipoHospedaje", "IdTipoHospedaje");
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("IdHospedaje,CedulaJuridica,NombreHospedaje,TipoHospedaje,UrlSitioWeb,CorreoElectronico,ReferenciasGps")] Hospedaje hospedaje)
        {
            if (ModelState.IsValid)
            {
                _context.Add(hospedaje);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["TipoHospedaje"] = new SelectList(_context.TipoHospedajes, "IdTipoHospedaje", "IdTipoHospedaje", hospedaje.TipoHospedaje);
            return View(hospedaje);
        }

        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
                return NotFound();

            var hospedaje = await _context.Hospedajes.FindAsync(id);
            if (hospedaje == null)
                return NotFound();

            ViewData["TipoHospedaje"] = new SelectList(_context.TipoHospedajes, "IdTipoHospedaje", "IdTipoHospedaje", hospedaje.TipoHospedaje);
            return View(hospedaje);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("IdHospedaje,CedulaJuridica,NombreHospedaje,TipoHospedaje,UrlSitioWeb,CorreoElectronico,ReferenciasGps")] Hospedaje hospedaje)
        {
            if (id != hospedaje.IdHospedaje)
                return NotFound();

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(hospedaje);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!HospedajeExists(hospedaje.IdHospedaje))
                        return NotFound();
                    else
                        throw;
                }
                return RedirectToAction(nameof(Index));
            }
            ViewData["TipoHospedaje"] = new SelectList(_context.TipoHospedajes, "IdTipoHospedaje", "IdTipoHospedaje", hospedaje.TipoHospedaje);
            return View(hospedaje);
        }

        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
                return NotFound();

            var hospedaje = await _context.Hospedajes
                .Include(h => h.TipoHospedajeNavigation)
                .FirstOrDefaultAsync(m => m.IdHospedaje == id);

            if (hospedaje == null)
                return NotFound();

            return View(hospedaje);
        }

        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var hospedaje = await _context.Hospedajes.FindAsync(id);
            if (hospedaje != null)
            {
                _context.Hospedajes.Remove(hospedaje);
                await _context.SaveChangesAsync();
            }

            return RedirectToAction(nameof(Index));
        }

        private bool HospedajeExists(int id)
        {
            return _context.Hospedajes.Any(e => e.IdHospedaje == id);
        }
    }
}
