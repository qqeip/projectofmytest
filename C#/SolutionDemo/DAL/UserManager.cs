using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using Model;

namespace DAL
{
    public class UserManager
    {
        public User GetUserInfo(string aUserNO)
        {
            DataTable User_Tab = DBManage.GetTable("select * from user_info where userno='" + aUserNO + "'");
            if (User_Tab.Rows.Count == 0)
                return null;
            User user = new User();
            user.Userid = Convert.ToInt32(User_Tab.Rows[0]["userid"]);
            user.Userno = User_Tab.Rows[0]["userno"].ToString();
            user.Userpwd = User_Tab.Rows[0]["userpwd"].ToString();
            return user;
        }
    }
}
