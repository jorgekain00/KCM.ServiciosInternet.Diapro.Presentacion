using KCM.ServiciosInternet.Site.Entity.CustomAttributes;
using System.ComponentModel.DataAnnotations;
using System.Net;

namespace KCM.ServiciosInternet.Site.Entity.Formularios
{
    public class ContactModelKleenexMascarillas
    {
        #region propiedades

        [Required(ErrorMessage = "Por favor ingresa tu nombre completo")]
        [Display(Name = "Nombre completo")]
        [RegularExpression(pattern: @"^[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]+$",ErrorMessage ="Ingrese un nombre de persona válido")]
        [StringLength(200, ErrorMessage = "Puede ingresar hasta 200 carácteres en el nombre")]
        public string Name{ get; set; }

        [Required(ErrorMessage = "Por favor ingresa tu correo electrónico")]
        [EmailAddress(ErrorMessage = "La dirección de E-mail no es válida")]
        [Display(Name = "Correo Electrónico")]
        public string Email { get; set; }


        [Required(ErrorMessage = "Ingrese el número de teléfono")]
        [RegularExpression(pattern: @"^[0-9]{10}$", ErrorMessage = "Ingrese máximo 10 dígitos")]
        [Display(Name = "Teléfono Celular")]
        public string Phone { get; set; }

        [Required(ErrorMessage = "Por favor ingresa tus dudas")]
        [StringLength(200, ErrorMessage = "Puede ingresar hasta 200 carácteres en el mensaje")]
        [Display(Name = "Escribe tu duda")]
        public string Message
        {
            get { return this._Message; }
            set { this._Message = WebUtility.HtmlEncode(value); }
        }

        [Display(Name = "recaptcha")]
        public string recaptchaResponse { get; set; }

        [Display(Name = "Acepto términos y condiciones")]
        [MustBeTrueAttribute(ErrorMessage ="Debe aceptar términos y condiciones")]
        public bool Terms { get; set; }

        #endregion

        #region variables
        private string _Message;
        #endregion
    }
}