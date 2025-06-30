using System.ComponentModel.DataAnnotations;

namespace ClubManagementApp.Models
{
    public enum UserRole
    {
        SystemAdmin,
        Admin,
        ClubPresident,
        Chairman,
        ViceChairman,
        ClubOfficer,
        TeamLeader,
        Member
    }

    public class User
    {
        [Key]
        public int UserID { get; set; }

        [Required]
        [StringLength(100)]
        public string FullName { get; set; } = null!;

        [Required]
        [EmailAddress]
        [StringLength(150)]
        public string Email { get; set; } = null!;

        [Required]
        [StringLength(255)]
        public string Password { get; set; } = null!; // Should be hashed in real application

        [StringLength(20)]
        public string? StudentID { get; set; }

        [StringLength(20)]
        public string? PhoneNumber { get; set; }

        [Required]
        public UserRole Role { get; set; }

        public DateTime JoinDate { get; set; } = DateTime.Now;

        public bool IsActive { get; set; } = true;

        // Foreign key
        public int? ClubID { get; set; } // Nullable for admins or users without clubs

        // Navigation properties
        public virtual Club? Club { get; set; }
        public virtual ICollection<EventParticipant> EventParticipations { get; set; } = new List<EventParticipant>();
        public virtual ICollection<Report> GeneratedReports { get; set; } = new List<Report>();
    }
}