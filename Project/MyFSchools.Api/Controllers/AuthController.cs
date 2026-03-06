using Microsoft.AspNetCore.Mvc;
using MyFSchools.Api.Repositories;
using MyFSchools.Api.Services;

namespace MyFSchools.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly IUserRepository _userRepo;
        private readonly JwtService _jwtService;

        public AuthController(IUserRepository userRepo, JwtService jwtService)
        {
            _userRepo = userRepo;
            _jwtService = jwtService;
        }

        // POST: api/auth/login
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] AuthLoginRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Phone) || string.IsNullOrWhiteSpace(request.Password))
                return BadRequest(new { message = "Số điện thoại và mật khẩu không được để trống" });

            var user = await _userRepo.GetByPhoneAsync(request.Phone);

            if (user == null || user.Password != request.Password)
                return Unauthorized(new { message = "Số điện thoại hoặc mật khẩu không đúng" });

            var token = _jwtService.GenerateToken(user);

            return Ok(new
            {
                token,
                user = new
                {
                    user.Id,
                    user.Email,
                    user.Phone,
                    user.ActiveChildId
                }
            });
        }
    }

    public record AuthLoginRequest(string Phone, string Password);
}
