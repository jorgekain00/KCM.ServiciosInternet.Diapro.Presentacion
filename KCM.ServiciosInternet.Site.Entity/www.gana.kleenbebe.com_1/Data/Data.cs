using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace KCM.ServiciosInternet.Site.Entity.www.gana.kleenbebe.com_1.Data
{
    [DataContract]
    public class Data
    {
        [DataMember]
        public string strModel { get; set; }
        [DataMember]
        public bool IsSuccessful { get; set; }
        [DataMember]
        public string strErrorMessage { get; set; }
        [DataMember]
        public string strUID { get; set; }
        [DataMember]
        public object Body { get; set; }
    }
}
