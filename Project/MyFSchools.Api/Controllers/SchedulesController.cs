using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MyFSchools.Api.Models;
using MyFSchools.Api.Repositories;

namespace MyFSchools.Api.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class SchedulesController : ControllerBase
    {
        private readonly IScheduleRepository _repo;

        public SchedulesController(IScheduleRepository repo)
        {
            _repo = repo;
        }

        // GET: api/schedules
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            return Ok(await _repo.GetAllAsync());
        }

        // GET: api/schedules/{id}
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(string id)
        {
            var schedule = await _repo.GetByIdAsync(id);
            if (schedule == null) return NotFound();
            return Ok(schedule);
        }

        // GET: api/schedules/by-class/{className}
        [HttpGet("by-class/{className}")]
        public async Task<IActionResult> GetByClass(string className)
        {
            return Ok(await _repo.GetByClassNameAsync(className));
        }

        // GET: api/schedules/by-class/{className}/day/{dayOfWeek}
        [HttpGet("by-class/{className}/day/{dayOfWeek}")]
        public async Task<IActionResult> GetByClassAndDay(string className, string dayOfWeek)
        {
            return Ok(await _repo.GetByClassNameAndDayAsync(className, dayOfWeek));
        }

        // GET: api/schedules/by-term?term=...
        [HttpGet("by-term")]
        public async Task<IActionResult> GetByTerm([FromQuery] string term)
        {
            return Ok(await _repo.GetByTermAsync(term));
        }

        // POST: api/schedules
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] Schedule schedule)
        {
            var created = await _repo.CreateAsync(schedule);
            return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
        }

        // PUT: api/schedules/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(string id, [FromBody] Schedule schedule)
        {
            var updated = await _repo.UpdateAsync(id, schedule);
            if (updated == null) return NotFound();
            return Ok(updated);
        }

        // DELETE: api/schedules/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            var result = await _repo.DeleteAsync(id);
            if (!result) return NotFound();
            return NoContent();
        }
    }
}
