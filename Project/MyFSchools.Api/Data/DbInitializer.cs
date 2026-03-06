using Bogus;
using Microsoft.EntityFrameworkCore;
using MyFSchools.Api.Models;
using System.Linq;
using System.Collections.Generic;

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

            var faker = new Faker(); // Not used directly, but good for shared settings if needed
            
            // 1. Seed Clubs
            var clubCategories = new[] { "Học thuật", "Nghệ thuật", "Thể thao", "Truyền thông", "Khoa học" };
            var clubFaker = new Faker<Club>()
                .RuleFor(c => c.Id, f => f.Random.Guid().ToString())
                .RuleFor(c => c.Name, f => f.Commerce.ProductName() + " Club")
                .RuleFor(c => c.Category, f => f.PickRandom(clubCategories))
                .RuleFor(c => c.MemberCount, f => 0);

            var clubs = clubFaker.Generate(10);
            context.Clubs.AddRange(clubs);

            // 2. Seed Users
            var userFaker = new Faker<User>()
                .RuleFor(u => u.Id, f => f.Random.Guid().ToString())
                .RuleFor(u => u.Email, (f, u) => f.Internet.Email())
                .RuleFor(u => u.Password, f => "Password123")
                .RuleFor(u => u.Phone, f => f.Phone.PhoneNumber("0#########"));

            var users = userFaker.Generate(10);
            context.Users.AddRange(users);

            // 3. Seed Children
            var classes = new[] { "3A1", "4B2", "5C3", "1A2", "2B1" };
            var childFaker = new Faker<Child>()
                .RuleFor(c => c.Id, f => f.Random.Guid().ToString())
                .RuleFor(c => c.FullName, f => f.Name.FullName())
                .RuleFor(c => c.ClassName, f => f.PickRandom(classes))
                .RuleFor(c => c.AvatarUrl, f => f.Internet.Avatar());

            var allChildren = new List<Child>();
            foreach (var user in users)
            {
                var children = childFaker.Generate(faker.Random.Number(1, 3));
                foreach (var child in children)
                {
                    child.UserId = user.Id;
                    allChildren.Add(child);
                }
                user.ActiveChildId = children.First().Id;
            }
            context.Children.AddRange(allChildren);

            // 4. Seed ChildClubs
            var childClubFaker = new Faker<ChildClub>();
            foreach (var child in allChildren)
            {
                var joinedClubs = faker.PickRandom(clubs, faker.Random.Number(1, 3));
                foreach (var club in joinedClubs)
                {
                    context.ChildClubs.Add(new ChildClub { ChildId = child.Id, ClubId = club.Id });
                    club.MemberCount++;
                }
            }

            // 5. Seed Events
            var eventFaker = new Faker<Event>()
                .RuleFor(e => e.Id, f => f.Random.Guid().ToString())
                .RuleFor(e => e.EventName, f => f.Company.CatchPhrase())
                .RuleFor(e => e.EventDate, f => f.Date.Future())
                .RuleFor(e => e.Time, f => "08:00 - 11:00")
                .RuleFor(e => e.Location, f => f.Address.StreetAddress())
                .RuleFor(e => e.Color, f => f.PickRandom(new[] { "blue", "red", "green", "orange", "purple" }));

            context.Events.AddRange(eventFaker.Generate(20));

            // 6. Seed Forms
            var formFaker = new Faker<Form>()
                .RuleFor(f => f.Id, f => f.Random.Guid().ToString())
                .RuleFor(f => f.Title, f => f.PickRandom("Đơn xin nghỉ học", "Đơn xin ngoại khóa", "Đơn chuyển lớp"))
                .RuleFor(f => f.Type, (f, fo) => fo.Title.Replace("Đơn ", ""))
                .RuleFor(f => f.Date, f => f.Date.Recent().ToString("dd/MM/yyyy"))
                .RuleFor(f => f.Reason, f => f.Lorem.Sentence())
                .RuleFor(f => f.Status, f => f.PickRandom("Chờ duyệt", "Đã duyệt", "Từ chối"));

            foreach (var child in allChildren)
            {
                var forms = formFaker.Generate(5);
                foreach (var form in forms)
                {
                    form.UserId = child.UserId;
                    form.ChildId = child.Id;
                    context.Forms.Add(form);
                }
            }

            // 7. Seed Grades
            var subjects = new[] { "Toán học", "Ngữ văn", "Tiếng Anh", "Khoa học", "Lịch sử", "Địa lý" };
            var gradeFaker = new Faker<Grade>()
                .RuleFor(g => g.Id, f => f.Random.Guid().ToString())
                .RuleFor(g => g.Subject, f => f.PickRandom(subjects))
                .RuleFor(g => g.Term, f => "Học kỳ 1 - 2024-2025")
                .RuleFor(g => g.Average, f => (decimal)f.Random.Double(5.0, 10.0))
                .RuleFor(g => g.Status, f => "Passed");

            foreach (var child in allChildren)
            {
                var grades = gradeFaker.Generate(6);
                foreach (var grade in grades)
                {
                    grade.ChildId = child.Id;
                    context.Grades.Add(grade);
                }
            }

            // 8. Seed Notifications
            var notificationFaker = new Faker<Notification>()
                .RuleFor(n => n.Id, f => f.Random.Guid().ToString())
                .RuleFor(n => n.Title, f => f.Lorem.Sentence(3))
                .RuleFor(n => n.Message, f => f.Lorem.Paragraph())
                .RuleFor(n => n.Type, f => f.PickRandom("Hệ thống", "Học tập", "Sự kiện"))
                .RuleFor(n => n.IsRead, f => f.Random.Bool())
                .RuleFor(n => n.CreatedAt, f => f.Date.Recent());

            foreach (var user in users)
            {
                var notifications = notificationFaker.Generate(10);
                foreach (var note in notifications)
                {
                    note.UserId = user.Id;
                    context.Notifications.Add(note);
                }
            }

            // 9. Seed Schedules
            var days = new[] { "Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6" };
            foreach (var className in classes)
            {
                foreach (var day in days)
                {
                    for (int slot = 1; slot <= 4; slot++)
                    {
                        context.Schedules.Add(new Schedule
                        {
                            Id = Guid.NewGuid().ToString(),
                            ClassName = className,
                            DayOfWeek = day,
                            Slot = slot,
                            Subject = faker.PickRandom(subjects),
                            Teacher = faker.Name.FullName(),
                            Room = "Room " + faker.Random.Number(101, 505),
                            Term = "2024-2025"
                        });
                    }
                }
            }

            context.SaveChanges();
        }
    }
}
