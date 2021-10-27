using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace KCM.ServiciosInternet.Diapro.Presentacion.Controllers
{
    public class NoticiasController : Controller
    {
        // GET: Noticias
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult sliderNotasMovil()
        {
            return View();
        }
    }
}