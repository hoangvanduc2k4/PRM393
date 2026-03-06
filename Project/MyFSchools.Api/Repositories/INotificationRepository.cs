using MyFSchools.Api.Models;

namespace MyFSchools.Api.Repositories
{
    public interface INotificationRepository : IRepository<Notification>
    {
        Task<IEnumerable<Notification>> GetByUserIdAsync(string userId);
        Task<bool> MarkAsReadAsync(string notificationId);
        Task<int> GetUnreadCountAsync(string userId);
    }
}
