using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

#nullable disable

namespace TestCrud.Models
{
    public partial class Usuario
    {
        public int Id { get; set; }
        [DisplayName("Usuario")]
        [Required]
        public string Username { get; set; }
        [DisplayName("Contraseña")]
        [Required]
        public string Password { get; set; }
        [Required]
        public string Nombre { get; set; }
        [Required]
        public string Apellido { get; set; }
        [DisplayName("Rol")]
        [Required]
        public int IdRol { get; set; }
        public DateTime FechaAlta { get; set; }
        public bool Activo { get; set; }

        public virtual Rol IdRolNavigation { get; set; }
    }
}
