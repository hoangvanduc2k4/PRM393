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
            return Ok(created);
        }


    }

    public record UpdateStatusRequest(string Status);
}
