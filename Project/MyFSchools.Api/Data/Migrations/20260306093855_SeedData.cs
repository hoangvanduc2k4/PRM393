using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace MyFSchools.Api.Data.Migrations
{
    /// <inheritdoc />
    public partial class SeedData : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Clubs",
                columns: new[] { "Id", "Category", "MemberCount", "Name" },
                values: new object[,]
                {
                    { "cl-1", "Học thuật", 3, "Câu lạc bộ Toán học" },
                    { "cl-2", "Thể thao", 3, "Câu lạc bộ Bóng đá" },
                    { "cl-3", "Nghệ thuật", 2, "Câu lạc bộ Mỹ thuật" },
                    { "cl-4", "Khoa học", 2, "Câu lạc bộ Khoa học" },
                    { "cl-5", "Nghệ thuật", 2, "Câu lạc bộ Âm nhạc" }
                });

            migrationBuilder.InsertData(
                table: "Events",
                columns: new[] { "Id", "Color", "CreatedAt", "EventDate", "EventName", "Location", "Time" },
                values: new object[,]
                {
                    { "ev-1", "blue", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), new DateTime(2025, 1, 11, 0, 0, 0, 0, DateTimeKind.Utc), "Ngày hội khoa học", "Sân trường", "08:00 - 11:00" },
                    { "ev-2", "green", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), new DateTime(2025, 1, 21, 0, 0, 0, 0, DateTimeKind.Utc), "Hội trại cuối năm", "Công viên Gia Định", "07:00 - 17:00" },
                    { "ev-3", "orange", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), new DateTime(2025, 1, 31, 0, 0, 0, 0, DateTimeKind.Utc), "Văn nghệ chào xuân", "Hội trường A", "14:00 - 16:30" },
                    { "ev-4", "red", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), new DateTime(2025, 2, 10, 0, 0, 0, 0, DateTimeKind.Utc), "Giải thể thao học sinh", "Sân vận động", "07:30 - 11:30" },
                    { "ev-5", "purple", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), new DateTime(2025, 2, 20, 0, 0, 0, 0, DateTimeKind.Utc), "Triển lãm mỹ thuật", "Phòng trưng bày", "09:00 - 12:00" }
                });

            migrationBuilder.InsertData(
                table: "Schedules",
                columns: new[] { "Id", "ClassName", "DayOfWeek", "Room", "Slot", "Subject", "Teacher", "Term" },
                values: new object[,]
                {
                    { "sch-1", "3A1", "Thứ 2", "P.201", 1, "Toán học", "GV02", "2024-2025" },
                    { "sch-10", "3A1", "Thứ 4", "P.210", 2, "Ngữ văn", "GV11", "2024-2025" },
                    { "sch-100", "1B1", "Thứ 6", "P.200", 4, "Khoa học", "GV11", "2024-2025" },
                    { "sch-11", "3A1", "Thứ 4", "P.211", 3, "Tiếng Anh", "GV12", "2024-2025" },
                    { "sch-12", "3A1", "Thứ 4", "P.212", 4, "Khoa học", "GV13", "2024-2025" },
                    { "sch-13", "3A1", "Thứ 5", "P.213", 1, "Lịch sử", "GV14", "2024-2025" },
                    { "sch-14", "3A1", "Thứ 5", "P.214", 2, "Địa lý", "GV15", "2024-2025" },
                    { "sch-15", "3A1", "Thứ 5", "P.215", 3, "Đạo đức", "GV01", "2024-2025" },
                    { "sch-16", "3A1", "Thứ 5", "P.216", 4, "Thể dục", "GV02", "2024-2025" },
                    { "sch-17", "3A1", "Thứ 6", "P.217", 1, "Toán học", "GV03", "2024-2025" },
                    { "sch-18", "3A1", "Thứ 6", "P.218", 2, "Ngữ văn", "GV04", "2024-2025" },
                    { "sch-19", "3A1", "Thứ 6", "P.219", 3, "Tiếng Anh", "GV05", "2024-2025" },
                    { "sch-2", "3A1", "Thứ 2", "P.202", 2, "Ngữ văn", "GV03", "2024-2025" },
                    { "sch-20", "3A1", "Thứ 6", "P.200", 4, "Khoa học", "GV06", "2024-2025" },
                    { "sch-21", "5B2", "Thứ 2", "P.201", 1, "Lịch sử", "GV07", "2024-2025" },
                    { "sch-22", "5B2", "Thứ 2", "P.202", 2, "Địa lý", "GV08", "2024-2025" },
                    { "sch-23", "5B2", "Thứ 2", "P.203", 3, "Đạo đức", "GV09", "2024-2025" },
                    { "sch-24", "5B2", "Thứ 2", "P.204", 4, "Thể dục", "GV10", "2024-2025" },
                    { "sch-25", "5B2", "Thứ 3", "P.205", 1, "Toán học", "GV11", "2024-2025" },
                    { "sch-26", "5B2", "Thứ 3", "P.206", 2, "Ngữ văn", "GV12", "2024-2025" },
                    { "sch-27", "5B2", "Thứ 3", "P.207", 3, "Tiếng Anh", "GV13", "2024-2025" },
                    { "sch-28", "5B2", "Thứ 3", "P.208", 4, "Khoa học", "GV14", "2024-2025" },
                    { "sch-29", "5B2", "Thứ 4", "P.209", 1, "Lịch sử", "GV15", "2024-2025" },
                    { "sch-3", "3A1", "Thứ 2", "P.203", 3, "Tiếng Anh", "GV04", "2024-2025" },
                    { "sch-30", "5B2", "Thứ 4", "P.210", 2, "Địa lý", "GV01", "2024-2025" },
                    { "sch-31", "5B2", "Thứ 4", "P.211", 3, "Đạo đức", "GV02", "2024-2025" },
                    { "sch-32", "5B2", "Thứ 4", "P.212", 4, "Thể dục", "GV03", "2024-2025" },
                    { "sch-33", "5B2", "Thứ 5", "P.213", 1, "Toán học", "GV04", "2024-2025" },
                    { "sch-34", "5B2", "Thứ 5", "P.214", 2, "Ngữ văn", "GV05", "2024-2025" },
                    { "sch-35", "5B2", "Thứ 5", "P.215", 3, "Tiếng Anh", "GV06", "2024-2025" },
                    { "sch-36", "5B2", "Thứ 5", "P.216", 4, "Khoa học", "GV07", "2024-2025" },
                    { "sch-37", "5B2", "Thứ 6", "P.217", 1, "Lịch sử", "GV08", "2024-2025" },
                    { "sch-38", "5B2", "Thứ 6", "P.218", 2, "Địa lý", "GV09", "2024-2025" },
                    { "sch-39", "5B2", "Thứ 6", "P.219", 3, "Đạo đức", "GV10", "2024-2025" },
                    { "sch-4", "3A1", "Thứ 2", "P.204", 4, "Khoa học", "GV05", "2024-2025" },
                    { "sch-40", "5B2", "Thứ 6", "P.200", 4, "Thể dục", "GV11", "2024-2025" },
                    { "sch-41", "4C3", "Thứ 2", "P.201", 1, "Toán học", "GV12", "2024-2025" },
                    { "sch-42", "4C3", "Thứ 2", "P.202", 2, "Ngữ văn", "GV13", "2024-2025" },
                    { "sch-43", "4C3", "Thứ 2", "P.203", 3, "Tiếng Anh", "GV14", "2024-2025" },
                    { "sch-44", "4C3", "Thứ 2", "P.204", 4, "Khoa học", "GV15", "2024-2025" },
                    { "sch-45", "4C3", "Thứ 3", "P.205", 1, "Lịch sử", "GV01", "2024-2025" },
                    { "sch-46", "4C3", "Thứ 3", "P.206", 2, "Địa lý", "GV02", "2024-2025" },
                    { "sch-47", "4C3", "Thứ 3", "P.207", 3, "Đạo đức", "GV03", "2024-2025" },
                    { "sch-48", "4C3", "Thứ 3", "P.208", 4, "Thể dục", "GV04", "2024-2025" },
                    { "sch-49", "4C3", "Thứ 4", "P.209", 1, "Toán học", "GV05", "2024-2025" },
                    { "sch-5", "3A1", "Thứ 3", "P.205", 1, "Lịch sử", "GV06", "2024-2025" },
                    { "sch-50", "4C3", "Thứ 4", "P.210", 2, "Ngữ văn", "GV06", "2024-2025" },
                    { "sch-51", "4C3", "Thứ 4", "P.211", 3, "Tiếng Anh", "GV07", "2024-2025" },
                    { "sch-52", "4C3", "Thứ 4", "P.212", 4, "Khoa học", "GV08", "2024-2025" },
                    { "sch-53", "4C3", "Thứ 5", "P.213", 1, "Lịch sử", "GV09", "2024-2025" },
                    { "sch-54", "4C3", "Thứ 5", "P.214", 2, "Địa lý", "GV10", "2024-2025" },
                    { "sch-55", "4C3", "Thứ 5", "P.215", 3, "Đạo đức", "GV11", "2024-2025" },
                    { "sch-56", "4C3", "Thứ 5", "P.216", 4, "Thể dục", "GV12", "2024-2025" },
                    { "sch-57", "4C3", "Thứ 6", "P.217", 1, "Toán học", "GV13", "2024-2025" },
                    { "sch-58", "4C3", "Thứ 6", "P.218", 2, "Ngữ văn", "GV14", "2024-2025" },
                    { "sch-59", "4C3", "Thứ 6", "P.219", 3, "Tiếng Anh", "GV15", "2024-2025" },
                    { "sch-6", "3A1", "Thứ 3", "P.206", 2, "Địa lý", "GV07", "2024-2025" },
                    { "sch-60", "4C3", "Thứ 6", "P.200", 4, "Khoa học", "GV01", "2024-2025" },
                    { "sch-61", "2A1", "Thứ 2", "P.201", 1, "Lịch sử", "GV02", "2024-2025" },
                    { "sch-62", "2A1", "Thứ 2", "P.202", 2, "Địa lý", "GV03", "2024-2025" },
                    { "sch-63", "2A1", "Thứ 2", "P.203", 3, "Đạo đức", "GV04", "2024-2025" },
                    { "sch-64", "2A1", "Thứ 2", "P.204", 4, "Thể dục", "GV05", "2024-2025" },
                    { "sch-65", "2A1", "Thứ 3", "P.205", 1, "Toán học", "GV06", "2024-2025" },
                    { "sch-66", "2A1", "Thứ 3", "P.206", 2, "Ngữ văn", "GV07", "2024-2025" },
                    { "sch-67", "2A1", "Thứ 3", "P.207", 3, "Tiếng Anh", "GV08", "2024-2025" },
                    { "sch-68", "2A1", "Thứ 3", "P.208", 4, "Khoa học", "GV09", "2024-2025" },
                    { "sch-69", "2A1", "Thứ 4", "P.209", 1, "Lịch sử", "GV10", "2024-2025" },
                    { "sch-7", "3A1", "Thứ 3", "P.207", 3, "Đạo đức", "GV08", "2024-2025" },
                    { "sch-70", "2A1", "Thứ 4", "P.210", 2, "Địa lý", "GV11", "2024-2025" },
                    { "sch-71", "2A1", "Thứ 4", "P.211", 3, "Đạo đức", "GV12", "2024-2025" },
                    { "sch-72", "2A1", "Thứ 4", "P.212", 4, "Thể dục", "GV13", "2024-2025" },
                    { "sch-73", "2A1", "Thứ 5", "P.213", 1, "Toán học", "GV14", "2024-2025" },
                    { "sch-74", "2A1", "Thứ 5", "P.214", 2, "Ngữ văn", "GV15", "2024-2025" },
                    { "sch-75", "2A1", "Thứ 5", "P.215", 3, "Tiếng Anh", "GV01", "2024-2025" },
                    { "sch-76", "2A1", "Thứ 5", "P.216", 4, "Khoa học", "GV02", "2024-2025" },
                    { "sch-77", "2A1", "Thứ 6", "P.217", 1, "Lịch sử", "GV03", "2024-2025" },
                    { "sch-78", "2A1", "Thứ 6", "P.218", 2, "Địa lý", "GV04", "2024-2025" },
                    { "sch-79", "2A1", "Thứ 6", "P.219", 3, "Đạo đức", "GV05", "2024-2025" },
                    { "sch-8", "3A1", "Thứ 3", "P.208", 4, "Thể dục", "GV09", "2024-2025" },
                    { "sch-80", "2A1", "Thứ 6", "P.200", 4, "Thể dục", "GV06", "2024-2025" },
                    { "sch-81", "1B1", "Thứ 2", "P.201", 1, "Toán học", "GV07", "2024-2025" },
                    { "sch-82", "1B1", "Thứ 2", "P.202", 2, "Ngữ văn", "GV08", "2024-2025" },
                    { "sch-83", "1B1", "Thứ 2", "P.203", 3, "Tiếng Anh", "GV09", "2024-2025" },
                    { "sch-84", "1B1", "Thứ 2", "P.204", 4, "Khoa học", "GV10", "2024-2025" },
                    { "sch-85", "1B1", "Thứ 3", "P.205", 1, "Lịch sử", "GV11", "2024-2025" },
                    { "sch-86", "1B1", "Thứ 3", "P.206", 2, "Địa lý", "GV12", "2024-2025" },
                    { "sch-87", "1B1", "Thứ 3", "P.207", 3, "Đạo đức", "GV13", "2024-2025" },
                    { "sch-88", "1B1", "Thứ 3", "P.208", 4, "Thể dục", "GV14", "2024-2025" },
                    { "sch-89", "1B1", "Thứ 4", "P.209", 1, "Toán học", "GV15", "2024-2025" },
                    { "sch-9", "3A1", "Thứ 4", "P.209", 1, "Toán học", "GV10", "2024-2025" },
                    { "sch-90", "1B1", "Thứ 4", "P.210", 2, "Ngữ văn", "GV01", "2024-2025" },
                    { "sch-91", "1B1", "Thứ 4", "P.211", 3, "Tiếng Anh", "GV02", "2024-2025" },
                    { "sch-92", "1B1", "Thứ 4", "P.212", 4, "Khoa học", "GV03", "2024-2025" },
                    { "sch-93", "1B1", "Thứ 5", "P.213", 1, "Lịch sử", "GV04", "2024-2025" },
                    { "sch-94", "1B1", "Thứ 5", "P.214", 2, "Địa lý", "GV05", "2024-2025" },
                    { "sch-95", "1B1", "Thứ 5", "P.215", 3, "Đạo đức", "GV06", "2024-2025" },
                    { "sch-96", "1B1", "Thứ 5", "P.216", 4, "Thể dục", "GV07", "2024-2025" },
                    { "sch-97", "1B1", "Thứ 6", "P.217", 1, "Toán học", "GV08", "2024-2025" },
                    { "sch-98", "1B1", "Thứ 6", "P.218", 2, "Ngữ văn", "GV09", "2024-2025" },
                    { "sch-99", "1B1", "Thứ 6", "P.219", 3, "Tiếng Anh", "GV10", "2024-2025" }
                });

            migrationBuilder.InsertData(
                table: "Users",
                columns: new[] { "Id", "ActiveChildId", "Email", "Password", "Phone" },
                values: new object[,]
                {
                    { "u-001", null, "nguyenvana@myfschools.com", "Password123", "0912345678" },
                    { "u-002", null, "tranthib@myfschools.com", "Password123", "0923456789" },
                    { "u-003", null, "lehongc@myfschools.com", "Password123", "0934567890" }
                });

            migrationBuilder.InsertData(
                table: "Children",
                columns: new[] { "Id", "AvatarUrl", "ClassName", "FullName", "UserId" },
                values: new object[,]
                {
                    { "c-001", "https://i.pravatar.cc/150?u=c1", "3A1", "Nguyễn Minh An", "u-001" },
                    { "c-002", "https://i.pravatar.cc/150?u=c2", "5B2", "Nguyễn Thu Hà", "u-001" },
                    { "c-003", "https://i.pravatar.cc/150?u=c3", "4C3", "Trần Quốc Bảo", "u-002" },
                    { "c-004", "https://i.pravatar.cc/150?u=c4", "2A1", "Trần Khánh Linh", "u-002" },
                    { "c-005", "https://i.pravatar.cc/150?u=c5", "1B1", "Lê Hoàng Nam", "u-003" },
                    { "c-006", "https://i.pravatar.cc/150?u=c6", "3A1", "Lê Thanh Phương", "u-003" }
                });

            migrationBuilder.InsertData(
                table: "Notifications",
                columns: new[] { "Id", "CreatedAt", "IsRead", "Message", "Title", "Type", "UserId" },
                values: new object[,]
                {
                    { "n-1", new DateTime(2025, 1, 1, 8, 0, 0, 0, DateTimeKind.Utc), false, "Học phí học kỳ 2 đã đến hạn nộp.", "Thông báo học phí HK2", "Hệ thống", "u-001" },
                    { "n-2", new DateTime(2025, 1, 2, 8, 0, 0, 0, DateTimeKind.Utc), true, "Kết quả học tập tháng 1 đã được cập nhật.", "Kết quả học tập tháng 1", "Học tập", "u-001" },
                    { "n-3", new DateTime(2025, 1, 3, 8, 0, 0, 0, DateTimeKind.Utc), false, "Hội trại cuối năm sẽ diễn ra vào ngày 21/1.", "Sự kiện sắp diễn ra", "Sự kiện", "u-002" },
                    { "n-4", new DateTime(2025, 1, 4, 8, 0, 0, 0, DateTimeKind.Utc), true, "Lịch kiểm tra giữa kỳ đã được đăng tải.", "Lịch kiểm tra giữa kỳ", "Học tập", "u-002" },
                    { "n-5", new DateTime(2025, 1, 5, 8, 0, 0, 0, DateTimeKind.Utc), false, "Đơn xin nghỉ của con bạn đã được phê duyệt.", "Đơn xin nghỉ đã được duyệt", "Hệ thống", "u-003" }
                });

            migrationBuilder.InsertData(
                table: "ChildClubs",
                columns: new[] { "ChildId", "ClubId" },
                values: new object[,]
                {
                    { "c-001", "cl-1" },
                    { "c-001", "cl-2" },
                    { "c-002", "cl-3" },
                    { "c-003", "cl-1" },
                    { "c-003", "cl-4" },
                    { "c-004", "cl-2" },
                    { "c-005", "cl-3" },
                    { "c-005", "cl-5" },
                    { "c-006", "cl-2" },
                    { "c-006", "cl-4" }
                });

            migrationBuilder.InsertData(
                table: "Forms",
                columns: new[] { "Id", "ChildId", "CreatedAt", "Date", "Reason", "Status", "Title", "Type", "UserId" },
                values: new object[,]
                {
                    { "f-1", "c-001", new DateTime(2025, 1, 5, 0, 0, 0, 0, DateTimeKind.Utc), "05/01/2025", "Gia đình có việc đột xuất", "Đã duyệt", "Đơn xin nghỉ học", "xin nghỉ học", "u-001" },
                    { "f-2", "c-002", new DateTime(2025, 1, 10, 0, 0, 0, 0, DateTimeKind.Utc), "10/01/2025", "Tham gia hội trại trường", "Chờ duyệt", "Đơn xin ngoại khóa", "xin ngoại khóa", "u-001" },
                    { "f-3", "c-003", new DateTime(2025, 1, 12, 0, 0, 0, 0, DateTimeKind.Utc), "12/01/2025", "Nhà chuyển chỗ, đi lại khó khăn", "Từ chối", "Đơn xin chuyển lớp", "xin chuyển lớp", "u-002" },
                    { "f-4", "c-004", new DateTime(2025, 1, 15, 0, 0, 0, 0, DateTimeKind.Utc), "15/01/2025", "Con bị ốm cần nghỉ ngơi tại nhà", "Đã duyệt", "Đơn xin nghỉ học", "xin nghỉ học", "u-002" },
                    { "f-5", "c-005", new DateTime(2025, 1, 18, 0, 0, 0, 0, DateTimeKind.Utc), "18/01/2025", "Con tham dự đám cưới của người thân", "Chờ duyệt", "Đơn xin nghỉ học", "xin nghỉ học", "u-003" }
                });

            migrationBuilder.InsertData(
                table: "Grades",
                columns: new[] { "Id", "Average", "ChildId", "Status", "Subject", "Term" },
                values: new object[,]
                {
                    { "gr-1", 9.2m, "c-001", "Passed", "Toán học", "Học kỳ 1 - 2024-2025" },
                    { "gr-10", 7.2m, "c-002", "Passed", "Khoa học", "Học kỳ 1 - 2024-2025" },
                    { "gr-11", 7.9m, "c-002", "Passed", "Lịch sử", "Học kỳ 1 - 2024-2025" },
                    { "gr-12", 9.2m, "c-002", "Passed", "Địa lý", "Học kỳ 1 - 2024-2025" },
                    { "gr-13", 9.2m, "c-003", "Passed", "Toán học", "Học kỳ 1 - 2024-2025" },
                    { "gr-14", 7.4m, "c-003", "Passed", "Ngữ văn", "Học kỳ 1 - 2024-2025" },
                    { "gr-15", 9.0m, "c-003", "Passed", "Tiếng Anh", "Học kỳ 1 - 2024-2025" },
                    { "gr-16", 7.2m, "c-003", "Passed", "Khoa học", "Học kỳ 1 - 2024-2025" },
                    { "gr-17", 7.9m, "c-003", "Passed", "Lịch sử", "Học kỳ 1 - 2024-2025" },
                    { "gr-18", 9.2m, "c-003", "Passed", "Địa lý", "Học kỳ 1 - 2024-2025" },
                    { "gr-19", 9.2m, "c-004", "Passed", "Toán học", "Học kỳ 1 - 2024-2025" },
                    { "gr-2", 7.4m, "c-001", "Passed", "Ngữ văn", "Học kỳ 1 - 2024-2025" },
                    { "gr-20", 7.4m, "c-004", "Passed", "Ngữ văn", "Học kỳ 1 - 2024-2025" },
                    { "gr-21", 9.0m, "c-004", "Passed", "Tiếng Anh", "Học kỳ 1 - 2024-2025" },
                    { "gr-22", 7.2m, "c-004", "Passed", "Khoa học", "Học kỳ 1 - 2024-2025" },
                    { "gr-23", 7.9m, "c-004", "Passed", "Lịch sử", "Học kỳ 1 - 2024-2025" },
                    { "gr-24", 9.2m, "c-004", "Passed", "Địa lý", "Học kỳ 1 - 2024-2025" },
                    { "gr-25", 9.2m, "c-005", "Passed", "Toán học", "Học kỳ 1 - 2024-2025" },
                    { "gr-26", 7.4m, "c-005", "Passed", "Ngữ văn", "Học kỳ 1 - 2024-2025" },
                    { "gr-27", 9.0m, "c-005", "Passed", "Tiếng Anh", "Học kỳ 1 - 2024-2025" },
                    { "gr-28", 7.2m, "c-005", "Passed", "Khoa học", "Học kỳ 1 - 2024-2025" },
                    { "gr-29", 7.9m, "c-005", "Passed", "Lịch sử", "Học kỳ 1 - 2024-2025" },
                    { "gr-3", 9.0m, "c-001", "Passed", "Tiếng Anh", "Học kỳ 1 - 2024-2025" },
                    { "gr-30", 9.2m, "c-005", "Passed", "Địa lý", "Học kỳ 1 - 2024-2025" },
                    { "gr-31", 9.2m, "c-006", "Passed", "Toán học", "Học kỳ 1 - 2024-2025" },
                    { "gr-32", 7.4m, "c-006", "Passed", "Ngữ văn", "Học kỳ 1 - 2024-2025" },
                    { "gr-33", 9.0m, "c-006", "Passed", "Tiếng Anh", "Học kỳ 1 - 2024-2025" },
                    { "gr-34", 7.2m, "c-006", "Passed", "Khoa học", "Học kỳ 1 - 2024-2025" },
                    { "gr-35", 7.9m, "c-006", "Passed", "Lịch sử", "Học kỳ 1 - 2024-2025" },
                    { "gr-36", 9.2m, "c-006", "Passed", "Địa lý", "Học kỳ 1 - 2024-2025" },
                    { "gr-4", 7.2m, "c-001", "Passed", "Khoa học", "Học kỳ 1 - 2024-2025" },
                    { "gr-5", 7.9m, "c-001", "Passed", "Lịch sử", "Học kỳ 1 - 2024-2025" },
                    { "gr-6", 9.2m, "c-001", "Passed", "Địa lý", "Học kỳ 1 - 2024-2025" },
                    { "gr-7", 9.2m, "c-002", "Passed", "Toán học", "Học kỳ 1 - 2024-2025" },
                    { "gr-8", 7.4m, "c-002", "Passed", "Ngữ văn", "Học kỳ 1 - 2024-2025" },
                    { "gr-9", 9.0m, "c-002", "Passed", "Tiếng Anh", "Học kỳ 1 - 2024-2025" }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "ChildClubs",
                keyColumns: new[] { "ChildId", "ClubId" },
                keyValues: new object[] { "c-001", "cl-1" });

            migrationBuilder.DeleteData(
                table: "ChildClubs",
                keyColumns: new[] { "ChildId", "ClubId" },
                keyValues: new object[] { "c-001", "cl-2" });

            migrationBuilder.DeleteData(
                table: "ChildClubs",
                keyColumns: new[] { "ChildId", "ClubId" },
                keyValues: new object[] { "c-002", "cl-3" });

            migrationBuilder.DeleteData(
                table: "ChildClubs",
                keyColumns: new[] { "ChildId", "ClubId" },
                keyValues: new object[] { "c-003", "cl-1" });

            migrationBuilder.DeleteData(
                table: "ChildClubs",
                keyColumns: new[] { "ChildId", "ClubId" },
                keyValues: new object[] { "c-003", "cl-4" });

            migrationBuilder.DeleteData(
                table: "ChildClubs",
                keyColumns: new[] { "ChildId", "ClubId" },
                keyValues: new object[] { "c-004", "cl-2" });

            migrationBuilder.DeleteData(
                table: "ChildClubs",
                keyColumns: new[] { "ChildId", "ClubId" },
                keyValues: new object[] { "c-005", "cl-3" });

            migrationBuilder.DeleteData(
                table: "ChildClubs",
                keyColumns: new[] { "ChildId", "ClubId" },
                keyValues: new object[] { "c-005", "cl-5" });

            migrationBuilder.DeleteData(
                table: "ChildClubs",
                keyColumns: new[] { "ChildId", "ClubId" },
                keyValues: new object[] { "c-006", "cl-2" });

            migrationBuilder.DeleteData(
                table: "ChildClubs",
                keyColumns: new[] { "ChildId", "ClubId" },
                keyValues: new object[] { "c-006", "cl-4" });

            migrationBuilder.DeleteData(
                table: "Events",
                keyColumn: "Id",
                keyValue: "ev-1");

            migrationBuilder.DeleteData(
                table: "Events",
                keyColumn: "Id",
                keyValue: "ev-2");

            migrationBuilder.DeleteData(
                table: "Events",
                keyColumn: "Id",
                keyValue: "ev-3");

            migrationBuilder.DeleteData(
                table: "Events",
                keyColumn: "Id",
                keyValue: "ev-4");

            migrationBuilder.DeleteData(
                table: "Events",
                keyColumn: "Id",
                keyValue: "ev-5");

            migrationBuilder.DeleteData(
                table: "Forms",
                keyColumn: "Id",
                keyValue: "f-1");

            migrationBuilder.DeleteData(
                table: "Forms",
                keyColumn: "Id",
                keyValue: "f-2");

            migrationBuilder.DeleteData(
                table: "Forms",
                keyColumn: "Id",
                keyValue: "f-3");

            migrationBuilder.DeleteData(
                table: "Forms",
                keyColumn: "Id",
                keyValue: "f-4");

            migrationBuilder.DeleteData(
                table: "Forms",
                keyColumn: "Id",
                keyValue: "f-5");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-1");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-10");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-11");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-12");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-13");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-14");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-15");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-16");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-17");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-18");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-19");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-2");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-20");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-21");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-22");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-23");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-24");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-25");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-26");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-27");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-28");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-29");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-3");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-30");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-31");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-32");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-33");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-34");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-35");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-36");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-4");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-5");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-6");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-7");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-8");

            migrationBuilder.DeleteData(
                table: "Grades",
                keyColumn: "Id",
                keyValue: "gr-9");

            migrationBuilder.DeleteData(
                table: "Notifications",
                keyColumn: "Id",
                keyValue: "n-1");

            migrationBuilder.DeleteData(
                table: "Notifications",
                keyColumn: "Id",
                keyValue: "n-2");

            migrationBuilder.DeleteData(
                table: "Notifications",
                keyColumn: "Id",
                keyValue: "n-3");

            migrationBuilder.DeleteData(
                table: "Notifications",
                keyColumn: "Id",
                keyValue: "n-4");

            migrationBuilder.DeleteData(
                table: "Notifications",
                keyColumn: "Id",
                keyValue: "n-5");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-1");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-10");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-100");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-11");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-12");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-13");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-14");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-15");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-16");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-17");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-18");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-19");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-2");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-20");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-21");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-22");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-23");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-24");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-25");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-26");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-27");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-28");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-29");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-3");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-30");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-31");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-32");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-33");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-34");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-35");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-36");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-37");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-38");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-39");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-4");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-40");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-41");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-42");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-43");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-44");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-45");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-46");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-47");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-48");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-49");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-5");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-50");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-51");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-52");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-53");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-54");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-55");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-56");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-57");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-58");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-59");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-6");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-60");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-61");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-62");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-63");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-64");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-65");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-66");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-67");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-68");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-69");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-7");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-70");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-71");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-72");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-73");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-74");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-75");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-76");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-77");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-78");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-79");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-8");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-80");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-81");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-82");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-83");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-84");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-85");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-86");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-87");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-88");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-89");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-9");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-90");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-91");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-92");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-93");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-94");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-95");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-96");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-97");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-98");

            migrationBuilder.DeleteData(
                table: "Schedules",
                keyColumn: "Id",
                keyValue: "sch-99");

            migrationBuilder.DeleteData(
                table: "Children",
                keyColumn: "Id",
                keyValue: "c-001");

            migrationBuilder.DeleteData(
                table: "Children",
                keyColumn: "Id",
                keyValue: "c-002");

            migrationBuilder.DeleteData(
                table: "Children",
                keyColumn: "Id",
                keyValue: "c-003");

            migrationBuilder.DeleteData(
                table: "Children",
                keyColumn: "Id",
                keyValue: "c-004");

            migrationBuilder.DeleteData(
                table: "Children",
                keyColumn: "Id",
                keyValue: "c-005");

            migrationBuilder.DeleteData(
                table: "Children",
                keyColumn: "Id",
                keyValue: "c-006");

            migrationBuilder.DeleteData(
                table: "Clubs",
                keyColumn: "Id",
                keyValue: "cl-1");

            migrationBuilder.DeleteData(
                table: "Clubs",
                keyColumn: "Id",
                keyValue: "cl-2");

            migrationBuilder.DeleteData(
                table: "Clubs",
                keyColumn: "Id",
                keyValue: "cl-3");

            migrationBuilder.DeleteData(
                table: "Clubs",
                keyColumn: "Id",
                keyValue: "cl-4");

            migrationBuilder.DeleteData(
                table: "Clubs",
                keyColumn: "Id",
                keyValue: "cl-5");

            migrationBuilder.DeleteData(
                table: "Users",
                keyColumn: "Id",
                keyValue: "u-001");

            migrationBuilder.DeleteData(
                table: "Users",
                keyColumn: "Id",
                keyValue: "u-002");

            migrationBuilder.DeleteData(
                table: "Users",
                keyColumn: "Id",
                keyValue: "u-003");
        }
    }
}
