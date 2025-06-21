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
    public class EmpresaRecreativasController : Controller
    {

        private readonly AppDbContext _context;

        // Constructor que recibe el contexto de base de datos mediante inyección de dependencias
        public EmpresaRecreativasController(AppDbContext context)
        {
            _context = context;
        }

        // GET: EmpresaRecreativas
        // Muestra la lista de todas las empresas recreativas registradas
        public async Task<IActionResult> Index()
        {
            return View(await _context.EmpresaRecreativas.ToListAsync());
        }

        // GET: EmpresaRecreativas/Details/5
        // Muestra los detalles de una empresa recreativa específica
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound(); // Retorna error 404 si no se proporciona ID
            }

            var empresaRecreativa = await _context.EmpresaRecreativas
                .FirstOrDefaultAsync(m => m.IdEmpresaRecreativa == id);

            if (empresaRecreativa == null)
            {
                return NotFound(); // Retorna error 404 si no se encuentra la empresa
            }

            return View(empresaRecreativa); // Muestra la vista con los detalles
        }

        // GET: EmpresaRecreativas/Create
        // Muestra el formulario para registrar una nueva empresa recreativa
        public IActionResult Create()
        {
            return View();
        }

        // POST: EmpresaRecreativas/Create
        // Procesa el formulario de creación de empresa recreativa
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("IdEmpresaRecreativa,CedulaJuridicaEmpresa,NombreEmpresas,CorreoElectronico,NombrePersonal,NumeroTelefono")] EmpresaRecreativa empresaRecreativa)
        {
            if (ModelState.IsValid)
            {
                _context.Add(empresaRecreativa); // Agrega la nueva empresa al contexto
                await _context.SaveChangesAsync(); // Guarda los cambios en la base de datos
                return RedirectToAction(nameof(Index)); // Redirige a la lista de empresas
            }

            return View(empresaRecreativa); // Si hay errores, vuelve a mostrar el formulario
        }

        // GET: EmpresaRecreativas/Edit/5
        // Muestra el formulario para editar una empresa recreativa existente
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound(); // Retorna error si no se proporciona ID
            }

            var empresaRecreativa = await _context.EmpresaRecreativas.FindAsync(id);
            if (empresaRecreativa == null)
            {
                return NotFound(); // Retorna error si no se encuentra la empresa
            }

            return View(empresaRecreativa); // Muestra el formulario con los datos actuales
        }

        // POST: EmpresaRecreativas/Edit/5
        // Procesa la edición de una empresa recreativa
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("IdEmpresaRecreativa,CedulaJuridicaEmpresa,NombreEmpresas,CorreoElectronico,NombrePersonal,NumeroTelefono")] EmpresaRecreativa empresaRecreativa)
        {
            if (id != empresaRecreativa.IdEmpresaRecreativa)
            {
                return NotFound(); // Retorna error si el ID no coincide
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(empresaRecreativa);
                    await _context.SaveChangesAsync(); 
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!EmpresaRecreativaExists(empresaRecreativa.IdEmpresaRecreativa))
                    {
                        return NotFound(); // Si la empresa ya no existe, retorna error
                    }
                    else
                    {
                        throw; // Lanza la excepción si es otro tipo de error
                    }
                }

                return RedirectToAction(nameof(Index)); // Redirige a la lista de empresas
            }

            return View(empresaRecreativa); // Si hay errores, vuelve a mostrar el formulario
        }

        // GET: EmpresaRecreativas/Delete/5
        // Muestra la vista de confirmación para eliminar una empresa recreativa
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound(); // Retorna error si no se proporciona ID
            }

            var empresaRecreativa = await _context.EmpresaRecreativas
                .FirstOrDefaultAsync(m => m.IdEmpresaRecreativa == id);

            if (empresaRecreativa == null)
            {
                return NotFound(); // Retorna error si no se encuentra la empresa
            }

            return View(empresaRecreativa); // Muestra la vista de confirmación
        }

        // POST: EmpresaRecreativas/Delete/5
        // Elimina la empresa recreativa de la base de datos
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var empresaRecreativa = await _context.EmpresaRecreativas.FindAsync(id);
            if (empresaRecreativa != null)
            {
                _context.EmpresaRecreativas.Remove(empresaRecreativa); // Elimina la empresa del contexto
            }

            await _context.SaveChangesAsync(); // Guarda los cambios
            return RedirectToAction(nameof(Index)); // Redirige a la lista de empresas
        }

        // Método auxiliar para verificar si una empresa recreativa existe en la base de datos
        private bool EmpresaRecreativaExists(int id)
        {
            return _context.EmpresaRecreativas.Any(e => e.IdEmpresaRecreativa == id);
        }
    }
}
