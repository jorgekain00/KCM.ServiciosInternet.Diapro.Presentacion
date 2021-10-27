using System;
using System.Web;
using System.Web.Optimization;

namespace KCM.ServiciosInternet.Diapro.Presentacion
{
    public class BundleConfig
    {
        // Para obtener más información sobre las uniones, visite https://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.IgnoreList.Clear();

            bundles.Add(new StyleBundle("~/Content/css").Include(
                      "~/Content/stylemain.css"));

            bundles.Add(new StyleBundle("~/Content/SliderCuidadores").Include(
                      "~/Content/styleIncontinencia.css"));

            bundles.Add(new StyleBundle("~/Content/SliderVideos").Include(
                      "~/Content/slidervideos.css"));

            bundles.Add(new ScriptBundle("~/bundles/scripts").Include(
                       "~/Scripts/xss.min.js",
                       "~/Scripts/JFM.ui.js",
                       "~/Scripts/Observer.js"));

        }
    }

}
