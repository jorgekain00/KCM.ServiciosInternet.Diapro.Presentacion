using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace KCM.ServiciosInternet.Diapro.Presentacion.Controllers
{
    public class PruebaController : Controller
    {
        // GET: Prueba
        public ActionResult Index()
        {
            return View();
        }


        public ActionResult IndexSinNotas()
        {
            return View("IndexSinNotas");
        }

        public ActionResult IndexSinVideos()
        {
            return View("IndexSinVideos");
        }
    }
}