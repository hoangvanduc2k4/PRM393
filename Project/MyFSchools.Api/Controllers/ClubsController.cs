using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MyFSchools.Api.Models;
using MyFSchools.Api.Repositories;

namespace MyFSchools.Api.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class ClubsController : ControllerBase
    {
        private readonly IClubRepository _repo;

        public ClubsController(IClubRepository repo)
        {
            _repo = repo;
        }

        // GET: api/clubs
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            return Ok(await _repo.GetAllAsync());
        }



        // GET: api/clubs/by-child/{childId}
        [HttpGet("by-child/{childId}")]
        public async Task<IActionResult> GetByChild(string childId)
        {
            return Ok(await _repo.GetByChildIdAsync(childId));
        }

        // POST: api/clubs/{clubId}/join/{childId}
        [HttpPost("{clubId}/join/{childId}")]
        public async Task<IActionResult> Join(string clubId, string childId)
        {
            var result = await _repo.JoinClubAsync(childId, clubId);
            if (!result) return Conflict(new { message = "Học sinh đã tham gia câu lạc bộ này rồi" });
            return Ok(new { message = "Tham gia thành công" });
        }

        // DELETE: api/clubs/{clubId}/leave/{childId}
        [HttpDelete("{clubId}/leave/{childId}")]
        public async Task<IActionResult> Leave(string clubId, string childId)
        {
            var result = await _repo.LeaveClubAsync(childId, clubId);
            if (!result) return NotFound(new { message = "Không tìm thấy thành viên" });
            return Ok(new { message = "Rời câu lạc bộ thành công" });
        }


    }
}
