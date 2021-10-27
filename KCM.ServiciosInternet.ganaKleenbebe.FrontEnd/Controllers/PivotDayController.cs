using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using KCM.ServiciosInternet.Common.Library.Log;
using KCM.ServiciosInternet.Site.Business;
using KCM.ServiciosInternet.Site.Entity.Config;
using KCM.ServiciosInternet.Site.Entity.www.gana.kleenbebe.com_1.BD.EF;
using KCM.ServiciosInternet.Site.Entity.www.gana.kleenbebe.com_1.Data;
using Newtonsoft.Json;

namespace KCM.ServiciosInternet.ganaKleenbebe.FrontEnd.Controllers
{
    public class PivotDayController : Controller
    {
        // GET: PivotDay
        public ActionResult Index()
        {
            try
            {
                HttpCookie objCookie = Request.Cookies["userSession"];

                if (objCookie == null)
                {
                    return RedirectToAction("LogIn", "Register");
                }
                else
                {
                    Session_GetAdminUser_Result objResult = JsonConvert.DeserializeObject<Session_GetAdminUser_Result>(objCookie.Value);
                    objCookie.Expires = DateTime.Now.AddMinutes(Global.strSessionMinutes);
                    objCookie.HttpOnly = true;
                    objCookie.Secure = true;
                    Response.Cookies.Add(objCookie);


                    if (!objResult.isAdmin)
                    {
                        return RedirectToAction("LogIn", "Register");
                    }
                    return View();
                }
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/PivotDay/Index", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/PivotDay/Index", ex, true);
            }
            TempData["ErrorMessage"] = string.Format("An exception ocurred");
            return RedirectToAction("Error", "Home");
        }

        [HttpPost]
        public JsonResult GetPivotDays(Data objData)
        {
            try
            {
                objData = Business.PivotGetPivotDays(objData);
                objData.IsSuccessful = true;
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/PivotDay/GetPivotDays", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/PivotDay/GetPivotDays", ex, true);
                objData.IsSuccessful = false;
                objData.strErrorMessage = "Se ha presentado un problema. Favor de contactar al administrador";
            }
            return Json(objData);
        }

        [HttpPost]
        public JsonResult UpdatePivotDay(Pivot_GetPivotDays_Result objPivot)
        {
            Data objData = new Data();

            try
            {
                objData = Business.PivotUpdatePivotDay(objPivot);
                objData.IsSuccessful = true;
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/PivotDay/UpdatePivotDay", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/PivotDay/UpdatePivotDay", ex, true);
                objData.IsSuccessful = false;
                objData.strErrorMessage = "Se ha presentado un problema. Favor de contactar al administrador";
            }
            return Json(objData);
        }

        [HttpPost]
        public JsonResult DeletePivotDay(Data objData)
        {
            try
            {
                objData = Business.PivotDeletePivotDay(objData);
                objData.IsSuccessful = true;
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/PivotDay/DeletePivotDay", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/PivotDay/DeletePivotDay", ex, true);
                objData.IsSuccessful = false;
                objData.strErrorMessage = "Se ha presentado un problema. Favor de contactar al administrador";
            }
            return Json(objData);
        }

        [HttpPost]
        public JsonResult GetGameInfo(Data objData)
        {
            try
            {
                objData = Business.PivotGetGameInfo(objData);
                objData.IsSuccessful = true;
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/PivotDay/GetGameInfo", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/PivotDay/GetGameInfo", ex, true);
                objData.IsSuccessful = false;
                objData.strErrorMessage = "Se ha presentado un problema. Favor de contactar al administrador";
            }
            return Json(objData);
        }

        [HttpPost]
        public JsonResult GetParams(Data objData)
        {
            try
            {
                objData = Business.PivotGetParams(objData);
                objData.IsSuccessful = true;
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/PivotDay/GetParams", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/PivotDay/GetParams", ex, true);
                objData.IsSuccessful = false;
                objData.strErrorMessage = "Se ha presentado un problema. Favor de contactar al administrador";
            }
            return Json(objData);
        }
    }
}