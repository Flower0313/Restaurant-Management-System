using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;


namespace DAL
{
    public class DBH
    {
        public static string DBConnectString = ConfigurationManager.ConnectionStrings["FlowerNutrition"].ConnectionString;
        public static SqlConnection conn = null;

        public static void Conn() 
        {
            if (conn == null) 
            {
                conn = new SqlConnection(DBConnectString);
            }
            if (conn.State == ConnectionState.Broken) 
            {
                conn.Open();
            }
        }

        public static bool exe(string str) 
        {
            using (SqlConnection conn=new SqlConnection (DBConnectString)) 
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(str,conn);
                return cmd.ExecuteNonQuery() > 0;
            }
        }
        
        public static DataTable GetAll(string str) 
        {
            using (SqlConnection conn = new SqlConnection(DBConnectString)) 
            {
                conn.Open();
                DataTable ds = new DataTable();
                SqlDataAdapter dp = new SqlDataAdapter(str, conn);
                dp.Fill(ds);
                return ds;
            }
        }
    }
}
