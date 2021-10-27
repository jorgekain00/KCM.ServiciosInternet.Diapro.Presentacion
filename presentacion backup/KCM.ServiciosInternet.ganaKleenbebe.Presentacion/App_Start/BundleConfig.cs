using System.Web;
using System.Web.Optimization;

namespace KCM.ServiciosInternet.ganaKleenbebe.Presentacion
{
    public class BundleConfig
    {
        // Para obtener más información sobre las uniones, visite https://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.IgnoreList.Clear();

            //bundles.Add(new ScriptBundle("~/bundles/scripts").Include(
            //            "~/js/jquery-{version}.js"));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                        //"~/css/bootstrap.min.css",
                        //"~/css/all.css",
                        "~/css/gamestyle.css"));
        }
    }
}
