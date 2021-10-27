using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using KCM.ServiciosInternet.Common.Library.Log;
using KCM.ServiciosInternet.Site.Business;
using KCM.ServiciosInternet.Site.Entity.www.gana.kleenbebe.com_1.Formularios;
using KCM.ServiciosInternet.Site.Entity.www.gana.kleenbebe.com_1.Data;

namespace KCM.ServiciosInternet.ganaKleenbebe.FrontEnd.Controllers
{
    public class TicketController : Controller
    {
        // GET: Ticket
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public JsonResult registerTicket(TicketModel objTicket)
        {
            Data objData = new Data();
            try
            {
                if (ModelState.IsValid)
                {

                    objData = Business.ProcessTicket(objTicket);
                }
                else
                {
                    foreach (ModelState objState in ModelState.Values)
                    {
                        foreach (ModelError objError in objState.Errors)
                        {
                            objData.strErrorMessage += objError.ErrorMessage + "<b\\>";
                        }
                    }
                    objData.IsSuccessful = false;
                }
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/Ticket/registerTicket", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/Ticket/registerTicket", ex, true);
                objData.IsSuccessful = false;
                objData.strErrorMessage = "Se ha presentado un problema. Favor de contactar al administrador";
            }
            objData.strModel = typeof(TicketModel).ToString();
            return Json(objData);
        }
        [HttpPost]
        public JsonResult getAttemps(Data objData)
        {
            try
            {
                objData = Business.getAttemps(objData);
                objData.IsSuccessful = true;
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/Ticket/getAttempst", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/Ticket/getAttempst", ex, true);
                objData.IsSuccessful = false;
                objData.strErrorMessage = "Se ha presentado un problema. Favor de contactar al administrador";
            }
            return Json(objData);
        }
        
        [HttpPost]
        public PartialViewResult getAttempstView(Data objData)
        {
            try
            {
                objData = Business.getAttemps(objData);
                objData.IsSuccessful = true;

            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/Ticket/getAttempstView", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/Ticket/getAttempstView", ex, true);
                objData.IsSuccessful = false;
                objData.strErrorMessage = "Se ha presentado un problema. Favor de contactar al administrador";
            }
            return PartialView("_Intentos", objData);
        }
    }
}