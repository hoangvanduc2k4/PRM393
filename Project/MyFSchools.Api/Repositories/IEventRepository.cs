using MyFSchools.Api.Models;

namespace MyFSchools.Api.Repositories
{
    public interface IEventRepository : IRepository<Event>
    {
        Task<IEnumerable<Event>> GetUpcomingEventsAsync();
        Task<IEnumerable<Event>> GetByDateRangeAsync(DateTime from, DateTime to);
    }
}
