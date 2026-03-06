using Microsoft.EntityFrameworkCore;
using MyFSchools.Api.Data;
using MyFSchools.Api.Models;

namespace MyFSchools.Api.Repositories
{
    public class UserRepository : IUserRepository
    {
        private readonly ApplicationDbContext _context;

        public UserRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<User>> GetAllAsync()
        {
            return await _context.Users.ToListAsync();
        }

        public async Task<User?> GetByIdAsync(string id)
        {
            return await _context.Users.FindAsync(id);
        }

        public async Task<User?> GetByEmailAsync(string email)
        {
            return await _context.Users.FirstOrDefaultAsync(u => u.Email == email);
        }

        public async Task<User?> GetByPhoneAsync(string phone)
        {
            return await _context.Users.FirstOrDefaultAsync(u => u.Phone == phone);
        }

        public async Task<User?> GetWithChildrenAsync(string userId)
        {
            return await _context.Users
                .Include(u => u.Children)
                .Include(u => u.ActiveChild)
                .FirstOrDefaultAsync(u => u.Id == userId);
        }

        public async Task<User> CreateAsync(User entity)
        {
            _context.Users.Add(entity);
            await _context.SaveChangesAsync();
            return entity;
        }

        public async Task<User?> UpdateAsync(string id, User entity)
        {
            var existing = await _context.Users.FindAsync(id);
            if (existing == null) return null;

            existing.Email = entity.Email;
            existing.Password = entity.Password;
            existing.Phone = entity.Phone;
            existing.ActiveChildId = entity.ActiveChildId;

            await _context.SaveChangesAsync();
            return existing;
        }

        public async Task<bool> DeleteAsync(string id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null) return false;

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
