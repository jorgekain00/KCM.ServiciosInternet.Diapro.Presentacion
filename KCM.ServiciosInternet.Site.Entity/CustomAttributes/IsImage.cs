using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace KCM.ServiciosInternet.Site.Entity.CustomAttributes
{
    class IsImage : ValidationAttribute
    {
        public override bool IsValid(object value)
        {

            HttpPostedFileWrapper objFile = value as HttpPostedFileWrapper;

            try
            {
                if (objFile == null)
                {
                    return false;
                }
                else
                { 
                    Bitmap newImage = new Bitmap(objFile.InputStream);
                }
            }
            catch (Exception ex)
            {
                return false;
            }
            return true;
        }
    }
}
