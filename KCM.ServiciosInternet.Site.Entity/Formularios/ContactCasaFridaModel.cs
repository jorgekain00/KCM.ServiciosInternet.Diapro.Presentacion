using KCM.ServiciosInternet.Site.Entity.CustomAttributes;
using System.ComponentModel.DataAnnotations;
using System.Net;

namespace KCM.ServiciosInternet.Site.Entity.Formularios
{
    public class ContactCasaFridaModel
    {
        #region propiedades

        [Required(ErrorMessage = "Por favor ingrese su organización")]
        [Display(Name = "ORG | ONG | OSC")]
        [StringLength(200, ErrorMessage = "Puede ingresar hasta 200 carácteres en el nombre")]
        public string Organization { get; set; }

        [Required(ErrorMessage = "Por favor ingrese su acrónimo")]
        [Display(Name = "Acrónimo")]
        [StringLength(50, ErrorMessage = "Puede ingresar hasta 50 carácteres en el nombre")]
        public string Acronym { get; set; }

        [Required(ErrorMessage = "Por favor ingrese su representante legal")]
        [Display(Name = "Representante legal")]
        [RegularExpression(pattern: @"^[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]+$",ErrorMessage ="Ingrese un nombre válido")]
        [StringLength(150, ErrorMessage = "Puede ingresar hasta 150 carácteres en el nombre")]
        public string LegalRepresentative { get; set; }

        [Required(ErrorMessage = "Por favor ingrese su RFC")]
        [Display(Name = "RFC")]
        [RegularExpression(pattern: @"^[a-zA-Z0-9ñÑ]+$", ErrorMessage ="Ingrese un RFC válido")]
        [StringLength(15, ErrorMessage = "Puede ingresar hasta 15 carácteres en el RFC")]
        public string RFC { get; set; }

        [Required(ErrorMessage = "Por favor ingrese su registro ONG")]
        [Display(Name = "Registro ONG")]
        [StringLength(50, ErrorMessage = "Puede ingresar hasta 50 carácteres en el nombre")]
        public string ONGRegister { get; set; }

        [Required(ErrorMessage = "Por favor ingrese su correo electrónico")]
        [EmailAddress(ErrorMessage = "La dirección de E-mail no es válida")]
        [Display(Name = "Correo Electrónico")]
        public string Email { get; set; }

        [Required(ErrorMessage = "Ingrese el número de teléfono")]
        [RegularExpression(pattern: @"^[0-9]{10}$", ErrorMessage = "Ingrese máximo 10 dígitos")]
        [Display(Name = "Teléfono Celular")]
        public string CellPhone { get; set; }

        [Required(ErrorMessage = "Por favor ingresa la descripción del proyecto")]
        [StringLength(200, ErrorMessage = "Puede ingresar hasta 200 carácteres en el mensaje")]
        [Display(Name = "Descripción del proyecto")]
        public string ProjectDescription
        {
            get { return this._ProjectDescription; }
            set { this._ProjectDescription = WebUtility.HtmlEncode(value); }
        }

        [Display(Name = "recaptcha")]
        public string recaptchaResponse { get; set; }

        [Display(Name = "He leído y acepto términos y condiciones")]
        [MustBeTrueAttribute(ErrorMessage ="Debe aceptar términos y condiciones")]
        public bool Terms { get; set; }

        #endregion

        #region variables
        private string _ProjectDescription;
        #endregion
    }
}