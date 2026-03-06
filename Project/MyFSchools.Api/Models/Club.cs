using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;

namespace MyFSchools.Api.Models
{
    public class Club
    {
        [Key]
        public string Id { get; set; } = string.Empty;

        [Required]
        [MaxLength(256)]
        public string Name { get; set; } = string.Empty;

        [MaxLength(100)]
        public string? Category { get; set; }

        public int MemberCount { get; set; } = 0;

        public virtual ICollection<ChildClub> ChildClubs { get; set; } = new List<ChildClub>();
    }
}
