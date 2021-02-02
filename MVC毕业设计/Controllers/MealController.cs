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
    public class MealController : Controller
    {
        //
        // GET: /Meal/

        public ActionResult Meal()
        {
            //防范墙
            if (Session["admin"] == null)
            {
                return Redirect("/Login/login");
            }
            string sql = "select FoodType_name from FoodType";
            DataTable ds = DAL.DBH.GetAll(sql);
            return View(ds);
        }

        public JsonResult Showmeal(string offset,string limit) 
        {
            string sql = string.Format(@"select * from (
                            select ROW_NUMBER() over(order by Food_id) num,Food_pic,Food_id,Food_name from Food) a
                            where a.num>={0} and a.num<={1}", (int.Parse(offset) - 1) * int.Parse(limit) + 1, int.Parse(offset) * int.Parse(limit));
            DataTable ds = DAL.DBH.GetAll(sql);
            string num = DAL.DBH.GetAll("select count(*) from Food").Rows[0][0].ToString();

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
            var obj = new
            {
                total = num,
                rows = arrayList
            };
            return Json(obj, JsonRequestBehavior.AllowGet);
        }

        //增加类别
        public string addname()
        {
            try
            {
                string name = Request["foodname"].ToString();
                string sql = string.Format("insert into FoodType values('{0}')", name);
                DAL.DBH.exe(sql);
                return "成功";
            }
            catch {
                return "失败";
            }
            
        }

        //删除类别
        public string removename(string foodname2)
        {
            try
            {
                //string name2 = Request["foodname2"].ToString();
                string sql = string.Format("DELETE FROM FoodType WHERE FoodType_name = '{0}'", foodname2);
                DAL.DBH.exe(sql);
                return "成功";
            }
            catch
            {
                return "失败";
            }

        }

        //重新显示类别
        public JsonResult showfoodtype() 
        {
            string sql = string.Format(@"select FoodType_name from FoodType");
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

        //添加套餐
        public string MealAdd(string mealname,string mealprice,string foods) 
        {
            try
            {
                //添加菜系
                string sql = string.Format(@"insert into Meal values('{0}','{1}')", mealname, mealprice);
                DAL.DBH.exe(sql);

                //取出刚刚存入的菜系编号
                string sql2 = string.Format(@"select meal_id from Meal where meal_name='{0}'", mealname);
                string bianhao = DAL.DBH.GetAll(sql2).Rows[0][0].ToString();

                //拼接菜单
                string sql3 = string.Format(@"insert into MealFood(food_id,meal_id)");
                String[] food = foods.Split(',');
                for (int i = 0; i < food.Length; i++)
                {
                    if (i == food.Length - 1)
                    {
                        sql3 += "select '" + food[i] + "','" + bianhao + "'";
                    }
                    else
                    {
                        sql3 += "select '" + food[i] + "','" + bianhao + "' union\n";
                    }
                }
                DAL.DBH.exe(sql3);
                return "成功";
            }
            catch {
                return "失败";
            }
            
        }

    }
}
