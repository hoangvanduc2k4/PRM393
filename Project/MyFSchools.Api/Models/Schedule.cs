using System.ComponentModel.DataAnnotations;

namespace MyFSchools.Api.Models
{
    public class Schedule
    {
        [Key]
        public string Id { get; set; } = string.Empty;

        [Required]
        [MaxLength(50)]
        public string ClassName { get; set; } = string.Empty;

        [Required]
        [MaxLength(20)]
        public string DayOfWeek { get; set; } = string.Empty;

        [Required]
        public int Slot { get; set; }

        [Required]
        [MaxLength(256)]
        public string Subject { get; set; } = string.Empty;

        [MaxLength(256)]
        public string? Teacher { get; set; }

        [MaxLength(50)]
        public string? Room { get; set; }

        [MaxLength(100)]
        public string? Term { get; set; }
    }
}
