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
    public class IndexController : Controller
    {
        //
        // GET: /Index/

        public ActionResult Index()
        {
            //防范墙
            if (Session["Admin"] == null)
            {
                return Redirect("/Login/login");
            }

            //周销售额
            try
            {
                string sql = @"select SUM(Cus_money) from Consume where 
                datediff(day,CONVERT(varchar(30),Cus_time,23),CONVERT(varchar(30),GETDATE(),23))<7";
                string money = DAL.DBH.GetAll(sql).Rows[0][0].ToString();
                ViewBag.weekmoney = money.Substring(0, 6);
            }
            catch {
                ViewBag.weekmoney = 0;
            }

            //周销量
            string sql2 = @"select count(*) from Consume where 
                datediff(day,CONVERT(varchar(30),Cus_time,23),CONVERT(varchar(30),GETDATE(),23))<7";
            ViewBag.weekcount= DAL.DBH.GetAll(sql2).Rows[0][0].ToString();

            //会员卡数量
            string sql3 = @"select count(*) from Member";
            ViewBag.Member = DAL.DBH.GetAll(sql3).Rows[0][0].ToString();

            //总用户量
            string sql4 = @"select count(*) from Consume";
            ViewBag.consum = DAL.DBH.GetAll(sql4).Rows[0][0].ToString();
            return View();
        }

        public JsonResult Every() 
        {
            string chengjiao = string.Format(@"select a.tdby,b.today,c.yesterday from(
                        select ROW_NUMBER() over(order by tdby) num,* from [dbo].[v_tdby]) a inner join
                        (select ROW_NUMBER() over(order by today) num,* from [dbo].[v_today]) b on a.num=b.num
                        inner join (
                        select num=ROW_NUMBER() over(order by yesterday),yesterday from [dbo].[v_yesterday]) c
                        on a.num=c.num");
            string zhuce = string.Format(@"select a.tdby,b.today,c.yesterday from(
                        select ROW_NUMBER() over(order by tdby) num,* from [dbo].[m_tdby]) a inner join
                        (select ROW_NUMBER() over(order by today) num,* from [dbo].[m_today]) b on a.num=b.num
                        inner join (
                        select num=ROW_NUMBER() over(order by yesterday),yesterday from [dbo].[m_yesterday]) c
                        on a.num=c.num");
            DataTable ds = DAL.DBH.GetAll(chengjiao);
            DataTable ds2 = DAL.DBH.GetAll(zhuce);
            //成交量
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
            //注册量
            ArrayList arrayList2 = new ArrayList();
            if (ds2 != null)
            {

                foreach (DataRow dataRow in ds2.Rows)
                {
                    Dictionary<string, object> dictionary = new Dictionary<string, object>(); //实例化一个参数集合
                    foreach (DataColumn t in ds2.Columns)
                    {
                        dictionary.Add(t.ColumnName, dataRow[t.ColumnName].ToString());
                    }
                    arrayList2.Add(dictionary);
                }
            }
            var obj = new
            {
                成交量 = arrayList,
                注册量 = arrayList2
            };
            return Json(obj, JsonRequestBehavior.AllowGet);
        }

        public ActionResult Employee()
        {
            ////防范墙
            if (Session["admin"] == null)
            {
                return Redirect("/Login/login");
            }
            return View();
        }

        public JsonResult show(string offset, string limit, string name) 
        {
            string shopname = Session["admin"].ToString();
            if (Session["admin"].ToString() == "SuperAdmin") {
                shopname = "";
            }
            string sql = string.Format(@"select * from(
                            select ROW_NUMBER() over(order by Card_id) num ,Card_id ,Card_name ,
                            Card_sex,age=YEAR(GETDATE())-YEAR(Card_bir),Cus_height,Cus_weight,BFR ,Card_balance
                            ,days=(select DATEDIFF(day,CONVERT(varchar(10),getdate(),120),CONVERT(varchar,Card_end))) ,Card_integral ,b.vip_name,a.shop_id
                             from Member a,
                            Vip b where a.vip_id=b.vip_id and shop_id in (
                            select Shop_id from [dbo].[User] where User_admin like '%{0}%')) c where c.num>={1} and c.num<={2} 
                            and (c.Card_name like '%{3}%' or c.Card_id like '%{4}%')",
                              shopname, (int.Parse(offset) - 1) * int.Parse(limit) + 1, int.Parse(offset) * int.Parse(limit), name, name);
            DataTable ds = DAL.DBH.GetAll(sql);
            string nums = string.Format(@"select count(*) from Member where (Card_id like '%{0}%' or Card_name like '%{1}%')
                                and shop_id in (
                                select Shop_id from [dbo].[User] where User_admin like '%{2}%')", name, name,shopname);
            DataTable ds2 = DBH.GetAll(nums);
            string num = ds2.Rows[0][0].ToString();
            
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
            var obj = new { 
            total=num,
            rows=arrayList
            };
            return Json(obj, JsonRequestBehavior.AllowGet);
        }//用分页进行加载

        public ActionResult detail()
        {
            //防范墙
            if (Session["admin"] == null)
            {
                return Redirect("/Login/login");
            }
            return View();
        }

        public JsonResult detailshow(string id)
        {
            string sql = string.Format(@"select Card_id,Card_name,Card_pic,Card_sex,Id_card,Card_number,bir=CONVERT(nvarchar(20),Card_bir,23),age=YEAR(GETDATE())-YEAR(Card_bir),Cus_height,Cus_weight,
                                          BFR,vip_name,Card_balance,Card_integral,begintime=CONVERT(nvarchar(20),Card_begin,23),endtime=CONVERT(nvarchar(20),Card_end,23),c.staff_name,Shop_name,Card_state
                                           from Member a inner join Shop b on a.shop_id=b.Shop_id left join Staff c on a.staff_id=c.staff_id
                                          inner join Vip d on a.vip_id=d.vip_id and Card_id={0}", id);
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
        }//会员详细数据

        public JsonResult Person()
        {
            string sql = "select staff_name from Staff where Department_id='A006'";
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
        }//加载营养师

        public string Update(string id) 
        {
            try
            {
                string name = Request["txtname"].ToString();
                string sex = Request["txtsex"].ToString();
                string idcard = Request["txtIdcard"].ToString();
                string number = Request["txtnumber"].ToString();
                string bir = Request["txtbir"].ToString();
                string height = Request["txtheight"].ToString();
                string weight = Request["weight"].ToString();
                string Bfr = Request["BFR"].ToString();
                string balance = Request["txtbalance"].ToString();
                string date = Request["date"].ToString();
                string people = Request["txtperson"].ToString();
                string point = Request["txtpoint"].ToString();
                string state = Request["state"].ToString();
                string type = Request["type"].ToString();
                string end = "";

                switch (type)
                {
                    case "月卡": end = DateTime.Parse(date).AddMonths(3).ToShortDateString(); break;
                    case "季卡": end = DateTime.Parse(date).AddMonths(6).ToShortDateString(); break;
                    case "年卡": end = DateTime.Parse(date).AddYears(1).ToShortDateString(); break;
                    case "金卡": end = DateTime.Parse(date).AddYears(2).ToShortDateString(); break;
                    case "钻石卡": end = DateTime.Parse(date).AddYears(3).ToShortDateString(); break;
                }

                string sql = string.Format(@"update Member set Card_name='{0}',Card_sex='{1}',Id_card='{2}',
                                            Card_number='{3}',Card_bir='{4}',
                                            Cus_height='{5}',Cus_weight='{6}',BFR='{7}',Card_balance='{8}',
                                            Card_begin='{9}',staff_id=(select staff_id from Staff where staff_name='{10}'),
                                                shop_id=(select shop_id from Shop where Shop_name='{11}'),
                                            Card_state='{12}',vip_id=(select vip_id from Vip where vip_name='{13}'),Card_end='{14}'
                                                where Card_id='{15}'", name, sex, idcard, number, bir, height, weight,
                                                     Bfr, balance, date, people, point, state, type, end, id
                                                                                                         );

                DAL.DBH.exe(sql);
                return "成功";
            }
            catch(Exception ex)
            {
                return ex.ToString(); ;
            }
        }//更新会员

        public string Delete(string id) 
        {
            try
            {
                string sql = "delete from Member where Card_id=" + id;
                DAL.DBH.exe(sql);
                return "成功";
            }
            catch {
                return "失败";
            }
            
        }//删除会员

        public string Add() 
        {
            try
            {
                //获取当前店铺ID
                string ddd = string.Format(@"select Shop_id from [dbo].[User] where User_admin='{0}'", Session["admin"].ToString());
                string shop_id = DAL.DBH.GetAll(ddd).Rows[0][0].ToString();
                string pics = Request["pics"].ToString();
                string name = Request["nametxt"].ToString();
                string sex = Request["sex"].ToString();
                string bir = Request["date"].ToString();
                string height = Request["height"].ToString();
                string weight = Request["weight"].ToString();
                string BFR = Request["BFR"].ToString();
                string now = DateTime.Today.ToString("yyyy-MM-dd");
                string idcard = Request["Idcardtxt"].ToString();//身份证号码
                string number = Request["numbertxt"].ToString();
                string end = "";
                decimal money = 0;
                int vip_id = 0;
                string card = Request["selected"].ToString();
                switch (card)
                {
                    case "月卡": end = DateTime.Parse(now).AddMonths(3).ToShortDateString(); money += 800; vip_id = 1; break;
                    case "季卡": end = DateTime.Parse(now).AddMonths(6).ToShortDateString(); money += 2000; vip_id = 2; break;
                    case "年卡": end = DateTime.Parse(now).AddYears(1).ToShortDateString(); money += 3600; vip_id = 3; break;
                    case "金卡": end = DateTime.Parse(now).AddYears(2).ToShortDateString(); money += 6800; vip_id = 4; break;
                    case "钻石卡": end = DateTime.Parse(now).AddYears(3).ToShortDateString(); money += 11000; vip_id = 5; break;
                }
                string sql = string.Format(@"insert into Member(Card_name,Card_bir,Cus_height,Cus_weight,BFR,Card_balance,Card_pic,vip_id,Card_begin,Card_end,Card_sex,Id_card,Card_number,Card_state,shop_id) 
            values('{0}','{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}','{13}','{14}')", name, bir, height, weight, BFR, money, pics, vip_id, now, end, sex, idcard, number, "正常", shop_id);
                DAL.DBH.exe(sql);
                return "成功";

            }
            catch 
            {
                return "失败";
            }
            
        }//添加会员

        public ActionResult Shop() //店铺页面
        {
            //防范墙
            if (Session["Admin"] == null)
            {
                return Redirect("/Login/login");
            }
            return View();
        }

        public JsonResult shopname(string name) 
        {
            name = Server.UrlDecode(name);//解码
            string sql = string.Format("select Shop_name from Shop where Shop_city='{0}'",name);
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

        public JsonResult Base() 
        {
            string name = Request["cityname"].ToString();
            string sql = string.Format(@"select * from Shop where Shop_name='{0}'", name);
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
        }//显示城市基本信息

        public JsonResult Base2() 
        {
            string name = Request["cityname"].ToString();
            string sql = string.Format(@"select staff_pic,staff_name,staff_sex,age=YEAR(GETDATE())-YEAR(staff_bir),staff_number,staff_idcard,staff_txt,staff_state from Staff where staff_id=
                                (select Staff_id from Shop where Shop_name='{0}')", name);
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

        public JsonResult Base4() 
        {
            string name = Request["cityname"].ToString();
            string sql = string.Format(@"select a.staff_id,a.staff_name,c.Department_name,a.staff_sex,a.staff_state,
                                age=YEAR(GETDATE())-YEAR(staff_bir) from Staff a,Shop b,Department c 
                                where a.shop_id=b.Shop_id and 
                                a.Department_id=c.Department_id and b.Shop_name='{0}'", name);
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
        }//员工信息

        public ActionResult Food() 
        {
            //防范墙
            if (Session["Admin"] == null)
            {
                return Redirect("/Login/login");
            }
            string sql = "select * from FoodType";
            DataTable ds = DAL.DBH.GetAll(sql);
            ViewBag.type = ds;
            return View(ds);
        }

        [HttpPost]
        public JsonResult FoodType() 
        {
            string sql = "select * from FoodType";
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

        [HttpPost]
        public JsonResult changeFood() 
        {
            string page = Request["page"].ToString();
            string foodtype_id = Request["foodtype_id"].ToString();
            string sql = string.Format(@"select * from (
                                        select ROW_NUMBER() over(order by Food_id) num,* from Food where FoodType_id in ({0})) a
                                        where a.num>={1} and a.num<={2}", foodtype_id, 6 * (int.Parse(page) - 1) + 1, int.Parse(page) * 6);
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

        public string Count()
        {
            string foodtype_id = Request["foodtype_id"].ToString();
            string sql = string.Format(@"select * from Food where FoodType_id in ({0})", foodtype_id);
            DataTable ds = DAL.DBH.GetAll(sql);
            int count = ds.Rows.Count;
            return count.ToString();
        }

        public JsonResult Fooddetail() 
        {
            string name = Request["fooddetail"].ToString();
            string sql = string.Format(@"select Food_id,Food_name,Food_sale,Food_ka,Food_area,Food_txt,FoodType_name,Food_pic
            from Food a,FoodType b where a.FoodType_id=b.FoodType_id and Food_name='{0}'", name);
            DataTable ds = DAL.DBH.GetAll(sql);
            ArrayList arrayList = new ArrayList();
            if (ds != null)
            {

                foreach (DataRow item in ds.Rows)
                {
                    Dictionary<string, object> dictionary = new Dictionary<string, object>(); //实例化一个参数集合
                    foreach (DataColumn t in ds.Columns)
                    {
                        dictionary.Add(t.ColumnName, item[t.ColumnName].ToString());
                    }
                    arrayList.Add(dictionary); //ArrayList集合中添加键值
                }
            }
            return Json(arrayList, JsonRequestBehavior.AllowGet);
        }

        public string UpdateFood(string id) 
        {
            try
            {
                string name = Request["txt_name"].ToString();
                string price = Math.Round(decimal.Parse(Request["txtprice"].ToString()), 2).ToString();
                string kj = Request["txtKJ"].ToString();
                string type = Request["type"].ToString();
                string area = Request["txtarea"].ToString();
                string txt = Request["txt"].ToString();
                string sql = string.Format(@"update Food set Food_name='{0}',Food_sale='{1}',Food_ka='{2}',
                           Food_area='{3}',FoodType_id=(select FoodType_id from FoodType where FoodType_name='{4}'),Food_txt='{5}'
                            where Food_id='{6}'",name,price,kj,area,type,txt,id);
                DAL.DBH.exe(sql);
                return "成功";
            }
            catch 
            {
                return "失败";
            }
            
            
        }

        public string DeleteFood(string id) 
        {
            try
            {
                string sql = string.Format(@"delete from Food where Food_id='{0}'", id);
                DAL.DBH.exe(sql);
                return "成功";
            }
            catch 
            {
                return "失败";
            }
            
        }

        public ActionResult Record() 
        {
            //防范墙
            if (Session["Admin"] == null)
            {
                return Redirect("/Login/login");
            }
            return View();
        }

        [HttpPost]
        public JsonResult Recordshow(string name,string type,string offset,string limit) 
        {
            string shop_name = "";
            if (Session["admin"].ToString() != "SuperAdmin")
            {
                string sql2 = string.Format(@"select Shop_name from Shop where Shop_id=(
                                select Shop_id from [dbo].[User] where User_admin='{0}')", Session["admin"].ToString());
                shop_name = DAL.DBH.GetAll(sql2).Rows[0][0].ToString();
            }

            string sql = string.Format(@"select * from (
                    select ROW_NUMBER() over(order by Cus_id) num,* from (
                    select Cus_id,Cus_detail,Cus_money,Ifvip,Cus_want,
                    Cus_time=CONVERT(varchar(30),Cus_time,20),Cus_way,shop=(select Shop_name from Shop where shop_id=a.shop_id)
                    ,card_id=case when Card_id IS NULL then ' ' else convert(bigint,Card_id) end from Consume a where 
                    (Card_id like '%{0}%' or Cus_id like '%{1}%') and Ifvip in ({2})) c where c.shop like '%{3}%') d where
                     (d.num>={4} and d.num<={5})", name, name, type, shop_name, (int.Parse(offset) - 1) * int.Parse(limit) + 1, int.Parse(offset) * int.Parse(limit));
            DataTable ds = DAL.DBH.GetAll(sql);
            string nums = string.Format(@" select count(*) from (
                         select Cus_id,Cus_detail,Cus_money,Ifvip,Cus_want,
                         Cus_time=CONVERT(varchar(30),Cus_time,20),Cus_way,shop=(select Shop_name from Shop where shop_id=a.shop_id)
                         ,card_id=case when Card_id IS NULL then ' ' else convert(bigint,Card_id) end from Consume a where 
                         (Card_id like '%{0}%' or Cus_id like '%{1}%') and Ifvip in ({2})) c where c.shop like '%{3}%'", name, name,type,shop_name);
            DataTable ds2 = DBH.GetAll(nums);
            string num = ds2.Rows[0][0].ToString();

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

        public ActionResult ShopAdd(string name)
        {
            if (name == "'SuperAdmin'")
            {
                name = "User_admin";
            }
            //传过来的name可以被接收
            string num = DAL.DBH.GetAll("select distinct Shop_city from Shop").Rows.Count.ToString();
            ViewBag.citynum = num;

            string now = string.Format(@"select count(*) from Shop where Shop_province in(
                                    select Shop_province from Shop where Shop_id in (
                                    select Shop_id from [dbo].[User] where User_admin in ({0})))", name);
            DataTable ds = DAL.DBH.GetAll(now);
            string nowcount = ds.Rows[0][0].ToString();
            ViewBag.ben = nowcount;

            string earth = DAL.DBH.GetAll("select count(*) from Shop").Rows[0][0].ToString();
            ViewBag.earth = earth;

            string shoper = @"select staff_id,staff_name from staff where Department_id='A007'";
            DataTable ds2 = DAL.DBH.GetAll(shoper);

            return View(ds2);
        }//店铺增加功能

        public string ShopAddSure() 
        {
            try
            {
                string mima = md5(Request["mima"].ToString());
                string txtname = Request["txtname"].ToString();
                string pro = Request["pro"].ToString();
                string city = Request["city"].ToString();
                string txtaddress = Request["txtaddress"].ToString();
                string date = Request["date"].ToString();
                string number = Request["number"].ToString();
                string money = Request["money"].ToString();
                string shoptxt = Request["shoptxt"].ToString();
                string staff = Request["staff"].ToString();
                string pics=Request["pics"].ToString();
                if (pics == "") {
                    pics = "null.jpg";
                }
                if (pro == "北京" || pro == "上海") {
                    city = pro;
                }
                string sql = string.Format(@"select * from [dbo].[User] where User_pwd='{0}'", mima);
                DataTable ds = DAL.DBH.GetAll(sql);
                int count = ds.Rows.Count;
                if (count > 0)
                {
                    string sql2 = string.Format(@"insert into Shop(Shop_name,Shop_begin,Shop_address,Shop_city,Shop_province,Shop_number,Shop_pay,Shop_state,Shop_pic,
                    Shop_txt,State,staff_id) values('{0}','{1}','{2}','{3}','{4}','{5}','{6}','已缴费',
                    '{7}','{8}','运营中','{9}')", txtname, date, txtaddress, city, pro, number, money, pics, shoptxt, staff);
                    DAL.DBH.exe(sql2);

                    //获取刚刚添加的Id
                    string sql3 = string.Format(@"select Shop_id from Shop where Shop_name='{0}'",txtname);
                    string id = DAL.DBH.GetAll(sql3).Rows[0][0].ToString();

                    //加入到店主店铺表
                    string sql4 = string.Format(@"UPDATE Shop_Staff SET shop_id = '{0}' WHERE staff_id='{1}'",id,staff);
                    DAL.DBH.exe(sql4);

                    return "OK";
                }
                else
                {
                    return "NO";
                }
            }
            catch 
            {
                return "NO";
            }
            
        }

        //MD5加密
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
       
        //店铺密码设置
        public ActionResult ShopAuto()
        {
            ////防范墙
            //if (Session["Admin"] == null)
            //{
            //    return Redirect("/Login/login");
            //}
            return View();
        }

        //获取各个店铺的记录
        public JsonResult Admin(string offset, string limit) 
        {
            string sql = string.Format(@"select * from (
                            select ROW_NUMBER() over(order by Shop_name) num ,Shop_name,User_admin,User_id 
                            from Shop a left join [dbo].[User] b on a.Shop_id=b.Shop_id) c
                            where c.num>={0} and c.num<={1}", (int.Parse(offset) - 1) * int.Parse(limit) + 1, int.Parse(offset) * int.Parse(limit));
            DataTable ds = DAL.DBH.GetAll(sql);
            string num = DBH.GetAll(" select count(*) from Shop a left join [dbo].[User] b on a.Shop_id=b.Shop_id").Rows[0][0].ToString();

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
        
        //增加登录设置
        public string AddAdmin(string mima,string user,string pwd,string shopname) 
        {
            try
            {
                string panduan = string.Format(@"select * from [dbo].[User] where User_pwd='{0}'", md5(mima));
                int ds = DBH.GetAll(panduan).Rows.Count;
                if (ds > 0)
                {
                    string add = string.Format(@"insert into [dbo].[User] values('{0}','{1}',
                                (select Shop_id from Shop where Shop_name='{2}'))", user, md5(pwd), shopname);
                    DAL.DBH.exe(add);
                    string ADD2=string.Format(@"insert into Online values('{0}','{1}',NULL)",user,"离线");
                    DAL.DBH.exe(ADD2);
                    return "成功";
                }
                else
                {
                    return "失败";
                }
            }
            catch
            {
                return "失败";
            }
        }

        //修改登录设置
        public string UpdateAdmin(string mima, string shopname, string User, string oldpwd, string pwd) 
        {
            try
            {
                string panduan = string.Format(@"select * from [dbo].[User] where User_pwd='{0}'", md5(mima));
                int ds = DBH.GetAll(panduan).Rows.Count;
                if (ds > 0)
                {
                    //进入二次判断
                    string panduan2 = string.Format(@"select * from [dbo].[User] where User_pwd='{0}' 
                        and Shop_id=(select Shop_id from Shop where Shop_name='{1}')",md5(oldpwd),shopname);
                    if (DBH.GetAll(panduan2).Rows.Count > 0)
                    {
                        //进入执行
                        string doit = string.Format(@"update [dbo].[User] set User_pwd='{0}' where 
                            Shop_id=(select Shop_id from Shop where Shop_name='{1}')", md5(pwd), shopname);
                        DAL.DBH.exe(doit);

                        //加入修改记录表
                        string sql2 = string.Format(@"insert into Auto (Shop_id) values((select Shop_id from Shop where Shop_name='{0}'))", shopname);
                        DAL.DBH.exe(sql2);

                        return "成功";
                    }
                    else {
                        return "失败";
                    }
                }
                else
                {
                    return "失败";
                }
            }
            catch
            {
                return "失败";
            }
        }

        //查询修改记录
        public JsonResult AutoRecord(string shopname) 
        {
            string sql = string.Format(@"select * from [dbo].[Auto] where 
                    Shop_id=(select Shop_id from Shop where Shop_name='{0}')",shopname);

            DataTable ds = DBH.GetAll(sql);
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

        //挂失
        public ActionResult Lost()
        {
            string id = "";
            //防范墙
            if (Session["Admin"] == null)
            {
                return Redirect("/Login/login");
            }

            if (Session["admin"].ToString() != "SuperAdmin")
            {
                string dd = string.Format(@"select Shop_id from [dbo].[User] where User_admin='{0}'", Session["admin"].ToString());
                id = DAL.DBH.GetAll(dd).Rows[0][0].ToString();
            }

            string sql = string.Format(@"select Card_id,Card_name,vip_name=(select vip_name from Vip where vip_id=a.vip_id),Card_state,Card_pic from Member a where 
                        (Card_id like '%%' or Card_name like '%%') and Card_state like '%%' and shop_id like '%{0}%'",id);
            DataTable ds = DAL.DBH.GetAll(sql);
            return View(ds);
        }

        [HttpPost]
        public ActionResult Lost(string state,string name,string update,string mstate)
        {
            string id="";
            if (update != "")
            {
                if (mstate.Trim() == "冻结")
                {
                    mstate = "正常";
                }
                else {
                    mstate = "冻结";
                }
                string sql = string.Format(@"update Member set Card_state='{0}' where Card_id={1}",mstate,update);
                DAL.DBH.exe(sql);

            }
            else
            {
                
            }
            if (Session["admin"].ToString() != "SuperAdmin") {
                string dd = string.Format(@"select Shop_id from [dbo].[User] where User_admin='{0}'", Session["admin"].ToString());
                id = DAL.DBH.GetAll(dd).Rows[0][0].ToString();
            }

            string sql2 = string.Format(@"select Card_id,Card_name,vip_name=(select vip_name from Vip where vip_id=a.vip_id),
                                    Card_state,Card_pic from Member a where 
                        (Card_id like '%{0}%' or Card_name like '%{1}%') and Card_state like '%{2}%' and shop_id like '%{3}%'", name, name, state,id);
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
            return Json(arrayList, JsonRequestBehavior.AllowGet);

            
            
        }

        public ActionResult Staff() //员工表
        {
            //防范墙
            if (Session["Admin"] == null)
            {
                return Redirect("/Login/login");
            }

            string sql = "select User_admin,Shop_name from Shop a,[dbo].[User] b where a.Shop_id=b.Shop_id";
            DataTable ds = DAL.DBH.GetAll(sql);
            return View(ds);
        }

        public JsonResult Staffshow(string name,string offset,string limit,string shopname) //员工显示
        {

            //如果不是超级管理员，则显示当前店铺的员工数
            if (shopname == null)
            {
                shopname = "'" + Session["admin"].ToString() + "'";
            }
            
            string sql = string.Format(@"select * from(
                                            select ROW_NUMBER() over(order by staff_id) num,*,shop_name=(select Shop_name from Shop 
                                            where shop_id=a.shop_id),
                                            department_name=(select Department_name from Department where Department_id=a.Department_id) 
                                            from Staff a 
                                            where (staff_name like '%{0}%' or staff_id like '%{1}%') and 
                                            shop_id in (select Shop_id from [dbo].[User] where User_admin in ({2}))) a where a.num>={3} and a.num<={4}"
                                         , name, name, shopname,
                                        (int.Parse(offset) - 1) * int.Parse(limit) + 1, int.Parse(offset) * int.Parse(limit));
            DataTable ds = DAL.DBH.GetAll(sql);
            string sql2 = string.Format(@"select count(*) from(
                                select ROW_NUMBER() over(order by staff_id) num,*,shop_name=(select Shop_name from Shop 
                                where shop_id=a.shop_id),
                                department_name=(select Department_name from Department where Department_id=a.Department_id) 
                                from Staff a 
                                where (staff_name like '%%' or staff_id like '%%') and 
                                shop_id in (select Shop_id from [dbo].[User] where User_admin in ({0}))) a", shopname);
            DataTable ds2 = DAL.DBH.GetAll(sql2);
            string num = ds2.Rows[0][0].ToString();

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

        public ActionResult ShoperAdd() 
        {
            string sql = @"select count(*) from staff where Department_id='A007'";
            ViewBag.shopercount = DAL.DBH.GetAll(sql).Rows[0][0].ToString();
            return View();
        }

        public string ShoperAddsrue(string pro) 
        {
            try
            {
                DateTime now = DateTime.Now;
                string txtname = Request["txtname"].ToString();
                string sex = Request["sex"].ToString();
                string city = Request["city"].ToString();
                string address = Request["address"].ToString();
                string number = Request["number"].ToString();
                string date = Request["date"].ToString();
                string salary = Request["salary"].ToString();
                string idcard = Request["idcard"].ToString();
                string area = Request["txtarea"].ToString();
                string pics = Request["pics"].ToString();
                string nowtime = now.ToString("yyyy-MM-dd");

                string sql = string.Format(@"insert into Staff values('{0}','{1}','{2}','{3}','{4}','{5}','{6}',
                                    'A007',NULL,0,'{7}','{8}','在职','{9}','{10}')", txtname, date, sex, city, address, idcard, number, salary, nowtime,
                                                                                                       area, pics);
                DAL.DBH.exe(sql);
                //获取添加的店主ID
                string sql2 = string.Format("select staff_id from Staff where staff_name='{0}'",txtname);
                string id = DAL.DBH.GetAll(sql2).Rows[0][0].ToString();

                //将数据插入店主店铺表
                string sql3 = string.Format(@"insert into Shop_Staff values('{0}',NULL)",id);
                DAL.DBH.exe(sql3);
                return "成功";
            }
            catch
            {
                return "失败";
            }
        }

        public ActionResult StaffAdd() 
        {
            string sql = "select Shop_name,Shop_id from Shop";
            DataTable ds= DAL.DBH.GetAll(sql);
            return View(ds);
        }

        //员工添加
        public string StaffAddsure() 
        {
            try
            {
                string pics = Request["pics"].ToString();
                string name = Request["txtname"].ToString();
                string city = Request["txtcity"].ToString();
                string sex = Request["sex"].ToString();
                string bir = Request["txtdate"].ToString();
                string number = Request["txtnumber"].ToString();
                string address = Request["txtaddress"].ToString();
                string salary = Request["txtsalary"].ToString();
                string txt = Request["txtarea"].ToString();
                string idcard = Request["txtIdcard"].ToString();
                string shop = Request["shop"].ToString();
                string depart = Request["depart"].ToString();
                string begin = DateTime.Today.ToString("yyyy-MM-dd");

                string sql = string.Format(@"insert into Staff values
            ('{0}','{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','0','{9}','{10}','在职','{11}','{12}')", name, bir, sex,
                                                                   city, address, idcard, number, depart, shop, salary, begin, txt, pics);
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
