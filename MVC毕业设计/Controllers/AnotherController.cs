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
using System.Web.Security;

namespace MVC毕业设计.Controllers
{
    public class AnotherController : Controller
    {
        //
        // GET: /Another/


        public ActionResult AddConsume()
        {

            string sql = string.Format(@"select Food_id,Food_name,Food_sale,Food_pic from Food");
            DataTable ds = DAL.DBH.GetAll(sql);
            return View(ds);
        }

        public JsonResult taocan() 
        {
            string sql = @"select a.meal_id,meal_name,Food_name,meal_price 
                            from Meal a inner join v_taocan b on a.meal_id=b.meal_id";
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

        public JsonResult select() 
        {
            string sql = "select Card_id,Card_name from Member";
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

        //增加消费记录
        public string add() 
        {
            try
            {
                string id = Membership.GeneratePassword(20, 1);
                string sql2 = string.Format(@"select Shop_id from [dbo].[User] where User_admin='{0}'", Session["admin"].ToString());
                string shop_id = DAL.DBH.GetAll(sql2).Rows[0][0].ToString();
                string want = Request["want"].ToString();
                string food = Request["food"].ToString();
                string card = Request["card"].ToString();
                string price = Request["price"].ToString();
                string vip = Request["vip"].ToString();
                string way="";

                //如果是会员
                if (card != "NULL") 
                {
                    card = "'" + card + "'";
                }

                if (vip == "是")
                {
                    vip = "1";
                    way="会员卡";
                    string sql3 = string.Format(@"select Card_balance from Member where Card_id={0}", card);
                    float balance = Convert.ToSingle(DAL.DBH.GetAll(sql3).Rows[0][0].ToString());
                    if (Convert.ToSingle(price) > balance)
                    {
                        return "余额不足";
                    }
                    else
                    {
                        string sql4 = string.Format(@"update Member set Card_balance='{0}' where Card_id={1}", balance - int.Parse(price), card);
                        DAL.DBH.exe(sql4);
                    }
                }
                else {
                    vip = "0";
                    way="现金";
                }
                string sql = string.Format(@"insert into Consume(Cus_id,Cus_detail,Cus_money,Ifvip,Cus_want,Cus_way,Card_id,shop_id) 
                                                    values('{0}','{1}','{2}','{3}','{4}','{5}',{6},'{7}')",
                                                           id,food,price,vip,want,way,card,shop_id);
                DAL.DBH.exe(sql);
                return "成功";
            }
            catch {
                return "失败";
            }
        }

    }
}
