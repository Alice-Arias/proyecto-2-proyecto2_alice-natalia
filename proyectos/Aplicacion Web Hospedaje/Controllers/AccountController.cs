
using Aplicacion_Web_Hospedaje.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Aplicacion_Web_Hospedaje.Controllers
{
    // Controlador responsable de manejar las acciones relacionadas con cuentas de usuario (login, información, etc.)
    public class AccountController : Controller
    {
        // Campo privado que representa el contexto de la base de datos
        private readonly AppDbContext _context;

        // Constructor que recibe el contexto de base de datos mediante inyección de dependencias
        // Esto permite acceder a la base de datos desde cualquier acción del controlador
        public AccountController(AppDbContext context)
        {
            _context = context;
        }

        // Acción HTTP GET que muestra el formulario de inicio de sesión al usuario
        [HttpGet]
        public IActionResult Login()
        {
            // Retorna la vista Login.cshtml ubicada en Views/Account/Login
            return View();
        }

        // Acción HTTP POST que procesa los datos enviados desde el formulario de inicio de sesión
        [HttpPost]
        [ValidateAntiForgeryToken] // Protege contra ataques CSRF (Cross-Site Request Forgery)
        public async Task<IActionResult> Login(LoginViewModel model)
        {
            // Verifica si los datos del modelo cumplen con las reglas de validación definidas
            if (!ModelState.IsValid)
            {
                // Si hay errores de validación, se vuelve a mostrar el formulario con los mensajes de error
                return View(model);
            }

            // Busca en la base de datos un usuario cuyo correo electrónico coincida con el ingresado
            var user = await _context.PersonalDelHospedajes
                .FirstOrDefaultAsync(u => u.CorreoElectronico == model.CorreoElectronico);

            // Verifica si el usuario existe y si la contraseña ingresada coincide con la almacenada
            // ⚠️ Advertencia: Comparar contraseñas en texto plano no es seguro.
            // Se recomienda usar hashing (como BCrypt o PasswordHasher) para proteger las contraseñas
            if (user == null || user.Contrasena != model.Contrasena)
            {
                // Si el usuario no existe o la contraseña es incorrecta, se muestra un mensaje de error genérico
                ModelState.AddModelError(string.Empty, "Correo o contraseña incorrectos.");
                return View(model);
            }

            // En este punto, las credenciales son válidas.
            // Aquí se puede implementar la lógica de autenticación, como establecer cookies o claims de usuario
            // Ejemplo: HttpContext.SignInAsync(...) para iniciar sesión
            // Redirige al usuario a la página principal después de iniciar sesión exitosamente
            return RedirectToAction("Index", "Home");
        }

        // Acción HTTP GET que muestra una vista informativa sobre la aplicación o el equipo de desarrollo
        [HttpGet]
        public IActionResult About()
        {
            // Retorna la vista About.cshtml ubicada en Views/Account/About
            return View();
        }
    }
}
