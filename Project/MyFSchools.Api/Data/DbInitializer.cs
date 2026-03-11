using Bogus;
using Microsoft.EntityFrameworkCore;
using MyFSchools.Api.Models;
using System.Linq;
using System.Collections.Generic;
using System;

namespace MyFSchools.Api.Data
{
    public static class DbInitializer
    {
        public static void Initialize(ApplicationDbContext context)
        {
            context.Database.EnsureCreated();

            if (context.Users.Any())
            {
                return; // DB has been seeded
            }

            // ── Fixed IDs ──────────────────────────────────────────────────
            var u1 = "u-001"; var u2 = "u-002"; var u3 = "u-003"; var u4 = "u-004";
            var c1 = "c-001"; var c2 = "c-002"; var c3 = "c-003";
            var c4 = "c-004"; var c5 = "c-005"; var c6 = "c-006";
            var cl1 = "cl-1"; var cl2 = "cl-2"; var cl3 = "cl-3"; var cl4 = "cl-4"; var cl5 = "cl-5";

            // Hash "Password123" using BCrypt dynamically
            var defaultPasswordHash = BCrypt.Net.BCrypt.HashPassword("Password123");

            // ── Users ──────────────────────────────────────────────────────
            var users = new[]
            {
                new User { Id = u1, Email = "nguyenvana@myfschools.com", Password = defaultPasswordHash, Phone = "0912345678" },
                new User { Id = u2, Email = "tranthib@myfschools.com",   Password = defaultPasswordHash, Phone = "0923456789" },
                new User { Id = u3, Email = "lehongc@myfschools.com",    Password = defaultPasswordHash, Phone = "0934567890" },
                new User { Id = u4, Email = "phamvand@myfschools.com",   Password = defaultPasswordHash, Phone = "0945678901" }
            };
            context.Users.AddRange(users);

            // ── Roles ──────────────────────────────────────────────────────
            var roleTeacher = "r-teacher";
            var roleParent = "r-parent";

            var roles = new[]
            {
                new Role { Id = roleTeacher, Name = "Teacher" },
                new Role { Id = roleParent, Name = "Parent" }
            };
            context.Roles.AddRange(roles);

            // ── UserRoles ──────────────────────────────────────────────────
            var userRoles = new[]
            {
                new UserRole { UserId = u1, RoleId = roleParent },
                new UserRole { UserId = u2, RoleId = roleParent },
                new UserRole { UserId = u2, RoleId = roleTeacher },
                new UserRole { UserId = u3, RoleId = roleParent },
                new UserRole { UserId = u4, RoleId = roleTeacher }
            };
            context.UserRoles.AddRange(userRoles);

            // ── Children ───────────────────────────────────────────────────
            var children = new[]
            {
                new Child { Id = c1, UserId = u1, FullName = "Nguyễn Minh An",   ClassName = "3A1", AvatarUrl = "https://i.pravatar.cc/150?u=c1" },
                new Child { Id = c2, UserId = u1, FullName = "Nguyễn Thu Hà",    ClassName = "5B2", AvatarUrl = "https://i.pravatar.cc/150?u=c2" },
                new Child { Id = c3, UserId = u2, FullName = "Trần Quốc Bảo",    ClassName = "4C3", AvatarUrl = "https://i.pravatar.cc/150?u=c3" },
                new Child { Id = c4, UserId = u2, FullName = "Trần Khánh Linh",  ClassName = "2A1", AvatarUrl = "https://i.pravatar.cc/150?u=c4" },
                new Child { Id = c5, UserId = u3, FullName = "Lê Hoàng Nam",     ClassName = "1B1", AvatarUrl = "https://i.pravatar.cc/150?u=c5" },
                new Child { Id = c6, UserId = u3, FullName = "Lê Thanh Phương",  ClassName = "3A1", AvatarUrl = "https://i.pravatar.cc/150?u=c6" }
            };
            context.Children.AddRange(children);

            // ── Clubs ──────────────────────────────────────────────────────
            var clubs = new[]
            {
                new Club { Id = cl1, Name = "Câu lạc bộ Toán học",   Category = "Học thuật",  MemberCount = 3 },
                new Club { Id = cl2, Name = "Câu lạc bộ Bóng đá",    Category = "Thể thao",   MemberCount = 3 },
                new Club { Id = cl3, Name = "Câu lạc bộ Mỹ thuật",   Category = "Nghệ thuật", MemberCount = 2 },
                new Club { Id = cl4, Name = "Câu lạc bộ Khoa học",   Category = "Khoa học",   MemberCount = 2 },
                new Club { Id = cl5, Name = "Câu lạc bộ Âm nhạc",    Category = "Nghệ thuật", MemberCount = 2 }
            };
            context.Clubs.AddRange(clubs);

            // ── ChildClubs ──────────────────────────────────────────────────
            var childClubs = new[]
            {
                new ChildClub { ChildId = c1, ClubId = cl1 },
                new ChildClub { ChildId = c1, ClubId = cl2 },
                new ChildClub { ChildId = c2, ClubId = cl3 },
                new ChildClub { ChildId = c3, ClubId = cl1 },
                new ChildClub { ChildId = c3, ClubId = cl4 },
                new ChildClub { ChildId = c4, ClubId = cl2 },
                new ChildClub { ChildId = c5, ClubId = cl5 },
                new ChildClub { ChildId = c5, ClubId = cl3 },
                new ChildClub { ChildId = c6, ClubId = cl4 },
                new ChildClub { ChildId = c6, ClubId = cl2 }
            };
            context.ChildClubs.AddRange(childClubs);

            // ── Events ─────────────────────────────────────────────────────
            var baseDate = new DateTime(2025, 1, 1, 0, 0, 0, DateTimeKind.Utc);
            var events = new[]
            {
                new Event { Id = "ev-1", EventName = "Ngày hội khoa học",        EventDate = baseDate.AddDays(10), Time = "08:00 - 11:00", Location = "Sân trường",         Color = "blue",   CreatedAt = baseDate },
                new Event { Id = "ev-2", EventName = "Hội trại cuối năm",        EventDate = baseDate.AddDays(20), Time = "07:00 - 17:00", Location = "Công viên Gia Định", Color = "green",  CreatedAt = baseDate },
                new Event { Id = "ev-3", EventName = "Văn nghệ chào xuân",       EventDate = baseDate.AddDays(30), Time = "14:00 - 16:30", Location = "Hội trường A",       Color = "orange", CreatedAt = baseDate },
                new Event { Id = "ev-4", EventName = "Giải thể thao học sinh",   EventDate = baseDate.AddDays(40), Time = "07:30 - 11:30", Location = "Sân vận động",       Color = "red",    CreatedAt = baseDate },
                new Event { Id = "ev-5", EventName = "Triển lãm mỹ thuật",       EventDate = baseDate.AddDays(50), Time = "09:00 - 12:00", Location = "Phòng trưng bày",    Color = "purple", CreatedAt = baseDate }
            };
            context.Events.AddRange(events);

            // ── Notifications ──────────────────────────────────────────────
            var notifDate = new DateTime(2025, 1, 1, 8, 0, 0, DateTimeKind.Utc);
            var notifications = new[]
            {
                new Notification { Id = "n-1", UserId = u1, Title = "Thông báo học phí HK2",      Message = "Học phí học kỳ 2 đã đến hạn nộp.", Type = "Hệ thống", IsRead = false, CreatedAt = notifDate },
                new Notification { Id = "n-2", UserId = u1, Title = "Kết quả học tập tháng 1",    Message = "Kết quả học tập tháng 1 đã được cập nhật.", Type = "Học tập", IsRead = true,  CreatedAt = notifDate.AddDays(1) },
                new Notification { Id = "n-3", UserId = u2, Title = "Sự kiện sắp diễn ra",        Message = "Hội trại cuối năm sẽ diễn ra vào ngày 21/1.", Type = "Sự kiện", IsRead = false, CreatedAt = notifDate.AddDays(2) },
                new Notification { Id = "n-4", UserId = u2, Title = "Lịch kiểm tra giữa kỳ",      Message = "Lịch kiểm tra giữa kỳ đã được đăng tải.", Type = "Học tập", IsRead = true,  CreatedAt = notifDate.AddDays(3) },
                new Notification { Id = "n-5", UserId = u3, Title = "Đơn xin nghỉ đã được duyệt", Message = "Đơn xin nghỉ của con bạn đã được phê duyệt.", Type = "Hệ thống", IsRead = false, CreatedAt = notifDate.AddDays(4) }
            };
            context.Notifications.AddRange(notifications);

            // ── Forms ──────────────────────────────────────────────────────
            var formDate = new DateTime(2025, 1, 5, 0, 0, 0, DateTimeKind.Utc);
            var forms = new[]
            {
                new Form { Id = "f-1", UserId = u1, ChildId = c1, Title = "Đơn xin nghỉ học",  Type = "xin nghỉ học",  Date = "05/01/2025", Reason = "Gia đình có việc đột xuất",           Status = "Đã duyệt",  CreatedAt = formDate },
                new Form { Id = "f-2", UserId = u1, ChildId = c2, Title = "Đơn xin ngoại khóa", Type = "xin ngoại khóa", Date = "10/01/2025", Reason = "Tham gia hội trại trường",              Status = "Chờ duyệt", CreatedAt = formDate.AddDays(5) },
                new Form { Id = "f-3", UserId = u2, ChildId = c3, Title = "Đơn xin chuyển lớp", Type = "xin chuyển lớp", Date = "12/01/2025", Reason = "Nhà chuyển chỗ, đi lại khó khăn",      Status = "Từ chối",   CreatedAt = formDate.AddDays(7) },
                new Form { Id = "f-4", UserId = u2, ChildId = c4, Title = "Đơn xin nghỉ học",  Type = "xin nghỉ học",  Date = "15/01/2025", Reason = "Con bị ốm cần nghỉ ngơi tại nhà",      Status = "Đã duyệt",  CreatedAt = formDate.AddDays(10) },
                new Form { Id = "f-5", UserId = u3, ChildId = c5, Title = "Đơn xin nghỉ học",  Type = "xin nghỉ học",  Date = "18/01/2025", Reason = "Con tham dự đám cưới của người thân",   Status = "Chờ duyệt", CreatedAt = formDate.AddDays(13) }
            };
            context.Forms.AddRange(forms);

            // ── Grades ─────────────────────────────────────────────────────
            var term = "HK1";
            var year = "2024-2025";
            var subjects = new[] { "Toán học", "Ngữ văn", "Tiếng Anh", "Khoa học", "Lịch sử", "Địa lý" };
            var scores    = new decimal[] { 9.5m, 8.0m, 9.0m, 7.5m, 8.5m, 9.2m };
            var gradeIdx = 0;
            var gradesToSeed = new List<Grade>();
            foreach (var child in new[] { c1, c2, c3, c4, c5, c6 })
            {
                for (int s = 0; s < subjects.Length; s++)
                {
                    gradeIdx++;
                    gradesToSeed.Add(new Grade
                    {
                        Id      = $"gr-{gradeIdx}",
                        ChildId = child,
                        Subject = subjects[s],
                        Term    = term,
                        Year    = year,
                        Quiz15Min = scores[s] - (gradeIdx % 3) * 0.3m,
                        OralTest = scores[s] - (gradeIdx % 3) * 0.2m,
                        Test45Min = scores[s] - (gradeIdx % 3) * 0.1m,
                        FinalExam = scores[s]
                    });
                }
            }
            context.Grades.AddRange(gradesToSeed);

            // ── Schedules ──────────────────────────────────────────────────
            var days    = new[] { "Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6" };
            var scheduleClasses = new[] { "3A1", "5B2", "4C3", "2A1", "1B1" };
            var subjectPool = new[] { "Toán học", "Ngữ văn", "Tiếng Anh", "Khoa học", "Lịch sử", "Địa lý", "Đạo đức", "Thể dục" };
            var schIdx = 0;
            var schedulesToSeed = new List<Schedule>();
            foreach (var cls in scheduleClasses)
            {
                foreach (var day in days)
                {
                    for (int slot = 1; slot <= 4; slot++)
                    {
                        schIdx++;
                        schedulesToSeed.Add(new Schedule
                        {
                            Id        = $"sch-{schIdx}",
                            ClassName = cls,
                            DayOfWeek = day,
                            Slot      = slot,
                            Subject   = subjectPool[(schIdx - 1) % subjectPool.Length],
                            Teacher   = schIdx % 2 == 0 ? "tranthib@myfschools.com" : "phamvand@myfschools.com",
                            Room      = $"P.{200 + (schIdx % 20)}",
                            Term      = "2024-2025"
                        });
                    }
                }
            }
            context.Schedules.AddRange(schedulesToSeed);

            context.SaveChanges();
        }
    }
}
