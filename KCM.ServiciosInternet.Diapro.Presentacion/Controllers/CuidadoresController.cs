using KCM.ServiciosInternet.Site.Entity.Config;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace KCM.ServiciosInternet.Diapro.Presentacion.Controllers
{
    public class CuidadoresController : Controller
    {
        // GET: Cuidadores
        public ActionResult Index()
        {
            string strSafeCareRoute = string.Empty;

            if (RouteData.Values["id"] != null)
            {
                string strCarerRoute = RouteData.Values["id"].ToString();

                ViewBag.UrlSite = Global.strUrlSite;

                switch (strCarerRoute)
                {
                    case "cuidado-de-pacientes-en-silla-de-ruedas":
                        return View("paciente_Silla_Ruedas");
                    case "herramientas-para-cuidadores":
                        return View("herramientas_cuidadores");
                    case "cuidado-de-pacientes-en-cama":
                        return View("cuidado_pacientes_cama");
                    case "higiene-en-pacientes":
                        return View("higiene_pacientes");
                    case "consejos-para-un-mejor-cuidado":
                        return View("consejos_mejor_cuidado");
                    case "sliderCuidadores1":
                        return View("sliderCuidadores1");
                    default:
                        return View("Index");
                }
            }
            else
            {
                return View();
            }
        }
    }
}