using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace MyFSchools.Api.Models
{
    public class User
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public string Id { get; set; } = string.Empty;

        [EmailAddress]
        [MaxLength(256)]
        public string? Email { get; set; }

        public string? Password { get; set; }

        [MaxLength(20)]
        public string? Phone { get; set; }

        public string? ActiveChildId { get; set; }

        [ForeignKey("ActiveChildId")]
        public virtual Child? ActiveChild { get; set; }

        public virtual ICollection<Child> Children { get; set; } = new List<Child>();
        [JsonIgnore]
        public virtual ICollection<Form> Forms { get; set; } = new List<Form>();
        [JsonIgnore]
        public virtual ICollection<Notification> Notifications { get; set; } = new List<Notification>();

        public virtual ICollection<UserRole> UserRoles { get; set; } = new List<UserRole>();
    }
}
