using MyFSchools.Api.Models;

namespace MyFSchools.Api.Repositories
{
    public interface IChildRepository : IRepository<Child>
    {
        Task<IEnumerable<Child>> GetByUserIdAsync(string userId);
        Task<IEnumerable<Child>> GetWithClubsAsync(string childId);
    }
}
