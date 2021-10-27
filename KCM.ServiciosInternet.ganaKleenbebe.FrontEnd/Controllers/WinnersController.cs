using KCM.ServiciosInternet.Common.Library.Log;
using KCM.ServiciosInternet.Site.Business;
using KCM.ServiciosInternet.Site.Entity.Config;
using KCM.ServiciosInternet.Site.Entity.www.gana.kleenbebe.com_1.Data;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;

namespace KCM.ServiciosInternet.ganaKleenbebe.FrontEnd.Controllers
{
    public class WinnersController : Controller
    {
        // GET: Winners
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
                    objCookie.Expires = DateTime.Now.AddMinutes(Global.strSessionMinutes);
                    objCookie.HttpOnly = true;
                    objCookie.Secure = true;
                    Response.Cookies.Add(objCookie);
                    return View();
                }
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/Winners/Index", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/Winners/Index", ex, true);
            }
            TempData["ErrorMessage"] = string.Format("An exception ocurred");
            return RedirectToAction("Error", "Home");
        }

        [HttpPost]
        public JsonResult GetRangeDates(Data objData)
        {
            try
            {
                objData = Business.WinnersGetRangeDates(objData);
                objData.IsSuccessful = true;
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/Winners/GetRangeDates", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/Winners/GetRangeDates", ex, true);
                objData.IsSuccessful = false;
                objData.strErrorMessage = "Se ha presentado un problema. Favor de contactar al administrador";
            }
            return Json(objData);
        }

        [HttpPost]
        public JsonResult GetTickets(Data objData)
        {
            try
            {
                objData = Business.WinnersGetTickets(objData);
                objData.IsSuccessful = true;
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/Winners/GetTickets", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/Winners/GetTickets", ex, true);
                objData.IsSuccessful = false;
                objData.strErrorMessage = "Se ha presentado un problema. Favor de contactar al administrador";
            }
            return Json(objData);
        }

        [HttpPost]
        public JsonResult GetGamesByTicket(Data objData)
        {
            try
            {
                objData = Business.WinnersGetGamesByTicket(objData);
                objData.IsSuccessful = true;
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/Winners/GetGamesByTicket", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/Winners/GetGamesByTicket", ex, true);
                objData.IsSuccessful = false;
                objData.strErrorMessage = "Se ha presentado un problema. Favor de contactar al administrador";
            }
            return Json(objData);
        }

        [HttpPost]
        public JsonResult UpdateTicketByPivotDay(Data objData)
        {
            try
            {
                objData = Business.WinnersUpdateTicketByPivotDay(objData);
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/Winners/UpdateTicketByPivotDay", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/Winners/UpdateTicketByPivotDay", ex, true);
                objData.IsSuccessful = false;
                objData.strErrorMessage = "Se ha presentado un problema. Favor de contactar al administrador";
            }
            return Json(objData);
        }
        [HttpPost]
        public JsonResult UpdateTickets(Data objData)
        {
            try
            {
                HttpCookie objCookie = Request.Cookies["userSession"];

                if (objCookie == null)
                {
                    objData.IsSuccessful = false;
                    objData.strErrorMessage = "La sesión ha caducado. Vuelva a iniciar sesión";
                }
                else
                {

                    objData = Business.WinnersUpdateTickets(objData, JsonConvert.DeserializeObject<Site.Entity.www.gana.kleenbebe.com_1.BD.EF.Session_GetAdminUser_Result>(objCookie.Value).Email);
                }
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/Winners/UpdateTickets", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/Winners/UpdateTickets", ex, true);
                objData.IsSuccessful = false;
                objData.strErrorMessage = "Se ha presentado un problema. Favor de contactar al administrador";
            }
            return Json(objData);
        }

        [HttpPost]
        public JsonResult UpdateLockPivotDay(Data objData)
        {
            try
            {
                HttpCookie objCookie = Request.Cookies["userSession"];

                if (objCookie == null)
                {
                    objData.IsSuccessful = false;
                    objData.strErrorMessage = "La sesión ha caducado. Vuelva a iniciar sesión";
                }
                else
                {

                    objData = Business.WinnersUpdateLockPivotDay(objData, JsonConvert.DeserializeObject<Site.Entity.www.gana.kleenbebe.com_1.BD.EF.Session_GetAdminUser_Result>(objCookie.Value).Email);
                }
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/Winners/UpdateLockPivotDay", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/Winners/UpdateLockPivotDay", ex, true);
                objData.IsSuccessful = false;
                objData.strErrorMessage = "Se ha presentado un problema. Favor de contactar al administrador";
            }
            return Json(objData);
        }

        [HttpPost]
        public JsonResult GetTicketImage(Data objData)
        {
            try
            {
                objData = Business.WinnersGetTicketImage(objData);
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/Winners/GetTicketImage", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/Winners/GetTicketImage", ex, true);
                objData.IsSuccessful = false;
                objData.strErrorMessage = "Se ha presentado un problema. Favor de contactar al administrador";
            }
            return Json(objData);
        }

        [HttpPost]
        public FileResult GetAllTicketsInExcel(Data objData)
        {
            Stream objMStr;
            try
            {
                objData = Business.WinnersGetAllTicketsInExcel(objData);
                if (objData.IsSuccessful)
                {
                    objMStr = objData.Body as MemoryStream;
                    objMStr.Position = 0;
                    return File(objMStr, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                }

            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/Winners/GetAllTicketsInExcel", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/Winners/GetAllTicketsInExcel", ex, true);
                objData.IsSuccessful = false;
                objData.strErrorMessage = "Se ha presentado un problema. Favor de contactar al administrador";
            }

            return File(Encoding.UTF8.GetBytes(objData.strErrorMessage), "text/plain");
        }

        [HttpPost]
        public FileResult GetUserRecords(Data objData)
        {
            Stream objMStr;
            try
            {
                objData = Business.WinnersGetUserRecords(objData);
                if (objData.IsSuccessful)
                {
                    objMStr = objData.Body as FileStream;
                    return File(objMStr, "application/zip");
                }

            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/Winners/GetUserRecords", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/Winners/GetUserRecords", ex, true);
                objData.IsSuccessful = false;
                objData.strErrorMessage = "Se ha presentado un problema. Favor de contactar al administrador";
            }

            return File(Encoding.UTF8.GetBytes(objData.strErrorMessage), "text/plain");
        }
    }
}