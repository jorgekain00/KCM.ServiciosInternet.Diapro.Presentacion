using KCM.ServiciosInternet.Common.Library.Encryption;
using KCM.ServiciosInternet.Common.Library.Log;
using KCM.ServiciosInternet.Site.Business;
using KCM.ServiciosInternet.Site.Entity.Config;
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
        private string strDateNow = DateTime.Now.ToString();
        // GET: Register
        public ActionResult Index()
        {
            try
            {
                string strUrlReferRoute = (Request.UrlReferrer == null) ? "/Home/Index" : Request.UrlReferrer.LocalPath;
                string strQueryString = $"?siteKey={HttpUtility.UrlEncode(Global.strSSOapiKey)}&version=1.0&closeSession=false";
                strQueryString = strQueryString + "&returnUrl=" + HttpUtility.UrlEncode(strUrlReferRoute);
                return Redirect(Global.strUrlSSOLogin + strQueryString);
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(strDateNow, clsEscribirLog.enumTipoMensaje.Informativo, "/Register/Index", "An exception ocurred");
                clsEscribirLog.EscribeLog(strDateNow, clsEscribirLog.enumTipoMensaje.Excepcion, "/Register/Index", ex, true);
            }
            TempData["ErrorMessage"] = string.Format("Not redirect to SSO");
            return RedirectToAction("Error", "Home");
        }
        public ActionResult CloseSession()
        {
            try
            {
                if (Request.Cookies[Global.strSSOapiKey] != null)
                {
                    HttpCookie objCookie = Request.Cookies[Global.strSSOapiKey];
                    objCookie.Expires = DateTime.Now.AddDays(-2);
                    Response.Cookies.Add(objCookie);
                    Request.Cookies.Remove(objCookie.Name);
                }

                string strUrlReferRoute = (Request.UrlReferrer == null) ? "/Home/Index" : Request.UrlReferrer.LocalPath;
                string strQueryString = $"?siteKey={HttpUtility.UrlEncode(Global.strSSOapiKey)}&version=1.0&closeSession=true";
                strQueryString = strQueryString + "&returnUrl=" + HttpUtility.UrlEncode(strUrlReferRoute);
                return Redirect(Global.strUrlSSOLogin + strQueryString);
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(strDateNow, clsEscribirLog.enumTipoMensaje.Informativo, "/Register/CloseSession", "An exception ocurred");
                clsEscribirLog.EscribeLog(strDateNow, clsEscribirLog.enumTipoMensaje.Excepcion, "/Register/CloseSession", ex, true);
            }
            TempData["ErrorMessage"] = string.Format("Not redirect to SSO for closing session");
            return RedirectToAction("Error", "Home");

        }
        public ActionResult GenerateSession()
        {
            try
            {
                if (Global.strUrlSSOLogin.IndexOf(Request.UrlReferrer.Host) > -1 && Request.QueryString["ReturnUrl"] != null && Request.QueryString["UID"] != null)
                {
                    string strReturnUrl = Request.QueryString["ReturnUrl"];
                    string strUID = Request.QueryString["UID"];
                    string strDecodeUID = AesOperation.DecryptString(Global.strSSOCryptoKey, strUID);
                    HttpCookie objCookie = new HttpCookie(Global.strSSOapiKey, strDecodeUID);
                    objCookie.Expires = DateTime.Now.AddMinutes(Global.strSSOExpirationTime);
                    objCookie.HttpOnly = true;
                    objCookie.Path = "/";
                    objCookie.SameSite = SameSiteMode.None;
                    objCookie.Secure = true;
                    Response.Cookies.Add(objCookie);
                    return Redirect($"{Global.strUrlSite}{strReturnUrl}");
                }
                else
                {
                    TempData["ErrorMessage"] = string.Format("Generate Session: Missing queryStrings or UriRefer invalid - " + Request.UrlReferrer.AbsoluteUri + " - Query" + Request.QueryString.ToString());
                    return RedirectToAction("Error", "Home");
                }
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(strDateNow, clsEscribirLog.enumTipoMensaje.Informativo, "/Register/GenerateSession", "An exception ocurred");
                clsEscribirLog.EscribeLog(strDateNow, clsEscribirLog.enumTipoMensaje.Excepcion, "/Register/GenerateSession", ex, true);
            }
            TempData["ErrorMessage"] = string.Format("Can not generate session");
            return RedirectToAction("Error", "Home");
        }


        public ActionResult LogIn()
        {
            return View();
        }


        [HttpPost]
        public JsonResult GetSession()
        {
            Data objData = new Data();
            try
            {

                if (Request.Cookies[Global.strSSOapiKey] != null)
                {
                    HttpCookie objCookie = Request.Cookies[Global.strSSOapiKey];
                    objCookie.Expires = DateTime.Now.AddMinutes(Global.strSSOExpirationTime);
                    objCookie.HttpOnly = true;
                    objCookie.Path = "/";
                    objCookie.SameSite = SameSiteMode.None;
                    objCookie.Secure = true;
                    Response.Cookies.Add(objCookie);
                    objData.Body = objCookie.Value;
                    objData.IsSuccessful = true;
                }
                else
                {
                    objData.IsSuccessful = false;
                    objData.strErrorMessage = "No hay sesión activa";
                }
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(strDateNow, clsEscribirLog.enumTipoMensaje.Informativo, "/Register/GetSession", "An exception ocurred");
                clsEscribirLog.EscribeLog(strDateNow, clsEscribirLog.enumTipoMensaje.Excepcion, "/Register/GetSession", ex, true);
                objData.IsSuccessful = false;
                objData.strErrorMessage = "Ha ocurrido un problema con el redireccionamiento. Favor de contactar con su administrador";
            }
            return Json(objData);
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
                    TempData["ErrorMessage"] = string.Format("Unregistered path '{0}' in the SSO", objRP.strPath);
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

        [HttpPost]
        public JsonResult LogInSession(string email, string password, string recaptcha)
        {
            Data objData = new Data();
            objData.strUID = JsonConvert.SerializeObject(new { email, password });
            objData.Body = recaptcha;
            try
            {
                objData = Business.sendAdminCredentials(objData);
                if (objData.IsSuccessful)
                {
                    HttpCookie objCookie = new HttpCookie("userSession", JsonConvert.SerializeObject(objData.Body)); // serialize Session_GetAdminUser_Result object
                    objCookie.Expires = DateTime.Now.AddMinutes(Global.strSessionMinutes);
                    objCookie.HttpOnly = true;
                    objCookie.Secure = true;
                    Response.Cookies.Add(objCookie);
                    objData.Body = "/Winners/Index";
                }
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/Register/LogInSession", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/Register/LogInSession", ex, true);
                objData.IsSuccessful = false;
                objData.strErrorMessage = "Se ha presentado un problema. Favor de contactar al administrador";
            }
            return Json(objData);
        }

        [HttpPost]
        public JsonResult GetAdminSession()
        {
            Data objData = new Data();
            try
            {
                HttpCookie objCookie = Request.Cookies["userSession"];

                if (objCookie == null)
                {
                    objData.IsSuccessful = false;
                    objData.strErrorMessage = "Su sesión ha expirado";
                    objData.Body = "/Register/LogIn";
                }
                else
                {
                    objCookie.Expires = DateTime.Now.AddMinutes(Global.strSessionMinutes);
                    objCookie.HttpOnly = true;
                    objCookie.Secure = true;
                    Response.Cookies.Add(objCookie);
                    objData.IsSuccessful = true;
                    objData.Body = JsonConvert.DeserializeObject<Site.Entity.www.gana.kleenbebe.com_1.BD.EF.Session_GetAdminUser_Result>(objCookie.Value).Email;
                }
            }
            catch (Exception ex)
            {
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "/Register/GetAdminSession", "An exception ocurred");
                clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "/Register/GetAdminSession", ex, true);
                objData.IsSuccessful = false;
                objData.strErrorMessage = "Se ha presentado un problema. Favor de contactar al administrador";
            }
            return Json(objData);
        }
    }
}