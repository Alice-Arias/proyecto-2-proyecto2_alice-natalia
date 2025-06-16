using Aplicacion_Web_Hospedaje.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.Cookies; // Agrega esto

var builder = WebApplication.CreateBuilder(args);

// Agregar DbContext con la cadena de conexión desde appsettings.json
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("MiConexion")));

// Agregar servicios de autenticación por cookies **antes** de AddControllersWithViews
builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options =>
    {
        options.LoginPath = "/Account/Login"; // Página a la que redirige si no está autenticado
        options.AccessDeniedPath = "/Account/AccessDenied"; // Opcional: para acceso denegado
    });

// Add services to the container.
builder.Services.AddControllersWithViews();

var app = builder.Build();

// Middleware HTTP request pipeline

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

// **Agregar la autenticación aquí, antes de la autorización**
app.UseAuthentication();
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
