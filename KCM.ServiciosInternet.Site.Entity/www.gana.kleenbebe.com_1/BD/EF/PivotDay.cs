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
    
    public partial class PivotDay
    {
        public int Id { get; set; }
        public System.DateTime PivotDate { get; set; }
        public int IdGameinfo { get; set; }
        public bool IsProcessed { get; set; }
        public int Days { get; set; }
        public string IdParam { get; set; }
        public System.DateTime CreationDate { get; set; }
        public string Closeby { get; set; }
        public Nullable<System.DateTime> ClosebyDate { get; set; }
    
        public virtual GameInfo GameInfo { get; set; }
        public virtual Param Param { get; set; }
    }
}
