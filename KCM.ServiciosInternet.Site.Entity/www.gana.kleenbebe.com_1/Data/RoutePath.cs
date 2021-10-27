using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace KCM.ServiciosInternet.Site.Entity.www.gana.kleenbebe.com_1.Data
{
    [DataContract]
    public class RoutePath
    {
        [DataMember]
        public string strSiteKey { get; set; }
        [DataMember]
        public string strPath { get; set; }
        [DataMember]
        public string strRoles { get; set; }
        [DataMember]
        public bool IsFound { get; set; }
        [DataMember]
        public bool IsAuthenticated { get; set; }
        [DataMember]
        public bool IsRoleValid { get; set; }
        [DataMember]
        public bool isSuccessful { get; set; }
        [DataMember]
        public string strReason { get; set; }
    }
}
