using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MyFSchools.Api.Models
{
    public class Form
    {
        [Key]
        public string Id { get; set; } = string.Empty;

        [Required]
        public string UserId { get; set; } = string.Empty;
        [ForeignKey("UserId")]
        public virtual User? User { get; set; }

        [Required]
        public string ChildId { get; set; } = string.Empty;
        [ForeignKey("ChildId")]
        public virtual Child? Child { get; set; }

        [Required]
        [MaxLength(256)]
        public string Title { get; set; } = string.Empty;

        [MaxLength(100)]
        public string? Type { get; set; }

        [MaxLength(50)]
        public string? Date { get; set; }

        public string? Reason { get; set; }

        [MaxLength(50)]
        public string? Status { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
