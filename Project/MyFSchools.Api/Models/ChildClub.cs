using System.ComponentModel.DataAnnotations;

namespace MyFSchools.Api.Models
{
    public class ChildClub
    {
        public string ChildId { get; set; } = string.Empty;
        public virtual Child? Child { get; set; }

        public string ClubId { get; set; } = string.Empty;
        public virtual Club? Club { get; set; }
    }
}
