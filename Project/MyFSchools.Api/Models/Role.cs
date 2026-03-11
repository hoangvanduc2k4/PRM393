using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;

namespace MyFSchools.Api.Models
{
    public class Role
    {
        [Key]
        public string Id { get; set; } = string.Empty;

        [Required]
        [MaxLength(50)]
        public string Name { get; set; } = string.Empty;

        public virtual ICollection<UserRole> UserRoles { get; set; } = new List<UserRole>();
    }
}
