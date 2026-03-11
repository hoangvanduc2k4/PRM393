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

        [Required]
        [MaxLength(50)]
        public string Term { get; set; } = string.Empty;

        [Required]
        [MaxLength(20)]
        public string Year { get; set; } = string.Empty;

        [Column(TypeName = "decimal(5, 2)")]
        public decimal? Quiz15Min { get; set; }

        [Column(TypeName = "decimal(5, 2)")]
        public decimal? OralTest { get; set; }

        [Column(TypeName = "decimal(5, 2)")]
        public decimal? Test45Min { get; set; }

        [Column(TypeName = "decimal(5, 2)")]
        public decimal? FinalExam { get; set; }
    }
}
