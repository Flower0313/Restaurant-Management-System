using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Security.Cryptography;
using System.Collections;
using DAL;
using System.Data;

namespace MVC毕业设计.Controllers
{
    public class LoginController : Controller
    {
        //
        // GET: /Login/

        public ActionResult login()
        {
            Session["admin"] = null;
            string sql = string.Format(@"select Shop_name from [dbo].[User] a,Shop b where a.Shop_id=b.Shop_id");
            DataTable ds = DAL.DBH.GetAll(sql);
            ViewBag.shopname = ds;
            return View(ds);
        }

        public string denglu() 
        {
            try
            {
                string admin = Request["admin"].ToString();
                string pwd = md5(Request["password"].ToString());
                string menmian = Request["menmian"].ToString();
                if (admin == "SuperAdmin")
                {
                    string sql2 = string.Format(@"select * from [dbo].[User] where User_admin='SuperAdmin' and User_pwd='{0}'", pwd);
                    int count = DAL.DBH.GetAll(sql2).Rows.Count;
                    if (count > 0)
                    {
                        Session.Remove("Admin");//清除session对象
                        Session["Admin"] = admin;
                        DAL.DBH.session_member = admin;
                        return "OK";
                    }
                    else
                    {
                        return "NO";
                    }
                }
                else
                {
                    string sql = string.Format(@"select User_pwd from [dbo].[User] a,Shop b where a.Shop_id=b.Shop_id 
                                    and ((b.Shop_name='{0}' and a.User_pwd='{1}') 
                                    or (a.User_admin='{2}' and a.User_pwd='{3}')) and b.Shop_name='{4}'", admin, pwd, admin, pwd, menmian);
                    int num = DAL.DBH.GetAll(sql).Rows.Count;
                    if (num > 0)
                    {
                        Session.Remove("Admin");
                        Session["Admin"] = admin;
                        return "OK";
                    }
                    else
                    {
                        return "NO";
                    }
                }
            }
            catch 
            {
                return "NO";
            }
        }

        public String md5(String s)
        {
            MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider();
            byte[] bytes = System.Text.Encoding.UTF8.GetBytes(s);
            bytes = md5.ComputeHash(bytes);
            md5.Clear();
            string ret = "";
            for (int i = 0; i < bytes.Length; i++)
            {
                ret += Convert.ToString(bytes[i], 16).PadLeft(2, '0');
            }

            return ret.PadLeft(32, '0');
        }
    }
}
