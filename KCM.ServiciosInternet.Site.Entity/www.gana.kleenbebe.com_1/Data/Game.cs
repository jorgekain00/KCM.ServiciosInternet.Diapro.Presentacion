using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace KCM.ServiciosInternet.Site.Entity.www.gana.kleenbebe.com_1.Data
{
    [DataContract]
    public class Game
    {
        [DataMember]
        public int Id_PivotDay { get; set; }
        [DataMember]
        public long Id_Game { get; set; }
        [DataMember]
        public int? Id_GameInfo { get; set; }
        [DataMember]
        public List<string> collection { get; set; }
        [DataMember]
        public string Time { get; set; }
    }
}
