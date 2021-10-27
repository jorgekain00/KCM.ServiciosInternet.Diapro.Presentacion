using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using KCM.ServiciosInternet.Site.Entity.Formularios;
using CommonLibray = KCM.ServiciosInternet.Common.Library.Email;
using KCM.ServiciosInternet.Site.Entity.Config;
using System.IO;
using KCM.ServiciosInternet.Common.Library.Log;
using KCM.ServiciosInternet.Google.Services;
using KCM.ServiciosInternet.Site.Entity.Config.KleenexMascarillas;

namespace KCM.ServiciosInternet.Site.Business.Logic
{
    class Email
    {
        internal static bool enviarCorreoContacto(ContactModel objContact)
        {
            bool blcorreoEnviado = false;

            clsEscribirLog.EscribeDebug("Envio Correo contacto", clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.Email.enviarCorreoContacto", "Inicia envío correo");

            if (BussinessGoogle.isExpiredReCaptcha(strCatchapSecretKey: Global.strRecaptchaSecretKey, strCaptchaToken: objContact.recaptchaResponse, strProviderUrlValidator: Global.strRecaptchaUrlValidator))
            {
                objContact.recaptchaResponse = "Error";
                blcorreoEnviado = false;
            }
            else
            {
                string strBody = File.ReadAllText(Path.Combine(Global.strDataPath, Global.strContactTemplateEmail))
                    .Replace("${Message}$", objContact.Message)
                    .Replace("${UrlSite}$", Global.strUrlSite);

                string strAttachmentAll = null;

                string[] strAux = Global.strContactAttachmentEmail.Split(';');

                if (strAux.Length == 2)
                {
                    string strAttachmentPath = Path.Combine(Global.strDataPath, strAux[0]);

                    StringBuilder strBld = new StringBuilder();
                    foreach (string strAttachment in strAux[1].Split(','))
                    {
                        strBld.Append(Path.Combine(strAttachmentPath, strAttachment) + ";");
                    }
                    strAttachmentAll = strBld.ToString();
                }

                CommonLibray.Email.sendNormalEmailWithHTMLBody(
                    srtEmailTo: objContact.Email,
                    strEmailCC: Global.strContactEmailCC,
                    strEmailBcc: Global.strContactEmailBcc,
                    strAttachment: strAttachmentAll,
                    strBody: strBody,
                    strSender: Global.strContactFrom,
                    strSubject: Global.strContactSubject);
                blcorreoEnviado = true;
            }

            clsEscribirLog.EscribeDebug("Envio Correo contacto", clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.Email.enviarCorreoContacto", "Fin envío correo");
            return blcorreoEnviado;
        }

        internal static bool enviarCorreoContacto(ContactCasaFridaModel objContacto)
        {
            bool blcorreoEnviado = false;
            string strMessage = string.Empty;

            clsEscribirLog.EscribeDebug("Envio Correo contacto Casa Frida", clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.Email.enviarCorreoContacto", "Inicia envío correo");

            if (BussinessGoogle.isExpiredReCaptcha(strCatchapSecretKey: Global.strRecaptchaSecretKey, strCaptchaToken: objContacto.recaptchaResponse, strProviderUrlValidator: Global.strRecaptchaUrlValidator))
            {
                objContacto.recaptchaResponse = "Error";
                blcorreoEnviado = false;
            }
            else
            {

                strMessage = string.Format("<div style='border: 1px solid black'>" +
                    "<p>La organización <strong>{0}</strong></p> " +
                    "<p>por sus siglas <abbr>{1}</abbr>, RFC: <cite>{2}</cite>, Registro: <cite>{3}</cite>, representante legal <strong>{4}</strong></p>" +
                    "<p> Datos de contacto Email <cite>{5}</cite> y teléfono <cite>{6}</cite></p>" +
                    "<p> Tiene el proyecto : {7}</p>" +
                    "</div>",
                    objContacto.Organization,
                    objContacto.Acronym,
                    objContacto.RFC,
                    objContacto.ONGRegister,
                    objContacto.LegalRepresentative,
                    objContacto.Email,
                    objContacto.CellPhone,
                    objContacto.ProjectDescription);



                string strBody = File.ReadAllText(Path.Combine(Global.strDataPath, PrideFormulario.strContactTemplateEmail))
                    .Replace("${Message}$", strMessage)
                    .Replace("${UrlSite}$", Global.strUrlSite);

                string strAttachmentAll = null;

                string[] strAux = PrideFormulario.strContactAttachmentEmail.Split(';');

                if (strAux.Length == 2)
                {
                    string strAttachmentPath = Path.Combine(Global.strDataPath, strAux[0]);

                    StringBuilder strBld = new StringBuilder();
                    foreach (string strAttachment in strAux[1].Split(','))
                    {
                        strBld.Append(Path.Combine(strAttachmentPath, strAttachment) + ";");
                    }
                    strAttachmentAll = strBld.ToString();
                }

                CommonLibray.Email.sendNormalEmailWithHTMLBody(
                    srtEmailTo: objContacto.Email,
                    strEmailCC: PrideFormulario.strContactEmailCC,
                    strEmailBcc: PrideFormulario.strContactEmailBcc,
                    strAttachment: strAttachmentAll,
                    strBody: strBody,
                    strSender: PrideFormulario.strContactFrom,
                    strSubject: PrideFormulario.strContactSubject);
                blcorreoEnviado = true;
            }

            clsEscribirLog.EscribeDebug("Envio Correo contacto Casa Frida", clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.Email.enviarCorreoContacto", "Fin envío correo");
            return blcorreoEnviado;
        }

        internal static bool enviarCorreoContacto(ContactModelKleenexMascarillas objContact)
        {
            bool blcorreoEnviado = false;
            string strMessage = string.Empty;

            clsEscribirLog.EscribeDebug("Envio Correo contacto Mascarillas", clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.Email.enviarCorreoContacto", "Inicia envío correo");

            if (BussinessGoogle.isExpiredReCaptcha(strCatchapSecretKey: Global.strRecaptchaSecretKey, strCaptchaToken: objContact.recaptchaResponse, strProviderUrlValidator: Global.strRecaptchaUrlValidator))
            {
                objContact.recaptchaResponse = "Error";
                blcorreoEnviado = false;
            }
            else
            {

                strMessage = string.Format("<p><strong>{0}</strong> con número de teléfono <q>{1}</q> indica:</p><p><cite>{2}</cite></p>", objContact.Name, objContact.Phone, objContact.Message);

                string strBody = File.ReadAllText(Path.Combine(Global.strDataPath, Global.strContactTemplateEmail))
                    .Replace("${Message}$", strMessage)
                    .Replace("${UrlSite}$", Global.strUrlSite);

                string strAttachmentAll = null;

                string[] strAux = Global.strContactAttachmentEmail.Split(';');

                if (strAux.Length == 2)
                {
                    string strAttachmentPath = Path.Combine(Global.strDataPath, strAux[0]);

                    StringBuilder strBld = new StringBuilder();
                    foreach (string strAttachment in strAux[1].Split(','))
                    {
                        strBld.Append(Path.Combine(strAttachmentPath, strAttachment) + ";");
                    }
                    strAttachmentAll = strBld.ToString();
                }

                CommonLibray.Email.sendNormalEmailWithHTMLBody(
                    srtEmailTo: objContact.Email,
                    strEmailCC: Global.strContactEmailCC,
                    strEmailBcc: Global.strContactEmailBcc,
                    strAttachment: strAttachmentAll,
                    strBody: strBody,
                    strSender: Global.strContactFrom,
                    strSubject: Global.strContactSubject);
                blcorreoEnviado = true;
            }

            clsEscribirLog.EscribeDebug("Envio Correo contacto Mascarillas", clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.Email.enviarCorreoContacto", "Fin envío correo");
            return blcorreoEnviado;
        }

    }
}
