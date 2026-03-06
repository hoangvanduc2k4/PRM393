using Microsoft.EntityFrameworkCore;
using MyFSchools.Api.Data;
using MyFSchools.Api.Models;

namespace MyFSchools.Api.Repositories
{
    public class ChildRepository : IChildRepository
    {
        private readonly ApplicationDbContext _context;

        public ChildRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Child>> GetAllAsync()
        {
            return await _context.Children.ToListAsync();
        }

        public async Task<Child?> GetByIdAsync(string id)
        {
            return await _context.Children.FindAsync(id);
        }

        public async Task<IEnumerable<Child>> GetByUserIdAsync(string userId)
        {
            return await _context.Children
                .Where(c => c.UserId == userId)
                .ToListAsync();
        }

        public async Task<IEnumerable<Child>> GetWithClubsAsync(string childId)
        {
            return await _context.Children
                .Include(c => c.ChildClubs)
                    .ThenInclude(cc => cc.Club)
                .Where(c => c.Id == childId)
                .ToListAsync();
        }

        public async Task<Child> CreateAsync(Child entity)
        {
            _context.Children.Add(entity);
            await _context.SaveChangesAsync();
            return entity;
        }

        public async Task<Child?> UpdateAsync(string id, Child entity)
        {
            var existing = await _context.Children.FindAsync(id);
            if (existing == null) return null;

            existing.FullName = entity.FullName;
            existing.ClassName = entity.ClassName;
            existing.AvatarUrl = entity.AvatarUrl;

            await _context.SaveChangesAsync();
            return existing;
        }

        public async Task<bool> DeleteAsync(string id)
        {
            var child = await _context.Children.FindAsync(id);
            if (child == null) return false;

            _context.Children.Remove(child);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
