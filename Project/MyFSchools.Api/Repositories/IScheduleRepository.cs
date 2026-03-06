using MyFSchools.Api.Models;

namespace MyFSchools.Api.Repositories
{
    public interface IScheduleRepository : IRepository<Schedule>
    {
        Task<IEnumerable<Schedule>> GetByClassNameAsync(string className);
        Task<IEnumerable<Schedule>> GetByClassNameAndDayAsync(string className, string dayOfWeek);
        Task<IEnumerable<Schedule>> GetByTermAsync(string term);
    }
}
