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

        // GET: api/notifications
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            return Ok(await _repo.GetAllAsync());
        }

        // GET: api/notifications/{id}
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(string id)
        {
            var notification = await _repo.GetByIdAsync(id);
            if (notification == null) return NotFound();
            return Ok(notification);
        }

        // GET: api/notifications/by-user/{userId}
        [HttpGet("by-user/{userId}")]
        public async Task<IActionResult> GetByUser(string userId)
        {
            return Ok(await _repo.GetByUserIdAsync(userId));
        }

        // GET: api/notifications/unread-count/{userId}
        [HttpGet("unread-count/{userId}")]
        public async Task<IActionResult> GetUnreadCount(string userId)
        {
            var count = await _repo.GetUnreadCountAsync(userId);
            return Ok(new { count });
        }

        // PATCH: api/notifications/{id}/read
        [HttpPatch("{id}/read")]
        public async Task<IActionResult> MarkAsRead(string id)
        {
            var result = await _repo.MarkAsReadAsync(id);
            if (!result) return NotFound();
            return Ok(new { message = "Đã đánh dấu đã đọc" });
        }

        // POST: api/notifications
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] Notification notification)
        {
            var created = await _repo.CreateAsync(notification);
            return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
        }

        // PUT: api/notifications/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(string id, [FromBody] Notification notification)
        {
            var updated = await _repo.UpdateAsync(id, notification);
            if (updated == null) return NotFound();
            return Ok(updated);
        }

        // DELETE: api/notifications/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            var result = await _repo.DeleteAsync(id);
            if (!result) return NotFound();
            return NoContent();
        }
    }
}
