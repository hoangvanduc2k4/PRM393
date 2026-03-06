using Microsoft.EntityFrameworkCore;
using MyFSchools.Api.Data;
using MyFSchools.Api.Models;

namespace MyFSchools.Api.Repositories
{
    public class EventRepository : IEventRepository
    {
        private readonly ApplicationDbContext _context;

        public EventRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Event>> GetAllAsync()
        {
            return await _context.Events.OrderBy(e => e.EventDate).ToListAsync();
        }

        public async Task<Event?> GetByIdAsync(string id)
        {
            return await _context.Events.FindAsync(id);
        }

        public async Task<IEnumerable<Event>> GetUpcomingEventsAsync()
        {
            return await _context.Events
                .Where(e => e.EventDate >= DateTime.UtcNow)
                .OrderBy(e => e.EventDate)
                .ToListAsync();
        }

        public async Task<IEnumerable<Event>> GetByDateRangeAsync(DateTime from, DateTime to)
        {
            return await _context.Events
                .Where(e => e.EventDate >= from && e.EventDate <= to)
                .OrderBy(e => e.EventDate)
                .ToListAsync();
        }

        public async Task<Event> CreateAsync(Event entity)
        {
            entity.Id = Guid.NewGuid().ToString();
            entity.CreatedAt = DateTime.UtcNow;
            _context.Events.Add(entity);
            await _context.SaveChangesAsync();
            return entity;
        }

        public async Task<Event?> UpdateAsync(string id, Event entity)
        {
            var existing = await _context.Events.FindAsync(id);
            if (existing == null) return null;

            existing.EventName = entity.EventName;
            existing.EventDate = entity.EventDate;
            existing.Time = entity.Time;
            existing.Location = entity.Location;
            existing.Color = entity.Color;

            await _context.SaveChangesAsync();
            return existing;
        }

        public async Task<bool> DeleteAsync(string id)
        {
            var ev = await _context.Events.FindAsync(id);
            if (ev == null) return false;

            _context.Events.Remove(ev);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
