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



        // GET: api/children/{id}
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(string id)
        {
            var child = await _repo.GetByIdAsync(id);
            if (child == null) return NotFound();
            return Ok(child);
        }


        [HttpGet("{id}/clubs")]
        public async Task<IActionResult> GetWithClubs(string id)
        {
            var children = await _repo.GetWithClubsAsync(id);
            return Ok(children);
        }


    }
}
