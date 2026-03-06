using MyFSchools.Api.Models;

namespace MyFSchools.Api.Repositories
{
    public interface IClubRepository : IRepository<Club>
    {
        Task<IEnumerable<Club>> GetByChildIdAsync(string childId);
        Task<bool> JoinClubAsync(string childId, string clubId);
        Task<bool> LeaveClubAsync(string childId, string clubId);
    }
}
