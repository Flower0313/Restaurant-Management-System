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
    
    public partial class FoodType
    {
        public FoodType()
        {
            this.Food = new HashSet<Food>();
        }
    
        public int FoodType_id { get; set; }
        public string FoodType_name { get; set; }
    
        public virtual ICollection<Food> Food { get; set; }
    }
}
