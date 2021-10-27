using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace KCM.ServiciosInternet.Site.Entity.SSO
{
    public class Data
    {
        /// <summary>
        /// Unique Id or Email
        /// </summary>
        public string strEmail { get; set; }
        /// <summary>
        /// Password 
        /// </summary>
        public string strPassword { get; set; }
        /// <summary>
        /// User id
        /// </summary>
        public string strUID { get; set; }
        /// <summay>
        /// Profile value-pair fields
        /// </summary>
        public string strProfile { get; set; }
        /// <summay>
        /// Data value-pair fields
        /// </summary>
        public string strData { get; set; }
        /// <summary>
        /// List of Extra profile fields Descriptor
        /// </summary>
        public string strExtraProfileFieldsDescriptor { get; set; }
        /// <summary>
        /// List of value-pair Extra fields
        /// </summary>
        public string strExtraProfileFields { get; set; }
        /// <summary>
        /// Is Account Pending Registration due to missing values
        /// </summary>
        public bool boolIsAccountPendingRegistration { get; set; }
        /// <summary>
        /// Is Account Pending Email verification
        /// </summary>
        public bool boolIsAccountPendingVerification { get; set; }
        /// <summary>
        /// Error messages
        /// </summary>
        public string strErrormessage { get; set; }
        /// <summary>
        /// Token For registration or other accounts commands
        /// </summary>
        public string strRegToken { get; set; }
        /// <summary>
        /// Provider
        /// </summary>
        public string strLoginProvider { get; set; }
        /// <summary>
        /// Operation Result
        /// </summary>
        public bool isSuccessful { get; set; }
        /// <summary>
        /// Session is Expired
        /// </summary>
        public bool isExpiredSession { get; set; }
        /// <summary>
        /// ReCaptcha token
        /// </summary>
        public string strReCaptchaToken { get; set; }
        /// <summary>
        /// Custom SiteKey
        /// </summary>
        public string strSiteKey { get; set; }
        /// <summary>
        /// Source of the register
        /// </summary>
        public string strRegSource { get; set; }


        public void getDataFromDictionary(Dictionary<string,object> objDic)
        {
                foreach (KeyValuePair<string, object> objItem in objDic)
                {
                    this.GetType().GetProperty(objItem.Key).SetValue(this, objItem.Value);
                }
        }
    }
}
