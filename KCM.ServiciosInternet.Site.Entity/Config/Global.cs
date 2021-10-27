using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;


namespace KCM.ServiciosInternet.Site.Entity.Config
{
    public static class Global
    {
        public static string strUrlSite
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("Global::UrlSite").ToString();
            }
        }
        public static string strDataPath
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("Global::DataPath").ToString();
            }
        }
        public static string strContactEmailCC
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("Global::ContactEmailCC").ToString();
            }
        }
        public static string strContactEmailBcc
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("Global::ContactEmailBcc").ToString();
            }
        }
        public static string strContactSubject
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("Global::ContactSubject").ToString();
            }
        }
        public static string strContactFrom
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("Global::ContactFrom").ToString();
            }
        }
        public static string strContactTemplateEmail
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("Global::ContactTemplateEmail").ToString();
            }
        }
        public static string strContactAttachmentEmail
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("Global::ContactAttachmentEmail").ToString();
            }
        }
        public static string strRecaptchaSecretKey
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("Global::RecaptchaSecretKey").ToString();
            }
        }
        public static string strRecaptchaSiteKey
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("Global::RecaptchaSiteKey").ToString();
            }
        }
        public static string strRecaptchaUrlValidator
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("Global::RecaptchaUrlValidator").ToString();
            }
        }
        public static bool blIsDebug
        {
            get
            {
                return Convert.ToBoolean(ConfigurationManager.AppSettings.Get("Global::IsDebug").ToString());
            }
        }
        public static string strUrlSSOService
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("Global::UrlSSOService").ToString();
            }
        }
        public static string strSSOgetSession
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("Global::SSOgetSession").ToString();
            }
        }

        public static string strSSOapiKey
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("Global::SSOapiKey").ToString();
            }
        }
        public static string strSSOExtraProfileFieldsDescriptor
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("Global::SSOExtraProfileFieldsDescriptor").ToString();
            }
        }

        public static int intAdminRowsByPage
        {
            get
            {
                return Convert.ToInt32(ConfigurationManager.AppSettings.Get("Global::AdminRowsByPage").ToString());
            }
        }
        public static string strSSOCryptoKey
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("Global::SSOCryptoKey").ToString();
            }
        }public static string strUrlSSOLogin
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("Global::UrlSSOLogin").ToString();
            }
        }
        public static int strSSOExpirationTime
        {
            get
            {
                return Convert.ToInt32(ConfigurationManager.AppSettings.Get("Global::SSOExpirationTime").ToString());
            }
        }
        public static int strSessionMinutes
        {
            get
            {
                return Convert.ToInt32(ConfigurationManager.AppSettings.Get("Global::SessionMinutes").ToString());
            }
        }
    }
}
