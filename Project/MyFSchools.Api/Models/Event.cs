using System;
using System.ComponentModel.DataAnnotations;

namespace MyFSchools.Api.Models
{
    public class Event
    {
        [Key]
        public string Id { get; set; } = string.Empty;

        [Required]
        [MaxLength(256)]
        public string EventName { get; set; } = string.Empty;

        [Required]
        public DateTime EventDate { get; set; }

        [MaxLength(50)]
        public string? Time { get; set; }

        [MaxLength(256)]
        public string? Location { get; set; }

        [MaxLength(20)]
        public string? Color { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
