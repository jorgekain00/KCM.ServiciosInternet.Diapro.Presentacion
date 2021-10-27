using KCM.ServiciosInternet.Common.Library.Log;
using KCM.ServiciosInternet.Site.Business;
using KCM.ServiciosInternet.Site.Entity.www.gana.kleenbebe.com_1.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace KCM.ServiciosInternet.ganaKleenbebe.FrontEnd.Controllers
{
    public class GamesController : Controller
    {
        #region RETURN VIEWS
        public ActionResult Index(string id)
        {
            try
            {
                if (Request.UrlReferrer.LocalPath.ToString().ToLower() == "/Ticket".ToLower() || Request.UrlReferrer.LocalPath.ToString().ToLower() == "/Ticket/Index".ToLower())
                {
                    string strPath = Business.GetGamePathInfo();
                    if (string.IsNullOrEmpty(strPath))
                    {
                        TempData["ErrorMessage"] = string.Format("Not path info from GetGameInfo");
                        return RedirectToAction("Error", "Home");
                    }
                    else
                    {
                        TempData["UID"] = id;
                        return Redirect(strPath);
                    }
                }
                else
                {
                    return RedirectToAction("Index", "Ticket");
                }
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/Games/Index", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/Games/Index", ex, true);
            }
            TempData["ErrorMessage"] = string.Format("An exception ocurred");
            return RedirectToAction("Error", "Home");
        }

        public ActionResult SoupLetters()
        {
            try
            {
                Data objData = new Data();
                objData.strUID = string.Empty;


                if (TempData["UID"] != null)
                {
                    objData.strUID = TempData["UID"].ToString();
                    if ((Request.UrlReferrer.LocalPath.ToString().ToLower() == "/Ticket".ToLower() || Request.UrlReferrer.LocalPath.ToString().ToLower() == "/Ticket/Index".ToLower()) && !string.IsNullOrEmpty(objData.strUID))
                    {
                        objData = Business.getAttemps(objData);
                        if ((int)objData.Body > 0)
                        {
                            return View(objData);
                        }
                        else
                        {
                            return RedirectToAction("Index", "Ticket");
                        }
                    }
                    else
                    {
                        return RedirectToAction("Index", "Ticket");
                    }
                }
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/Games/SoupLetters", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/Games/SoupLetters", ex, true);
            }
            TempData["ErrorMessage"] = string.Format("An exception ocurred");
            return RedirectToAction("Error", "Home");
        }

        public ActionResult SearchThings()
        {
            try
            {
                Data objData = new Data();
                objData.strUID = string.Empty;


                if (TempData["UID"] != null)
                {
                    objData.strUID = TempData["UID"].ToString();
                    if ((Request.UrlReferrer.LocalPath.ToString().ToLower() == "/Ticket".ToLower() || Request.UrlReferrer.LocalPath.ToString().ToLower() == "/Ticket/Index".ToLower()) && !string.IsNullOrEmpty(objData.strUID))
                    {
                        objData = Business.getAttemps(objData);
                        if ((int)objData.Body > 0)
                        {
                            return View(objData);
                        }
                        else
                        {
                            return RedirectToAction("Index", "Ticket");
                        }
                    }
                    else
                    {
                        return RedirectToAction("Index", "Ticket");
                    }
                }
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/Games/SoupLetters", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/Games/SoupLetters", ex, true);
            }
            TempData["ErrorMessage"] = string.Format("An exception ocurred");
            return RedirectToAction("Error", "Home");
        }

        public ActionResult MyScore()
        {
            try
            {
                if ((Request.UrlReferrer.LocalPath.ToString().ToLower() == "/Ticket".ToLower() || Request.UrlReferrer.LocalPath.ToString().ToLower() == "/Ticket/Index".ToLower()))
                {
                    return View();
                }
                else
                {
                    return RedirectToAction("Index", "Ticket");
                }
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/Games/MyScore", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/Games/MyScore", ex, true);
            }
            TempData["ErrorMessage"] = string.Format("An exception ocurred");
            return RedirectToAction("Error", "Home");
        }
        #endregion
        #region RETURN JSON RESPONSE
        [HttpPost]
        public JsonResult getGame(Data objData)
        {
            try
            {
                objData = Business.GetGame(objData);
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/Games/getGame", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/Games/getGame", ex, true);
            }
            return Json(objData);
        }

        [HttpPost]
        public JsonResult SaveGame(Data objData)
        {
            try
            {
                objData = Business.SaveGame(objData);
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/Games/SaveGame", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/Games/SaveGame", ex, true);
            }
            return Json(objData);
        }

        [HttpPost]
        public JsonResult GetTemplate(Data objData)
        {
            try
            {
                objData = Business.GetTemplate(objData);
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/Games/GetTemplate", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/Games/GetTemplate", ex, true);
                objData.IsSuccessful = false;
                objData.strErrorMessage = "No se pudo cargar el juego, favor de contactar al administrador";
            }
            return Json(objData);
        }

        [HttpPost]
        public JsonResult GetScore(Data objData)
        {
            try
            {
                objData = Business.GetScore(objData);
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/Games/GetTemplate", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/Games/GetTemplate", ex, true);
                objData.IsSuccessful = false;
                objData.strErrorMessage = "No se pudo obtener información de putuaje, favor de contactar al administrador";
            }
            return Json(objData);
        }
        #endregion
    }
}