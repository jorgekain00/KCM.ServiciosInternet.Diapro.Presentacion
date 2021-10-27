using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace KCM.ServiciosInternet.Site.Entity.CustomAttributes
{
    class TypeOfFile : ValidationAttribute
    {
        public string[] strValidExtensions = null;
        public override bool IsValid(object value)
        {
            HttpPostedFileWrapper objFile = value as HttpPostedFileWrapper;

            if (objFile != null)
            {
                string strExtension = System.IO.Path.GetExtension(objFile.FileName);
                if (strValidExtensions != null & strValidExtensions.Length > 0)
                {
                    foreach (string strExt in strValidExtensions)
                    {
                        if (strExt.ToLower().Equals(strExtension.ToLower()))
                            return true;
                    } 
                }
                return false;
            }
            return false;
        }
    }
}
