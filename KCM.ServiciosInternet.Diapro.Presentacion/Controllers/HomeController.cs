using KCM.ServiciosInternet.Site.Business;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.IO;
using KCM.ServiciosInternet.Common.Library.Log;
using System.Configuration;
using KCM.ServiciosInternet.Site.Entity.Formularios;
using KCM.ServiciosInternet.Site.Entity.Config;

namespace KCM.ServiciosInternet.Diapro.Presentacion.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            ViewBag.UrlSite = Global.strUrlSite;
            return View();
        }

        public ActionResult avisoPrivacidad()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult validaContacto(ContactModel objContact)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    if (Business.enviarCorreoContacto(objContact))
                    {
                        //return RedirectToAction("emailEnviado");
                        return PartialView("_thankYouComment");
                    }
                    else
                    {
                        return PartialView("_formularioContacto", objContact); ;
                    }
                }
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog("/Home/validaContacto", clsEscribirLog.enumTipoMensaje.Informativo, "validaContacto", "No se pudo enviar el email");
                clsEscribirLog.EscribeLog("/Home/validaContacto", clsEscribirLog.enumTipoMensaje.Excepcion, "validaContacto", ex, Global.blIsDebug);
            }
            //return RedirectToAction("emailEnviado");
            return PartialView("_thankYouComment");
        }

        public PartialViewResult emailEnviado()
        {
            return PartialView("_thankYouComment");
        }

        [HttpPost]
        public ContentResult cargaExtLibs()
        {
            if (RouteData.Values["id"] != null)
            {
                string strScriptName = RouteData.Values["id"].ToString();

                switch (strScriptName)
                {
                    case "recaptcha":
                        return Content("https://www.google.com/recaptcha/api.js?onload=initRecaptcha&render=explicit");
                }
            }

            return Content("Not found");
        }
    }
}