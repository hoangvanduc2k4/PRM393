using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MyFSchools.Api.Models;
using MyFSchools.Api.Repositories;

namespace MyFSchools.Api.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class FormsController : ControllerBase
    {
        private readonly IFormRepository _repo;

        public FormsController(IFormRepository repo)
        {
            _repo = repo;
        }

        // GET: api/forms
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            return Ok(await _repo.GetAllAsync());
        }

        // GET: api/forms/{id}
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(string id)
        {
            var form = await _repo.GetByIdAsync(id);
            if (form == null) return NotFound();
            return Ok(form);
        }

        // GET: api/forms/by-user/{userId}
        [HttpGet("by-user/{userId}")]
        public async Task<IActionResult> GetByUser(string userId)
        {
            return Ok(await _repo.GetByUserIdAsync(userId));
        }

        // GET: api/forms/by-child/{childId}
        [HttpGet("by-child/{childId}")]
        public async Task<IActionResult> GetByChild(string childId)
        {
            return Ok(await _repo.GetByChildIdAsync(childId));
        }

        // POST: api/forms
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] Form form)
        {
            var created = await _repo.CreateAsync(form);
            return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
        }

        // PUT: api/forms/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(string id, [FromBody] Form form)
        {
            var updated = await _repo.UpdateAsync(id, form);
            if (updated == null) return NotFound();
            return Ok(updated);
        }

        // PATCH: api/forms/{id}/status
        [HttpPatch("{id}/status")]
        public async Task<IActionResult> UpdateStatus(string id, [FromBody] UpdateStatusRequest request)
        {
            var updated = await _repo.UpdateStatusAsync(id, request.Status);
            if (updated == null) return NotFound();
            return Ok(updated);
        }

        // DELETE: api/forms/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            var result = await _repo.DeleteAsync(id);
            if (!result) return NotFound();
            return NoContent();
        }
    }

    public record UpdateStatusRequest(string Status);
}
