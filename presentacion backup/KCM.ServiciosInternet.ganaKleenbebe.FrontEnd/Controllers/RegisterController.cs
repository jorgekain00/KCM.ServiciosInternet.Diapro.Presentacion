using KCM.ServiciosInternet.Common.Library.Log;
using KCM.ServiciosInternet.Site.Business;
using KCM.ServiciosInternet.Site.Entity.www.gana.kleenbebe.com_1.Data;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace KCM.ServiciosInternet.ganaKleenbebe.FrontEnd.Controllers
{
    public class RegisterController : Controller
    {
        public string strDateNow = DateTime.Now.ToString();
        // GET: Register
        public ActionResult Index()
        {
            return View();
        }
        [HttpPost]
        public JsonResult RedirectToPath(Data objData)
        {
            try
            {
                RoutePath objRP = JsonConvert.DeserializeObject<RoutePath>(objData.Body.ToString());
                objData.Body = string.Empty;
                if (objRP.IsFound)
                {
                    if (!objRP.IsAuthenticated)
                    {
                        objData.Body = "/Register/Index";
                    }
                }
                else
                {
                    TempData["ErrorMessage"] = string.Format("Unregistered path '{0}'", objRP.strPath);
                    objData.Body = "/Home/Error";
                }

                if (string.IsNullOrEmpty(objData.Body.ToString()))
                {
                    objData.Body = "/Home/Index";
                }
                objData.IsSuccessful = true;
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(strDateNow, clsEscribirLog.enumTipoMensaje.Informativo, "/Register/RedirectToPath", "An exception ocurred");
                clsEscribirLog.EscribeLog(strDateNow, clsEscribirLog.enumTipoMensaje.Excepcion, "/Register/RedirectToPath", ex, true);
                objData.IsSuccessful = false;
                objData.strErrorMessage = "Ha ocurrido un problema con el redireccionamiento. Favor de contactar con su administrador";
            }
            return Json(objData);
        }
    }
}