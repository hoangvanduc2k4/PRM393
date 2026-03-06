using MyFSchools.Api.Models;

namespace MyFSchools.Api.Repositories
{
    public interface IGradeRepository : IRepository<Grade>
    {
        Task<IEnumerable<Grade>> GetByChildIdAsync(string childId);
        Task<IEnumerable<Grade>> GetByChildIdAndTermAsync(string childId, string term);
    }
}
