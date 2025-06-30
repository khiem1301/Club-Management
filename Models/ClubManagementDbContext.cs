using Microsoft.EntityFrameworkCore;

namespace ClubManagementApp.Models
{
    public class ClubManagementDbContext : DbContext
    {
        public DbSet<User> Users { get; set; }
        public DbSet<Club> Clubs { get; set; }
        public DbSet<Event> Events { get; set; }
        public DbSet<EventParticipant> EventParticipants { get; set; }
        public DbSet<Report> Reports { get; set; }

        public ClubManagementDbContext(DbContextOptions<ClubManagementDbContext> options) : base(options) { }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Configure User entity
            modelBuilder.Entity<User>(entity =>
            {
                entity.HasKey(e => e.UserID);
                entity.HasIndex(e => e.Email).IsUnique();
                entity.Property(e => e.Role).HasConversion<string>();

                entity.HasOne(e => e.Club)
                      .WithMany(c => c.Members)
                      .HasForeignKey(e => e.ClubID)
                      .OnDelete(DeleteBehavior.SetNull);
            });

            // Configure Club entity
            modelBuilder.Entity<Club>(entity =>
            {
                entity.HasKey(e => e.ClubID);
                entity.HasIndex(e => e.Name).IsUnique();
            });

            // Configure Event entity
            modelBuilder.Entity<Event>(entity =>
            {
                entity.HasKey(e => e.EventID);
                entity.Property(e => e.Status).HasConversion<string>();

                entity.HasOne(e => e.Club)
                      .WithMany(c => c.Events)
                      .HasForeignKey(e => e.ClubID)
                      .OnDelete(DeleteBehavior.Cascade);
            });

            // Configure EventParticipant entity
            modelBuilder.Entity<EventParticipant>(entity =>
            {
                entity.HasKey(e => e.ParticipantID);
                entity.Property(e => e.Status).HasConversion<string>();

                entity.HasOne(e => e.User)
                      .WithMany(u => u.EventParticipations)
                      .HasForeignKey(e => e.UserID)
                      .OnDelete(DeleteBehavior.Cascade);

                entity.HasOne(e => e.Event)
                      .WithMany(ev => ev.Participants)
                      .HasForeignKey(e => e.EventID)
                      .OnDelete(DeleteBehavior.Cascade);

                // Ensure a user can only register once per event
                entity.HasIndex(e => new { e.UserID, e.EventID }).IsUnique();
            });

            // Configure Report entity
            modelBuilder.Entity<Report>(entity =>
            {
                entity.HasKey(e => e.ReportID);
                entity.Property(e => e.Type).HasConversion<string>();

                entity.HasOne(e => e.Club)
                      .WithMany()
                      .HasForeignKey(e => e.ClubID)
                      .OnDelete(DeleteBehavior.SetNull);

                entity.HasOne(e => e.GeneratedByUser)
                      .WithMany(u => u.GeneratedReports)
                      .HasForeignKey(e => e.GeneratedByUserID)
                      .OnDelete(DeleteBehavior.Restrict);
            });
        }
    }
}