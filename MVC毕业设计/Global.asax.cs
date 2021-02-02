using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using DAL;
using System.Data;

namespace MVC毕业设计
{
    // 注意: 有关启用 IIS6 或 IIS7 经典模式的说明，
    // 请访问 http://go.microsoft.com/?LinkId=9394801

    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();

            WebApiConfig.Register(GlobalConfiguration.Configuration);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }
        //当过了session的时间就会运行这个
        protected void Session_End(object sender, EventArgs e) 
        {
            try
            {
                string sql = string.Format(@"update [dbo].[Online] set state='离线' where who='{0}'", DAL.DBH.session_member);
                DAL.DBH.exe(sql);
            }
            catch
            {
            }
        }
    }
}