using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace KCM.ServiciosInternet.Diapro.Presentacion
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                name: "Incontinencia",
                url: "Incontinencia/{id}",
                defaults: new { controller = "Incontinencia", action = "Index", id = UrlParameter.Optional }
            );

            routes.MapRoute(
                name: "Cuidador",
                url: "Cuidadores/{id}",
                defaults: new { controller = "Cuidadores", action = "Index", id = UrlParameter.Optional }
            );


            routes.MapRoute(
                name: "Producto",
                url: "Productos/{id}",
                defaults: new { controller = "Productos", action = "Index", id = UrlParameter.Optional }
            );

            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "Home", action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}
