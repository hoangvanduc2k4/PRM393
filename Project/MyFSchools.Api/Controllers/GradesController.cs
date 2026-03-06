using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MyFSchools.Api.Models;
using MyFSchools.Api.Repositories;

namespace MyFSchools.Api.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class GradesController : ControllerBase
    {
        private readonly IGradeRepository _repo;

        public GradesController(IGradeRepository repo)
        {
            _repo = repo;
        }

        // GET: api/grades
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            return Ok(await _repo.GetAllAsync());
        }

        // GET: api/grades/{id}
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(string id)
        {
            var grade = await _repo.GetByIdAsync(id);
            if (grade == null) return NotFound();
            return Ok(grade);
        }

        // GET: api/grades/by-child/{childId}
        [HttpGet("by-child/{childId}")]
        public async Task<IActionResult> GetByChild(string childId)
        {
            return Ok(await _repo.GetByChildIdAsync(childId));
        }

        // GET: api/grades/by-child/{childId}/term?term=...
        [HttpGet("by-child/{childId}/term")]
        public async Task<IActionResult> GetByChildAndTerm(string childId, [FromQuery] string term)
        {
            return Ok(await _repo.GetByChildIdAndTermAsync(childId, term));
        }

        // POST: api/grades
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] Grade grade)
        {
            var created = await _repo.CreateAsync(grade);
            return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
        }

        // PUT: api/grades/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(string id, [FromBody] Grade grade)
        {
            var updated = await _repo.UpdateAsync(id, grade);
            if (updated == null) return NotFound();
            return Ok(updated);
        }

        // DELETE: api/grades/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            var result = await _repo.DeleteAsync(id);
            if (!result) return NotFound();
            return NoContent();
        }
    }
}
