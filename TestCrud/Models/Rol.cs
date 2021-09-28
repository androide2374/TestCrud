using System;
using System.Collections.Generic;

#nullable disable

namespace TestCrud.Models
{
    public partial class Rol
    {
        public Rol()
        {
            Usuarios = new HashSet<Usuario>();
        }

        public int Id { get; set; }
        public string Descripcion { get; set; }
        public bool? Activo { get; set; }

        public virtual ICollection<Usuario> Usuarios { get; set; }
    }
}
