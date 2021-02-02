//------------------------------------------------------------------------------
// <auto-generated>
//    此代码是根据模板生成的。
//
//    手动更改此文件可能会导致应用程序中发生异常行为。
//    如果重新生成代码，则将覆盖对此文件的手动更改。
// </auto-generated>
//------------------------------------------------------------------------------

namespace MVC毕业设计.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class Shop
    {
        public Shop()
        {
            this.Auto = new HashSet<Auto>();
            this.Consume = new HashSet<Consume>();
            this.Food = new HashSet<Food>();
            this.Forget = new HashSet<Forget>();
            this.Member = new HashSet<Member>();
            this.Record = new HashSet<Record>();
            this.Record1 = new HashSet<Record>();
            this.Staff = new HashSet<Staff>();
            this.User = new HashSet<User>();
        }
    
        public int Shop_id { get; set; }
        public string Shop_name { get; set; }
        public System.DateTime Shop_begin { get; set; }
        public string Shop_address { get; set; }
        public string Shop_city { get; set; }
        public string Shop_province { get; set; }
        public Nullable<long> Shop_person { get; set; }
        public Nullable<decimal> Shop_money { get; set; }
        public string Shop_number { get; set; }
        public decimal Shop_pay { get; set; }
        public string Shop_state { get; set; }
        public Nullable<System.DateTime> Shop_end { get; set; }
        public string Shop_pic { get; set; }
        public string State { get; set; }
        public string Shop_txt { get; set; }
        public Nullable<int> Staff_id { get; set; }
    
        public virtual ICollection<Auto> Auto { get; set; }
        public virtual ICollection<Consume> Consume { get; set; }
        public virtual ICollection<Food> Food { get; set; }
        public virtual ICollection<Forget> Forget { get; set; }
        public virtual ICollection<Member> Member { get; set; }
        public virtual ICollection<Record> Record { get; set; }
        public virtual ICollection<Record> Record1 { get; set; }
        public virtual ICollection<Staff> Staff { get; set; }
        public virtual ICollection<User> User { get; set; }
    }
}
