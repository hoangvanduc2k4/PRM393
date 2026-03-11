using Microsoft.EntityFrameworkCore;
using MyFSchools.Api.Models;
using System.Reflection.Emit;

namespace MyFSchools.Api.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
        }

        public DbSet<User> Users { get; set; } = null!;
        public DbSet<Child> Children { get; set; } = null!;
        public DbSet<Club> Clubs { get; set; } = null!;
        public DbSet<ChildClub> ChildClubs { get; set; } = null!;
        public DbSet<Event> Events { get; set; } = null!;
        public DbSet<Form> Forms { get; set; } = null!;
        public DbSet<Grade> Grades { get; set; } = null!;
        public DbSet<Notification> Notifications { get; set; } = null!;
        public DbSet<Schedule> Schedules { get; set; } = null!;
        public DbSet<Role> Roles { get; set; } = null!;
        public DbSet<UserRole> UserRoles { get; set; } = null!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // ── Relationships ──────────────────────────────────────────────

            modelBuilder.Entity<UserRole>()
                .HasKey(ur => new { ur.UserId, ur.RoleId });

            modelBuilder.Entity<UserRole>()
                .HasOne(ur => ur.User)
                .WithMany(u => u.UserRoles)
                .HasForeignKey(ur => ur.UserId);

            modelBuilder.Entity<UserRole>()
                .HasOne(ur => ur.Role)
                .WithMany(r => r.UserRoles)
                .HasForeignKey(ur => ur.RoleId);

            modelBuilder.Entity<ChildClub>()
                .HasKey(cc => new { cc.ChildId, cc.ClubId });

            modelBuilder.Entity<ChildClub>()
                .HasOne(cc => cc.Child)
                .WithMany(c => c.ChildClubs)
                .HasForeignKey(cc => cc.ChildId);

            modelBuilder.Entity<ChildClub>()
                .HasOne(cc => cc.Club)
                .WithMany(cl => cl.ChildClubs)
                .HasForeignKey(cc => cc.ClubId);

            modelBuilder.Entity<Child>()
                .HasOne(c => c.User)
                .WithMany(u => u.Children)
                .HasForeignKey(c => c.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<User>()
                .HasOne(u => u.ActiveChild)
                .WithOne()
                .HasForeignKey<User>(u => u.ActiveChildId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<Form>()
                .HasOne(f => f.User)
                .WithMany(u => u.Forms)
                .HasForeignKey(f => f.UserId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<Form>()
                .HasOne(f => f.Child)
                .WithMany(c => c.Forms)
                .HasForeignKey(f => f.ChildId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<Grade>()
                .HasOne(g => g.Child)
                .WithMany(c => c.Grades)
                .HasForeignKey(g => g.ChildId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Notification>()
                .HasOne(n => n.User)
                .WithMany(u => u.Notifications)
                .HasForeignKey(n => n.UserId)
                .OnDelete(DeleteBehavior.Cascade);
        }

    }
}
