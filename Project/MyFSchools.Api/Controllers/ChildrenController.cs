using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MyFSchools.Api.Models;
using MyFSchools.Api.Repositories;

namespace MyFSchools.Api.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class ChildrenController : ControllerBase
    {
        private readonly IChildRepository _repo;

        public ChildrenController(IChildRepository repo)
        {
            _repo = repo;
        }

        // GET: api/children
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            return Ok(await _repo.GetAllAsync());
        }

        // GET: api/children/{id}
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(string id)
        {
            var child = await _repo.GetByIdAsync(id);
            if (child == null) return NotFound();
            return Ok(child);
        }

        // GET: api/children/by-user/{userId}
        [HttpGet("by-user/{userId}")]
        public async Task<IActionResult> GetByUser(string userId)
        {
            return Ok(await _repo.GetByUserIdAsync(userId));
        }

        // GET: api/children/{id}/clubs
        [HttpGet("{id}/clubs")]
        public async Task<IActionResult> GetWithClubs(string id)
        {
            var children = await _repo.GetWithClubsAsync(id);
            return Ok(children);
        }

        // POST: api/children
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] Child child)
        {
            if (string.IsNullOrEmpty(child.Id))
                child.Id = Guid.NewGuid().ToString();
            var created = await _repo.CreateAsync(child);
            return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
        }

        // PUT: api/children/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(string id, [FromBody] Child child)
        {
            var updated = await _repo.UpdateAsync(id, child);
            if (updated == null) return NotFound();
            return Ok(updated);
        }

        // DELETE: api/children/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            var result = await _repo.DeleteAsync(id);
            if (!result) return NotFound();
            return NoContent();
        }
    }
}
