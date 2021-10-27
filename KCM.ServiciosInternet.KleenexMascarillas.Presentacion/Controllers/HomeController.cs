using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.IO;
using KCM.ServiciosInternet.Site.Entity.Formularios;
using KCM.ServiciosInternet.Site.Business;
using KCM.ServiciosInternet.Common.Library.Log;
using KCM.ServiciosInternet.Site.Entity.Config;

namespace KCM.ServiciosInternet.KleenexMascarillas.Presentacion.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult validaContacto(ContactModelKleenexMascarillas objContacto)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    if (!Business.enviarCorreoContacto(objContacto))
                    {
                        throw new Exception(string.Format("Se ha producido un error {0}", objContacto.recaptchaResponse == "Error" ? "recaptcha" : ""));
                    }
                }
                else
                {
                    if (!objContacto.Terms)
                    {
                        ModelState.AddModelError("Terms", "Debe Aceptar terminos y condiciones");
                    }
                }
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog("/Home/validaContacto", clsEscribirLog.enumTipoMensaje.Informativo, "validaContacto", "No se pudo enviar el email");
                clsEscribirLog.EscribeLog("/Home/validaContacto", clsEscribirLog.enumTipoMensaje.Excepcion, "validaContacto", ex, Global.blIsDebug);
            }
            return new EmptyResult();
        }
    }

}