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



        // GET: api/schedules/by-class/{className}
        [HttpGet("by-class/{className}")]
        public async Task<IActionResult> GetByClass(string className)
        {
            return Ok(await _repo.GetByClassNameAsync(className));
        }

        // GET: api/schedules/teacher/{teacherEmail}
        [HttpGet("teacher/{teacher}")]
        public async Task<IActionResult> GetByTeacher(string teacher)
        {
            return Ok(await _repo.GetByTeacherAsync(teacher));
        }


    }
}
