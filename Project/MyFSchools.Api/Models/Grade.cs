using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MyFSchools.Api.Models
{
    public class Grade
    {
        [Key]
        public string Id { get; set; } = string.Empty;

        [Required]
        public string ChildId { get; set; } = string.Empty;
        [ForeignKey("ChildId")]
        public virtual Child? Child { get; set; }

        [Required]
        [MaxLength(256)]
        public string Subject { get; set; } = string.Empty;

        [MaxLength(100)]
        public string? Term { get; set; }

        [Column(TypeName = "decimal(5, 2)")]
        public decimal Average { get; set; }

        [MaxLength(50)]
        public string? Status { get; set; }
    }
}
