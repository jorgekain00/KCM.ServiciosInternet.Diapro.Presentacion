using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace KCM.ServiciosInternet.Site.Entity.Config.KleenexMascarillas
{
    public static class PrideFormulario
    {
        public static string strContactEmailCC
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("PrideFormulario::ContactEmailCC").ToString();
            }
        }
        public static string strContactEmailBcc
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("PrideFormulario::ContactEmailBcc").ToString();
            }
        }
        public static string strContactSubject
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("PrideFormulario::ContactSubject").ToString();
            }
        }
        public static string strContactFrom
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("PrideFormulario::ContactFrom").ToString();
            }
        }
        public static string strContactTemplateEmail
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("PrideFormulario::ContactTemplateEmail").ToString();
            }
        }
        public static string strContactAttachmentEmail
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("PrideFormulario::ContactAttachmentEmail").ToString();
            }
        }
    }
}
