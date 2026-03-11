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



        // GET: api/users/{id}/with-children
        [HttpGet("{id}/with-children")]
        public async Task<IActionResult> GetWithChildren(string id)
        {
            var user = await _repo.GetWithChildrenAsync(id);
            if (user == null) return NotFound();
            
            var result = new
            {
                user.Id,
                user.Email,
                user.Phone,
                user.ActiveChildId,
                Roles = user.UserRoles?.Select(ur => ur.Role?.Name).Where(n => !string.IsNullOrEmpty(n)).ToList() ?? new List<string>(),
                Children = user.Children?.Select(c => new
                {
                    c.Id,
                    c.FullName,
                    c.ClassName,
                    c.AvatarUrl
                }).Cast<object>().ToList() ?? new List<object>()
            };

            return Ok(result);
        }


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
