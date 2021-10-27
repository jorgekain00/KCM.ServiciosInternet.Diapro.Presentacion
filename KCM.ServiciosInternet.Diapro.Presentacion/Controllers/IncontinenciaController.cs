using KCM.ServiciosInternet.Site.Entity.Config;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace KCM.ServiciosInternet.Diapro.Presentacion.Controllers
{
    public class IncontinenciaController : Controller
    {
        // GET: Incontinencia
        public ActionResult Index()
        {
            string strIncontinenceRoute = string.Empty;

            if (RouteData.Values["id"] != null)
            {
                string strCarerRoute = RouteData.Values["id"].ToString();

                ViewBag.UrlSite = Global.strUrlSite;

                switch (strCarerRoute)
                {
                    case "tipos-de-incontinencia":
                        return View("tiposIncontinencia");
                    case "la-verdad-acerca-de-la-incontinencia":
                        return View("laVerdadAcercaIncontinencia");
                    case "tratamientos-para-la-incontinencia":
                        return View("tratamientosIncontinencia");
                    case "ejercicios-de-kegel":
                        return View("ejerciciosKegel");
                    case "sliderincontinencia1":
                        return View("sliderincontinencia1");
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