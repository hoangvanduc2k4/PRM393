using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MyFSchools.Api.Models;
using MyFSchools.Api.Repositories;

namespace MyFSchools.Api.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class EventsController : ControllerBase
    {
        private readonly IEventRepository _repo;

        public EventsController(IEventRepository repo)
        {
            _repo = repo;
        }

        // GET: api/events
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            return Ok(await _repo.GetAllAsync());
        }

        // GET: api/events/{id}
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(string id)
        {
            var ev = await _repo.GetByIdAsync(id);
            if (ev == null) return NotFound();
            return Ok(ev);
        }

        // GET: api/events/upcoming
        [HttpGet("upcoming")]
        public async Task<IActionResult> GetUpcoming()
        {
            return Ok(await _repo.GetUpcomingEventsAsync());
        }

        // GET: api/events/by-range?from=...&to=...
        [HttpGet("by-range")]
        public async Task<IActionResult> GetByRange([FromQuery] DateTime from, [FromQuery] DateTime to)
        {
            return Ok(await _repo.GetByDateRangeAsync(from, to));
        }

        // POST: api/events
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] Event ev)
        {
            var created = await _repo.CreateAsync(ev);
            return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
        }

        // PUT: api/events/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(string id, [FromBody] Event ev)
        {
            var updated = await _repo.UpdateAsync(id, ev);
            if (updated == null) return NotFound();
            return Ok(updated);
        }

        // DELETE: api/events/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            var result = await _repo.DeleteAsync(id);
            if (!result) return NotFound();
            return NoContent();
        }
    }
}
