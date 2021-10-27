using System.Web;
using System.Web.Mvc;

namespace KCM.ServiciosInternet.ganaKleenbebe.FrontEnd
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
        }
    }
}
