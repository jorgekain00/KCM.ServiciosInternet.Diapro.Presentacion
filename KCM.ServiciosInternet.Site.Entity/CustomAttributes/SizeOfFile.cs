using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace KCM.ServiciosInternet.Site.Entity.CustomAttributes
{
    class SizeOfFile : ValidationAttribute
    {
        public int Size = 0;
        public override bool IsValid(object value)
        {

            HttpPostedFileWrapper objFile = value as HttpPostedFileWrapper;

            if (objFile != null)
            {
                return objFile.ContentLength <= this.Size;
            }
            return false;
        }
    }
}
