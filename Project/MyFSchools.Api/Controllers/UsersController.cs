using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MyFSchools.Api.Models;
using MyFSchools.Api.Repositories;

namespace MyFSchools.Api.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class UsersController : ControllerBase
    {
        private readonly IUserRepository _repo;

        public UsersController(IUserRepository repo)
        {
            _repo = repo;
        }

        // GET: api/users
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var users = await _repo.GetAllAsync();
            return Ok(users);
        }

        // GET: api/users/{id}
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(string id)
        {
            var user = await _repo.GetByIdAsync(id);
            if (user == null) return NotFound();
            return Ok(user);
        }

        // GET: api/users/{id}/with-children
        [HttpGet("{id}/with-children")]
        public async Task<IActionResult> GetWithChildren(string id)
        {
            var user = await _repo.GetWithChildrenAsync(id);
            if (user == null) return NotFound();
            return Ok(user);
        }

        // GET: api/users/by-email?email=...
        [HttpGet("by-email")]
        public async Task<IActionResult> GetByEmail([FromQuery] string email)
        {
            var user = await _repo.GetByEmailAsync(email);
            if (user == null) return NotFound();
            return Ok(user);
        }

        // POST: api/users/login
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest request)
        {
            var user = await _repo.GetByEmailAsync(request.Email);
            if (user == null || user.Password != request.Password)
                return Unauthorized(new { message = "Email hoặc mật khẩu không đúng" });
            return Ok(user);
        }

        // POST: api/users
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] User user)
        {
            if (string.IsNullOrEmpty(user.Id))
                user.Id = Guid.NewGuid().ToString();
            var created = await _repo.CreateAsync(user);
            return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
        }

        // PUT: api/users/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(string id, [FromBody] User user)
        {
            var updated = await _repo.UpdateAsync(id, user);
            if (updated == null) return NotFound();
            return Ok(updated);
        }

        // PATCH: api/users/{id}/active-child
        [HttpPatch("{id}/active-child")]
        public async Task<IActionResult> SetActiveChild(string id, [FromBody] SetActiveChildRequest request)
        {
            var user = await _repo.GetByIdAsync(id);
            if (user == null) return NotFound();
            user.ActiveChildId = request.ActiveChildId;
            var updated = await _repo.UpdateAsync(id, user);
            return Ok(updated);
        }

        // DELETE: api/users/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            var result = await _repo.DeleteAsync(id);
            if (!result) return NotFound();
            return NoContent();
        }
    }

    public record LoginRequest(string Email, string Password);
    public record SetActiveChildRequest(string ActiveChildId);
}
