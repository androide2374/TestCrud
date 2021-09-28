using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TestCrud.Models;
using TestCrud.Models.Request;
using TestCrud.Services;

namespace TestCrud.Controllers
{
    public class LoginController : Controller
    {
        private readonly TestCrudContext _context;
        public LoginController(TestCrudContext context)
        {
            _context = context;
        }
        public IActionResult Login()
        {
            return View();
        }
        [HttpPost]
        public IActionResult Login(LoginRequest login)
        {
            if (!String.IsNullOrEmpty(login.Password) && !String.IsNullOrEmpty(login.Usuario))
            {
                var password = Encryption.Encrypt(login.Password);
                var user = _context.Usuarios.Include(s => s.IdRolNavigation).FirstOrDefault(x => x.Username == login.Usuario && x.Password == password);
                if (user.IdRol==1)
                {
                    return RedirectToAction("Index", "UsuarioCrud");
                }
                else
                {
                    return RedirectToAction("Index", "Home");
                }
            }
            return View();
        }
    }
}
