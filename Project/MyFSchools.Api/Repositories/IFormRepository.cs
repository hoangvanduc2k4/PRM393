using MyFSchools.Api.Models;

namespace MyFSchools.Api.Repositories
{
    public interface IFormRepository : IRepository<Form>
    {
        Task<IEnumerable<Form>> GetByUserIdAsync(string userId);
        Task<IEnumerable<Form>> GetByChildIdAsync(string childId);
        Task<Form?> UpdateStatusAsync(string formId, string status);
    }
}
