using Microsoft.AspNetCore.Mvc;
using MyFSchools.Api.Repositories;
using MyFSchools.Api.Services;
using System.Collections.Concurrent;

namespace MyFSchools.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly IUserRepository _userRepo;
        private readonly JwtService _jwtService;
        private static readonly ConcurrentDictionary<string, string> _otpStore = new();

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

            if (user == null || !BCrypt.Net.BCrypt.Verify(request.Password, user.Password))
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

        // POST: api/auth/forgot-password
        [HttpPost("forgot-password")]
        public async Task<IActionResult> ForgotPassword([FromBody] AuthForgotPasswordRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Phone))
                return BadRequest(new { message = "Số điện thoại không được để trống" });

            var user = await _userRepo.GetByPhoneAsync(request.Phone);
            if (user == null)
                return NotFound(new { message = "Không tìm thấy người dùng với số điện thoại này" });

            // Generate a random 6-digit OTP
            var otp = new Random().Next(100000, 999999).ToString();
            _otpStore[request.Phone] = otp;

            // FAKE OTP OUTPUT TO CONSOLE
            Console.WriteLine("========================================");
            Console.WriteLine($"[FORGOT PASSWORD] Phone: {request.Phone}");
            Console.WriteLine($"[FORGOT PASSWORD] MOCK OTP: {otp}");
            Console.WriteLine("========================================");

            return Ok(new { message = "Mã OTP đã được gửi" });
        }

        // POST: api/auth/verify-otp
        [HttpPost("verify-otp")]
        public IActionResult VerifyOtp([FromBody] AuthVerifyOtpRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Phone) || string.IsNullOrWhiteSpace(request.Otp))
                return BadRequest(new { message = "Số điện thoại và mã OTP không được để trống" });

            if (_otpStore.TryGetValue(request.Phone, out var storedOtp) && storedOtp == request.Otp)
            {
                return Ok(new { message = "Mã OTP chính xác" });
            }

            return BadRequest(new { message = "Mã OTP không chính xác" });
        }

        // POST: api/auth/reset-password
        [HttpPost("reset-password")]
        public async Task<IActionResult> ResetPassword([FromBody] AuthResetPasswordRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Phone) || string.IsNullOrWhiteSpace(request.Otp) || string.IsNullOrWhiteSpace(request.NewPassword))
                return BadRequest(new { message = "Dữ liệu không hợp lệ" });

            if (_otpStore.TryGetValue(request.Phone, out var storedOtp) && storedOtp == request.Otp)
            {
                var user = await _userRepo.GetByPhoneAsync(request.Phone);
                if (user == null)
                    return NotFound(new { message = "Không tìm thấy người dùng" });

                user.Password = BCrypt.Net.BCrypt.HashPassword(request.NewPassword);
                await _userRepo.UpdateAsync(user.Id, user);

                _otpStore.TryRemove(request.Phone, out _);

                return Ok(new { message = "Đổi mật khẩu thành công" });
            }

            return BadRequest(new { message = "Mã OTP không chính xác hoặc đã hết hạn" });
        }
    }

    public record AuthLoginRequest(string Phone, string Password);
    public record AuthForgotPasswordRequest(string Phone);
    public record AuthVerifyOtpRequest(string Phone, string Otp);
    public record AuthResetPasswordRequest(string Phone, string Otp, string NewPassword);
}
