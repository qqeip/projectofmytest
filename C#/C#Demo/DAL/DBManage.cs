using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.OracleClient;
using System.Configuration;

namespace DAL
{
    class DBManage
    {
        //数据连接对象
        private static OracleConnection conn = null;
        public static OracleConnection Conn
        {
            get
            {
                string connStr = ConfigurationManager.ConnectionStrings["connStr"].ConnectionString;

                if (conn == null)
                {
                    conn = new OracleConnection(connStr);
                }
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }
                if (conn.State == ConnectionState.Broken)
                {
                    conn.Close();
                    conn.Open();
                }
                return conn;
            }
        }

        //查询，DataReader
        public static OracleDataReader GetReader(string sqlStr)
        {
            OracleCommand cmd = new OracleCommand(sqlStr, Conn);
            return cmd.ExecuteReader();
        }
        //采用传参查询
        public static OracleDataReader GetReader(string sqlStr, OracleParameter[] param)
        {
            OracleCommand cmd = new OracleCommand(sqlStr, Conn);
            cmd.Parameters.AddRange(param);
            return cmd.ExecuteReader();
        }
        //查询，DataTable
        public static DataTable GetTable(string sqlStr)
        {
            OracleDataAdapter da = new OracleDataAdapter(sqlStr, Conn);
            DataSet ds = new DataSet();
            da.Fill(ds);
            conn.Close();
            return ds.Tables[0];
        }
        //通过存储过程查询
        public static DataTable Exec(string procName, OracleParameter[] param)
        {
            OracleCommand cmd = new OracleCommand(procName, Conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddRange(param);
            OracleDataAdapter da = new OracleDataAdapter();
            da.SelectCommand = cmd;
            DataSet ds = new DataSet();
            da.Fill(ds);
            conn.Close();
            return ds.Tables[0];
        }
        //增删改
        public static bool Execute(string sqlStr)
        {
            OracleCommand cmd = new OracleCommand(sqlStr, Conn);
            int result = cmd.ExecuteNonQuery();
            conn.Close();
            return result > 0;
        }
        //采用传参方式增删改
        public static bool Execute(string sqlStr, OracleParameter[] param)
        {
            OracleCommand cmd = new OracleCommand(sqlStr, Conn);
            cmd.Parameters.AddRange(param);
            int result = cmd.ExecuteNonQuery();
            conn.Close();
            return result > 0;
        }
        //返回首行首列
        public static Object GetScalar(string sqlStr)
        {
            OracleCommand cmd = new OracleCommand(sqlStr, Conn);
            Object obj = cmd.ExecuteScalar();
            conn.Close();
            return obj;
        }
        //采用传参方式返回首行首列
        public static Object GetScalar(string sqlStr, OracleParameter[] param)
        {
            OracleCommand cmd = new OracleCommand(sqlStr, Conn);
            cmd.Parameters.AddRange(param);
            Object obj = cmd.ExecuteScalar();
            conn.Close();
            return obj;
        }
    }
}
