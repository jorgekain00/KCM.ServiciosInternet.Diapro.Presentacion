using System.Web;
using System.Web.Optimization;

namespace KCM.ServiciosInternet.KleenexMascarillas.Presentacion
{
    public class BundleConfig
    {
        // Para obtener más información sobre las uniones, visite https://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.IgnoreList.Clear();

            //bundles.Add(new ScriptBundle("~/bundles/GralScripts").Include(
            //            "~/Scripts/jquery-{version}.js"));

            //bundles.Add(new StyleBundle("~/Content/GralCss").Include(
            //          "~/Content/x3dom.css",
            //          "~/Content/estilos.css"));
        }
    }
}
