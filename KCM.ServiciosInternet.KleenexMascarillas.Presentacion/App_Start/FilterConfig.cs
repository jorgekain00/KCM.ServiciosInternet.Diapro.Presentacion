using System.Web;
using System.Web.Mvc;

namespace KCM.ServiciosInternet.KleenexMascarillas.Presentacion
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
        }
    }
}
