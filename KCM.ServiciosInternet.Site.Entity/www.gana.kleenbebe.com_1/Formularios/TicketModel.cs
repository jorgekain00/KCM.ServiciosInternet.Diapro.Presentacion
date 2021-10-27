using KCM.ServiciosInternet.Site.Entity.CustomAttributes;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace KCM.ServiciosInternet.Site.Entity.www.gana.kleenbebe.com_1.Formularios
{
    public class TicketModel
    {

        #region propiedades

        [Required(ErrorMessage = "Ingresa el monto de compra")]
        [RegularExpression(pattern: @"^([0-9]{3,6}\.[0-9]{2})$", ErrorMessage = "El monto mínimo es de $160.00 pesos. No olvides colocar los dos números después del punto.")]
        [Display(Name = "Monto de compra")]
        public decimal productPrice { get; set; }

        [Required(ErrorMessage = "Ingresa la clave del producto")]
        [RegularExpression(pattern: @"^([0-9]{5})$", ErrorMessage = "Clave inválida")]
        [Display(Name = "Clave del producto")]
        public int productClave { get; set; }

        [Required(ErrorMessage = "Ingresa el folio del ticket")]
        [RegularExpression(pattern: @"^([a-zA-ZñÑ0-9-_]){5,40}$", ErrorMessage = "Folio del ticket inválido")]
        [Display(Name = "Folio del ticket")]
        public string productTicket { get; set; }

        [Display(Name = "recaptcha")]
        [Required(ErrorMessage = "Presione el recaptcha para continuar")]
        public string recaptchaResponse { get; set; }

        [Display(Name = "UID")]
        public string UID { get; set; }

        [Display(Name = "FirstName")]
        public string FirstName { get; set; }

        [Display(Name = "LastName")]
        public string LastName { get; set; }

        [Display(Name = "Email")]
        public string Email { get; set; }

        [Display(Name = "BirthYear")]
        public int BirthYear { get; set; }

        [Display(Name = "BirthMonth")]
        public int BirthMonth { get; set; }

        [Display(Name = "BirthDay")]
        public int BirthDay { get; set; }

        [Display(Name = "CellPhone")]
        public string CellPhone { get; set; }

        [TypeOfFile(ErrorMessage = "Sólo se aceptan archivos .jpg .jpeg .png", strValidExtensions = new string[] {".jpg", ".png", ".jpeg"})]
        [SizeOfFile(ErrorMessage = "El archivo no debe ser mayor a 4mb", Size = 4194304)]
        [IsImage(ErrorMessage = "El archivo subido no es una imagen")]
        [Required(ErrorMessage = "Favor de subir su foto del ticket")]
        public HttpPostedFileWrapper ImageFile { get; set; }
        #endregion


    }
}
