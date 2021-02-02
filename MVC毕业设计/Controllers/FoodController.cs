using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Newtonsoft.Json;
using DAL;
using System.Data;
using System.Collections;
using System.Security.Cryptography;

namespace MVC毕业设计.Controllers
{
    public class FoodController : Controller
    {
        //
        // GET: /Food/

        public ActionResult food()
        {
            //防范墙
            if (Session["Admin"] == null)
            {
                return Redirect("/Login/login");
            }

            string sql = "select * from FoodType";
            DataTable ds = DAL.DBH.GetAll(sql);
            return View(ds);
        }

        public string FoodAdd(string pics,string leibie,string txt) 
        {
            try
            {
                string name = Request["txtname"].ToString();
                string price = Request["txtprice"].ToString();
                string ka = Request["txtka"].ToString();
                string add = Request["txtadd"].ToString();
                string sql = string.Format(@"insert into Food values('{0}','{1}','{2}','{3}','{4}',NULL,'{5}','{6}')", name, price, ka, add, txt, leibie, pics);
                DAL.DBH.exe(sql);
                return "成功";

            }
            catch {
                return "失败";
            }
        }

        //查询员工详情
        public JsonResult staffdetail(string id) 
        {
            string sql = string.Format(@"select * from staffdetail where staff_id='{0}'", id);
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
        }

    }
}
