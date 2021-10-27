using KCM.ServiciosInternet.Site.Entity.Config;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace KCM.ServiciosInternet.Diapro.Presentacion.Controllers
{
    public class ProductosController : Controller
    {
        // GET: Productos
        public ActionResult Index()
        {
            string strProductsRoute = string.Empty;

            if (RouteData.Values["id"] != null)
            {
                string strCarerRoute = RouteData.Values["id"].ToString();

                ViewBag.UrlSite = Global.strUrlSite;

                switch (strCarerRoute)
                {
                    case "gel-panales-predoblados":
                        return View("gelPanalesPredoblados");
                    case "panal-anatomico-diapro":
                        return View("panalAnatomicoDiapro");
                    case "pants-calzones-diapro":
                        return View("pantsCalzonesDiapro");
                    case "toallitas-humedas":
                        return View("toallitasHumedas");
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