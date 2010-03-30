using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Model
{
    public class User
    {
        int userid;
        string userno;
        string userpwd;

        public int Userid
        {
            get { return userid; }
            set { userid = value; }
        }

        public string Userno
        {
            get { return userno; }
            set { userno = value; }
        }

        public string Userpwd
        {
            get { return userpwd; }
            set { userpwd = value; }
        }
    }
}
