//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace KCM.ServiciosInternet.Site.Entity.www.gana.kleenbebe.com_1.BD.EF
{
    using System;
    using System.Collections.Generic;
    
    public partial class GameInfo
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public GameInfo()
        {
            this.PivotDays = new HashSet<PivotDay>();
        }
    
        public int IdGameinfo { get; set; }
        public string Description { get; set; }
        public string Path { get; set; }
        public string DevelopedBy { get; set; }
        public System.DateTime CreationDate { get; set; }
        public string IdParam { get; set; }
    
        public virtual Param Param { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PivotDay> PivotDays { get; set; }
    }
}
