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

        // GET: api/clubs/{id}
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(string id)
        {
            var club = await _repo.GetByIdAsync(id);
            if (club == null) return NotFound();
            return Ok(club);
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

        // POST: api/clubs
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] Club club)
        {
            if (string.IsNullOrEmpty(club.Id))
                club.Id = Guid.NewGuid().ToString();
            var created = await _repo.CreateAsync(club);
            return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
        }

        // PUT: api/clubs/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(string id, [FromBody] Club club)
        {
            var updated = await _repo.UpdateAsync(id, club);
            if (updated == null) return NotFound();
            return Ok(updated);
        }

        // DELETE: api/clubs/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            var result = await _repo.DeleteAsync(id);
            if (!result) return NotFound();
            return NoContent();
        }
    }
}
