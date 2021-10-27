using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace KCM.ServiciosInternet.ganaKleenbebe.FrontEnd.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Aviso()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
        public ActionResult Legales()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }

        public ActionResult Error()
        {
            if (TempData["ErrorMessage"] != null)
            {
                ViewBag.Message = TempData["ErrorMessage"].ToString();
            }
            else
            {
                ViewBag.Message = string.Empty;
            }

            return View();
        }

        public ActionResult Rules()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }

        public ActionResult FAQ()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}