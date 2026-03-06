using MyFSchools.Api.Models;

namespace MyFSchools.Api.Repositories
{
    public interface IUserRepository : IRepository<User>
    {
        Task<User?> GetByEmailAsync(string email);
        Task<User?> GetByPhoneAsync(string phone);
        Task<User?> GetWithChildrenAsync(string userId);
    }
}
