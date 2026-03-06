using Microsoft.EntityFrameworkCore;
using MyFSchools.Api.Data;
using MyFSchools.Api.Models;

namespace MyFSchools.Api.Repositories
{
    public class ScheduleRepository : IScheduleRepository
    {
        private readonly ApplicationDbContext _context;

        public ScheduleRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Schedule>> GetAllAsync()
        {
            return await _context.Schedules.ToListAsync();
        }

        public async Task<Schedule?> GetByIdAsync(string id)
        {
            return await _context.Schedules.FindAsync(id);
        }

        public async Task<IEnumerable<Schedule>> GetByClassNameAsync(string className)
        {
            return await _context.Schedules
                .Where(s => s.ClassName == className)
                .OrderBy(s => s.DayOfWeek)
                .ThenBy(s => s.Slot)
                .ToListAsync();
        }

        public async Task<IEnumerable<Schedule>> GetByClassNameAndDayAsync(string className, string dayOfWeek)
        {
            return await _context.Schedules
                .Where(s => s.ClassName == className && s.DayOfWeek == dayOfWeek)
                .OrderBy(s => s.Slot)
                .ToListAsync();
        }

        public async Task<IEnumerable<Schedule>> GetByTermAsync(string term)
        {
            return await _context.Schedules
                .Where(s => s.Term == term)
                .ToListAsync();
        }

        public async Task<Schedule> CreateAsync(Schedule entity)
        {
            entity.Id = Guid.NewGuid().ToString();
            _context.Schedules.Add(entity);
            await _context.SaveChangesAsync();
            return entity;
        }

        public async Task<Schedule?> UpdateAsync(string id, Schedule entity)
        {
            var existing = await _context.Schedules.FindAsync(id);
            if (existing == null) return null;

            existing.ClassName = entity.ClassName;
            existing.DayOfWeek = entity.DayOfWeek;
            existing.Slot = entity.Slot;
            existing.Subject = entity.Subject;
            existing.Teacher = entity.Teacher;
            existing.Room = entity.Room;
            existing.Term = entity.Term;

            await _context.SaveChangesAsync();
            return existing;
        }

        public async Task<bool> DeleteAsync(string id)
        {
            var schedule = await _context.Schedules.FindAsync(id);
            if (schedule == null) return false;

            _context.Schedules.Remove(schedule);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
