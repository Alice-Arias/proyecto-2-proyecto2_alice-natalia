using System.Diagnostics; // Permite acceder a información de diagnóstico, como el ID de la solicitud
using Aplicacion_Web_Hospedaje.Models; // Importa los modelos de la aplicación, como ErrorViewModel
using Microsoft.AspNetCore.Mvc; // Proporciona clases y atributos para construir controladores y manejar vistas

namespace Aplicacion_Web_Hospedaje.Controllers
{
    // Controlador principal de la aplicación, generalmente usado para páginas públicas como inicio, privacidad, etc.
    public class HomeController : Controller
    {
        // Campo para registrar mensajes de log (información, advertencias, errores, etc.)
        private readonly ILogger<HomeController> _logger;

        // Constructor que recibe un logger mediante inyección de dependencias
        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        // Acción que muestra la página de inicio (Index.cshtml)
        public IActionResult Index()
        {
            return View(); // Retorna la vista principal de la aplicación
        }

        // Acción que muestra la página de privacidad (Privacy.cshtml)
        public IActionResult Privacy()
        {
            return View(); // Retorna la vista con la política de privacidad
        }

        // Acción que muestra la página "Acerca de" (About.cshtml)
        public IActionResult About()
        {
            return View(); // Retorna la vista con información sobre la aplicación o el equipo
        }

        // Acción que maneja errores y muestra una vista con información del error
        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            // Crea un modelo de error con el ID de la solicitud actual
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
