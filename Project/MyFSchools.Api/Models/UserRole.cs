using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MyFSchools.Api.Models
{
    public class UserRole
    {
        [Required]
        public string UserId { get; set; } = string.Empty;

        [ForeignKey("UserId")]
        public virtual User? User { get; set; }

        [Required]
        public string RoleId { get; set; } = string.Empty;

        [ForeignKey("RoleId")]
        public virtual Role? Role { get; set; }
    }
}
