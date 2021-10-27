using KCM.ServiciosInternet.Site.Business.Logic;
using KCM.ServiciosInternet.Site.Entity.Formularios;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using KCM.ServiciosInternet.Common.Library.Log;
using KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe;
using KCM.ServiciosInternet.Site.Entity.www.gana.kleenbebe.com_1.Data;
using KCM.ServiciosInternet.Site.Entity.www.gana.kleenbebe.com_1.Formularios;
using EF =  KCM.ServiciosInternet.Site.Entity.www.gana.kleenbebe.com_1.BD.EF;

namespace KCM.ServiciosInternet.Site.Business
{
    public class Business
    {

        public static bool enviarCorreoContacto(ContactModel objContact)
        {
            bool envioCorreo = false;
            clsEscribirLog.EscribeDebug("Envio Correo contacto", clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Business.enviarCorreoContacto", "Inicia envío correo");
            envioCorreo = Email.enviarCorreoContacto(objContact);
            clsEscribirLog.EscribeDebug("Envio Correo contacto", clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Business.enviarCorreoContacto", "Fin envío correo");

            return envioCorreo;
        }
        
        public static bool enviarCorreoContacto(ContactCasaFridaModel objContacto)
        {
            bool envioCorreo = false;
            clsEscribirLog.EscribeDebug("Envio Correo contacto Casa Frida", clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Business.enviarCorreoContacto", "Inicia envío correo");
            envioCorreo = Email.enviarCorreoContacto(objContacto);
            clsEscribirLog.EscribeDebug("Envio Correo contacto Casa Frida", clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Business.enviarCorreoContacto", "Fin envío correo");

            return envioCorreo;
        }

        public static bool enviarCorreoContacto(ContactModelKleenexMascarillas objContacto)
        {
            bool envioCorreo = false;
            clsEscribirLog.EscribeDebug("Envio Correo contacto Mascarillas", clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Business.enviarCorreoContacto", "Inicia envío correo");
            envioCorreo = Email.enviarCorreoContacto(objContacto);
            clsEscribirLog.EscribeDebug("Envio Correo contacto Mascarillas", clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Business.enviarCorreoContacto", "Fin envío correo");

            return envioCorreo;
        }



        #region GANAKLEENBEBE
        public static Data ProcessTicket(TicketModel objTicket)
        {
            using (GanaKleenbebe objGK = new GanaKleenbebe())
            {
                return objGK.ProcessTicket(objTicket);
            }
        }

        public static Data GetGame(Data objData)
        {
            using (GanaKleenbebe objGK = new GanaKleenbebe())
            {
                return objGK.GetGame(objData);
            }
        }

        public static Data getAttemps(Data objData)
        {
            using (GanaKleenbebe objGK = new GanaKleenbebe())
            {
                return objGK.GetAttemps(objData);
            }
        }

      

        public static string GetGamePathInfo()
        {
            using (GanaKleenbebe objGK = new GanaKleenbebe())
            {
                return objGK.GetGamePathInfo();
            }
        }

        public static Data SaveGame(Data objData)
        {
            using (GanaKleenbebe objGK = new GanaKleenbebe())
            {
                return objGK.SaveGame(objData);
            }
        }

        public static Data GetTemplate(Data objData)
        {
            using (GanaKleenbebe objGK = new GanaKleenbebe())
            {
                return objGK.GetTemplate(objData);
            }
        }

        public static Data GetScore(Data objData)
        {
            using (GanaKleenbebe objGK = new GanaKleenbebe())
            {
                return objGK.GetScore(objData);
            }
        }


        #endregion

        #region ADMIN GANAKLEENBEBE
        public static Data WinnersGetRangeDates(Data objData)
        {
            using (Admin objGK = new Admin())
            {
                return objGK.WinnersGetRangeDates(objData);
            }
        }
        public static Data WinnersGetTickets(Data objData)
        {
            using (Admin objGK = new Admin())
            {
                return objGK.WinnersGetTickets(objData);
            }
        }
        public static Data WinnersGetGamesByTicket(Data objData)
        {
            using (Admin objGK = new Admin())
            {
                return objGK.WinnersGetGamesByTicket(objData);
            }
        }

        

        public static Data WinnersUpdateLockPivotDay(Data objData,string strEmail)
        {
            using (Admin objGK = new Admin())
            {
                return objGK.WinnersUpdateLockPivotDay(objData, strEmail);
            }
        }

        public static Data WinnersUpdateTicketByPivotDay(Data objData)
        {
            using (Admin objGK = new Admin())
            {
                return objGK.WinnersUpdateTicketByPivotDay(objData);
            }
        }
        public static Data WinnersGetAllTicketsInExcel(Data objData)
        {
            using (Admin objGK = new Admin())
            {
                return objGK.WinnersGetAllTicketsInExcel(objData);
            }
        }

        public static Data WinnersGetTicketImage(Data objData)
        {
            using (Admin objGK = new Admin())
            {
                return objGK.WinnersGetTicketImage(objData);
            }
        }

        public static Data WinnersUpdateTickets(Data objData, string strEmail)
        {
            using (Admin objGK = new Admin())
            {
                return objGK.WinnersUpdateTickets(objData, strEmail);
            }
        }

        public static Data WinnersGetUserRecords(Data objData)
        {
            using (Admin objGK = new Admin())
            {
                return objGK.WinnersGetUserRecords(objData);
            }
        }

        public static Data sendAdminCredentials(Data objData)
        {
            using (Admin objGK = new Admin())
            {
                return objGK.sendAdminCredentials(objData);
            }
        }

        public static Data PivotGetPivotDays(Data objData)
        {
            using (Admin objGK = new Admin())
            {
                return objGK.PivotGetPivotDays(objData);
            }
        }


        public static Data PivotUpdatePivotDay(EF.Pivot_GetPivotDays_Result objPivot)
        {
            using (Admin objGK = new Admin())
            {
                return objGK.PivotUpdatePivotDay(objPivot);
            }
        }

        public static Data PivotDeletePivotDay(Data objData)
        {
            using (Admin objGK = new Admin())
            {
                return objGK.PivotDeletePivotDay(objData);
            }
        }

        public static Data PivotGetGameInfo(Data objData)
        {
            using (Admin objGK = new Admin())
            {
                return objGK.PivotGetGameInfo(objData);
            }
        }

        public static Data PivotGetParams(Data objData)
        {
            using (Admin objGK = new Admin())
            {
                return objGK.PivotGetParams(objData);
            }
        }
        #endregion

        #region COMMON METHODS
        #endregion

    }
}
