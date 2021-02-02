using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Collections;
using DAL;
using System.Data;

namespace MVC毕业设计.Controllers
{
    public class LayoutController : Controller
    {
        //
        // GET: /Layout/


        public JsonResult Show() 
        {
            string sql = @"select distinct Shop_city from Shop";
            DataTable ds = DAL.DBH.GetAll(sql);
            ArrayList arrayList = new ArrayList();
            if (ds != null)
            {

                foreach (DataRow dataRow in ds.Rows)
                {
                    Dictionary<string, object> dictionary = new Dictionary<string, object>(); //实例化一个参数集合
                    foreach (DataColumn t in ds.Columns)
                    {
                        dictionary.Add(t.ColumnName, dataRow[t.ColumnName].ToString());
                    }
                    arrayList.Add(dictionary); //ArrayList集合中添加键值
                }
            }
            return Json(arrayList, JsonRequestBehavior.AllowGet);
        }//在母版页中显示城市名字

        public string DDD() 
        {
            try
            {
                string sql = String.Format(@"exec CheckLogin '{0}'", Session["admin"].ToString());
                DAL.DBH.exe(sql);
                return "成功";
            }
            catch {
                return "失败";
            }
            


        }

    }
}
