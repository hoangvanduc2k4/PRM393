using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MyFSchools.Api.Models;
using MyFSchools.Api.Repositories;

namespace MyFSchools.Api.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class NotificationsController : ControllerBase
    {
        private readonly INotificationRepository _repo;

        public NotificationsController(INotificationRepository repo)
        {
            _repo = repo;
        }



        // GET: api/notifications/by-user/{userId}
        [HttpGet("by-user/{userId}")]
        public async Task<IActionResult> GetByUser(string userId)
        {
            return Ok(await _repo.GetByUserIdAsync(userId));
        }



        // PATCH: api/notifications/{id}/read
        [HttpPatch("{id}/read")]
        public async Task<IActionResult> MarkAsRead(string id)
        {
            var result = await _repo.MarkAsReadAsync(id);
            if (!result) return NotFound();
            return Ok(new { message = "Đã đánh dấu đã đọc" });
        }


    }
}
