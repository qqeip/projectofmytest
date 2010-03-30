using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DAL;
using Model;

namespace BLL
{
    public class UserLogOn
    {
        private UserManager UM = new UserManager();
        public int UserLogIn(string aUserNo,string aUserPWD)
        {
            User user = UM.GetUserInfo(aUserNo);
            if (user==null) 
                return -1;
            if (user.Userpwd == aUserPWD)
            {
                return 1;
            }
            else return 0;
        }
    }
}
