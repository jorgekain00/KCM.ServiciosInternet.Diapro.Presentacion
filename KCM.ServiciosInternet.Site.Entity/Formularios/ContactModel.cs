using System.ComponentModel.DataAnnotations;
using System.Net;

namespace KCM.ServiciosInternet.Site.Entity.Formularios
{
    public class ContactModel
    {
        #region propiedades

        [Required(ErrorMessage = "Por favor ingresa tu correo electrónico")]
        [EmailAddress(ErrorMessage = "La dirección de E-mail no es válida")]
        [Display(Name = "email")]
        public string Email { get; set; }

        [Required(ErrorMessage = "Por favor ingresa tu mensaje")]
        [StringLength(200, ErrorMessage = "Puede ingresar hasta 200 carácteres en el mensaje")]
        [Display(Name = "mensaje")]
        public string Message
        {
            get { return this._Message; }
            set { this._Message = WebUtility.HtmlEncode(value); }
        }

        [Display(Name = "recaptcha")]
        public string recaptchaResponse { get; set; }

        #endregion

        #region variables
        private string _Message;
        #endregion
    }
}