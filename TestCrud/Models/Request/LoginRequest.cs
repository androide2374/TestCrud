using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Threading.Tasks;

namespace TestCrud.Models.Request
{
    public class LoginRequest
    {
        [DisplayName("Usuario")]
        public string Usuario { get; set; }
        [DisplayName("Contraseña")]
        public string Password { get; set; }
    }
}
