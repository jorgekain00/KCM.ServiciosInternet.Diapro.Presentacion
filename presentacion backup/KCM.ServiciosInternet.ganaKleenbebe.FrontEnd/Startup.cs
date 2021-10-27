using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(KCM.ServiciosInternet.ganaKleenbebe.FrontEnd.Startup))]
namespace KCM.ServiciosInternet.ganaKleenbebe.FrontEnd
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
