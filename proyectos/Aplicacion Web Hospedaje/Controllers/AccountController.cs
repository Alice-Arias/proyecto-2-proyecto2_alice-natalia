using Aplicacion_Web_Hospedaje.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Aplicacion_Web_Hospedaje.Controllers
{
    public class AccountController : Controller
    {
        private readonly AppDbContext _context;

        public AccountController(AppDbContext context)
        {
            _context = context;
        }

        // Página para elegir tipo de usuario
        [HttpGet]
        public IActionResult SeleccionarTipo()
        {
            return View();
        }

        // LOGIN PERSONAL DEL HOSPEDAJE
        [HttpGet]
        public IActionResult Login()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(LoginViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            var user = await _context.PersonalDelHospedajes
                .FirstOrDefaultAsync(u => u.CorreoElectronico == model.CorreoElectronico);

            if (user == null || user.Contrasena != model.Contrasena)
            {
                ModelState.AddModelError(string.Empty, "Correo o contraseña incorrectos.");
                return View(model);
            }

            return RedirectToAction("DashboardPersonal", "Dashboard", new { id = user.IdHospedaje });
        }

        // LOGIN CLIENTE (SOLO CORREO)
        [HttpGet]
        public IActionResult LoginCliente()
        {
            return View();
        }

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

            return RedirectToAction("VistaCliente", "Cliente", new { id = cliente.IdCliente });
        }

        [HttpGet]
        public IActionResult About()
        {
            return View();
        }
    }
}
