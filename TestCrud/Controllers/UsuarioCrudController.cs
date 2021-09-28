using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TestCrud.Models;
using TestCrud.Services;

namespace TestCrud.Controllers
{
    public class UsuarioCrudController : Controller
    {
        private readonly TestCrudContext _context;
        public UsuarioCrudController(TestCrudContext context)
        {
            _context = context;
        }
        // GET: UsuarioCrudController
        public ActionResult Index()
        {
            List<Usuario> usuarios = _context.Usuarios.Include(s => s.IdRolNavigation).ToList();
            return View(usuarios);
        }

        // GET: UsuarioCrudController/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: UsuarioCrudController/Create
        public ActionResult Create()
        {
            ViewBag.Roles = _context.Rols.ToList();
            return View();
        }

        // POST: UsuarioCrudController/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Usuario usuario)
        {
            Usuario Userexist = _context.Usuarios.FirstOrDefault(u => u.Username == usuario.Username);
            try
            {
                if (Userexist == null)
                {
                    usuario.FechaAlta = DateTime.Now;
                    usuario.Activo = true;
                    usuario.Password = Encryption.Encrypt(usuario.Password);
                    if (ModelState.IsValid)
                    {
                        _context.Usuarios.Add(usuario);
                        _context.SaveChanges();
                    }
                    ViewBag.Success = "Usuario Creado con exito";
                    return View();
                }
                else
                {
                    ViewBag.Roles = _context.Rols.ToList();
                    ViewBag.errormessage = "El usuario ya existe";
                    return View();
                }

            }
            catch
            {
                ViewBag.errormessage = "Error al crear usuario, intente de nuevo";
                ViewBag.Roles = _context.Rols.ToList();
                return View();
            }
        }

        // GET: UsuarioCrudController/Edit/5
        public ActionResult Edit(int id)
        {
            Usuario usuario = _context.Usuarios.FirstOrDefault(u => u.Id == id);
            if (usuario != null)
            {
                ViewBag.Roles = _context.Rols.ToList();
                return View(usuario);
            }
            return RedirectToAction("Index");
        }

        // POST: UsuarioCrudController/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(int id, Usuario usuario)
        {
            var checkuser = _context.Usuarios.FirstOrDefault(x => x.Id != id && x.Username == usuario.Username);
            try
            {
                if (checkuser ==null)
                {
                    _context.Entry(usuario).State = EntityState.Modified;
                    _context.SaveChanges();

                    return RedirectToAction(nameof(Index));
                }
                ViewBag.Roles = _context.Rols.ToList();
                ViewBag.errormessage = "Error al Editar usuario, el nombre de usuario ya esta en uso";
                return View();
            }
            catch (Exception ex)
            {
                ViewBag.Roles = _context.Rols.ToList();
                ViewBag.errormessage = "Error al Editar usuario, intente de nuevo";
                return View();
            }
        }

        // GET: UsuarioCrudController/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: UsuarioCrudController/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(int id, IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }
    }
}
