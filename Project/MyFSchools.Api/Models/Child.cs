using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace MyFSchools.Api.Models
{
    public class Child
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public string Id { get; set; } = string.Empty;

        [Required]
        public string UserId { get; set; } = string.Empty;

        [ForeignKey("UserId")]
        [JsonIgnore]
        public virtual User? User { get; set; }

        [Required]
        [MaxLength(256)]
        public string FullName { get; set; } = string.Empty;

        [MaxLength(50)]
        public string? ClassName { get; set; }

        public string? AvatarUrl { get; set; }

        [JsonIgnore]
        public virtual ICollection<ChildClub> ChildClubs { get; set; } = new List<ChildClub>();
        [JsonIgnore]
        public virtual ICollection<Form> Forms { get; set; } = new List<Form>();
        [JsonIgnore]
        public virtual ICollection<Grade> Grades { get; set; } = new List<Grade>();
    }
}
