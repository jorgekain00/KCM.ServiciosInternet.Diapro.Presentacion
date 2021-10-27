using System.Web;
using System.Web.Optimization;

namespace KCM.ServiciosInternet.ganaKleenbebe.FrontEnd
{
    public class BundleConfig
    {
        // For more information on bundling, visit https://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.IgnoreList.Clear();

            // 
            bundles.Add(new ScriptBundle("~/bundles/scripts").Include(
                        "~/js/JsLogica/Entity/Entities.js",
                        "~/js/JFM.ui.js",
                        "~/js/JsLogica/Bussiness/Control/Session.js"));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                        "~/css/gamestyle.css"));

            

            bundles.Add(new ScriptBundle("~/bundles/GameCtrl").Include(
                        "~/js/JsLogica/Bussiness/Games/Games.js",
                        "~/js/JsLogica/Bussiness/Games/JFM.Clock.js"));

            bundles.Add(new ScriptBundle("~/bundles/MyScore").Include(
                        "~/js/JsLogica/Bussiness/Games/MyScore/MyScore.js"));

            bundles.Add(new ScriptBundle("~/bundles/SearchThings").Include(
                        "~/js/JsLogica/Bussiness/Games/SearchThings/JFM.SearchThings.js"));

            bundles.Add(new ScriptBundle("~/bundles/SoupLetters").Include(
                        "~/js/JsLogica/Bussiness/Games/SoupLetters/JFM.AlphabetSoup.js"));


            //This defines the resoueces for the Admin module

            bundles.Add(new StyleBundle("~/Content/css/Admin").Include(
                        "~/css/admin.css"));
            bundles.Add(new ScriptBundle("~/bundles/Admin").Include(
                        "~/js/JFM.ui.js",
                        "~/js/Admin/Entity/Entities.js",
                        "~/js/Admin/Bussiness/Control/Session.js"));
            //Winners screen
            bundles.Add(new ScriptBundle("~/bundles/Winners").Include(
                        "~/js/Admin/Bussiness/Winners/Winners.js"));
            //PivotDay screen
            bundles.Add(new ScriptBundle("~/bundles/PivotDay").Include(
                        "~/js/Admin/Bussiness/PivotDay/PivotDay.js"));
        }
    }
}

