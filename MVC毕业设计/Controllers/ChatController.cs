using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DAL;
using System.Data;
using System.Collections;
using System.Security.Cryptography;

namespace MVC毕业设计.Controllers
{
    public class ChatController : Controller
    {
        //
        // GET: /Chat/

        public ActionResult Index()
        {
            return View();
        }
        public JsonResult GetChat() 
        {
            string change = Request["change"].ToString();
            string timest = Request["timest"].ToString();
            string sql2 = "";
            string sql3 = String.Format(@"update [dbo].[Online] set endtime='{0}' where who='{1}'", timest,Session["admin"].ToString());
            if (change == "" || change == "0")
            {
                string sql = @"select *,CONVERT(varchar(30),chat_time,120) as times from Chat where 
                                datediff(day,CONVERT(varchar(30),chat_time,23),CONVERT(varchar(30),GETDATE(),23))=0";
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
                DAL.DBH.exe(sql3);
                return Json(arrayList, JsonRequestBehavior.AllowGet);
            }
            else {
                switch (change)
                {
                    case "1":
                        sql2 = @"select *,CONVERT(varchar(30),chat_time,120) as times from Chat where 
                                datediff(day,CONVERT(varchar(30),chat_time,23),CONVERT(varchar(30),GETDATE(),23))=1";
                        break;
                    case "8":
                        sql2 = @"select *,CONVERT(varchar(30),chat_time,120) as times from Chat where 
                                datediff(day,CONVERT(varchar(30),chat_time,23),CONVERT(varchar(30),GETDATE(),23))<8";
                        break;
                    case "全部":
                        sql2 = @"select *,CONVERT(varchar(30),chat_time,120) as times from Chat";
                        break;
                }
                DataTable ds = DAL.DBH.GetAll(sql2);
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
                DAL.DBH.exe(sql3);
                return Json(arrayList, JsonRequestBehavior.AllowGet);
            }

                
            
        }

        //增加聊天记录
        public string AddChat() 
        {
            try
            {
                string text = Request["text"].ToString();
                string time = Request["time"].ToString();
                //string name = Session["admin"].ToString();
                string sql = string.Format(@"insert into Chat(chat_name,chat_time,chat_txt) values('{0}','{1}','{2}')"
                    , @Session["admin"].ToString(), time, text);
                DAL.DBH.exe(sql);
                return "成功";
            }
            catch {
                return "失败";
            }
           
        }

        //删除聊天记录
        public string DeleteAll() 
        {
            try
            {
                string sql = @"delete Chat";
                DAL.DBH.exe(sql);
                return "成功";
            }
            catch {
                return "失败";
            }
            
        }

        //更新在线时间
        public string Updatetime() 
        {
            try
            {
                string time = Request["timezzz"].ToString();
                string sql = string.Format(@"update [dbo].[Online] set endtime='{0}' where who='{1}'", time, Session["admin"].ToString());
                DAL.DBH.exe(sql);
                return "成功";
            }
            catch {
                return "失败";
            }
            
        }

        public JsonResult member() 
        {
            string sql = @"select who from Online where state='在线'";
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

        public string Endpage() 
        {
            try
            {
                string sql = string.Format(@"update [dbo].[Online] set state='离线' where who='{0}'", Session["admin"].ToString());
                DAL.DBH.exe(sql);
                return "成功";
            }
            catch
            {
                return "失败";
            }
        }
    }
}
