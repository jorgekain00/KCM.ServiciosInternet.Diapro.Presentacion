using System.ComponentModel.DataAnnotations;

namespace Models
{
    public class datatest
    {
        [Required(ErrorMessage = "Por favor ingrese su contraseña")]
        public string password { get; set; }
        [Compare("password",ErrorMessage = "Por favor ingrese su contraseña nuevamente")]
        public string confirmPassword { get; set; }
    }
}