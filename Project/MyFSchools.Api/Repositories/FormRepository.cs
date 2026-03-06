using Microsoft.EntityFrameworkCore;
using MyFSchools.Api.Data;
using MyFSchools.Api.Models;

namespace MyFSchools.Api.Repositories
{
    public class FormRepository : IFormRepository
    {
        private readonly ApplicationDbContext _context;

        public FormRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Form>> GetAllAsync()
        {
            return await _context.Forms
                .Include(f => f.Child)
                .OrderByDescending(f => f.CreatedAt)
                .ToListAsync();
        }

        public async Task<Form?> GetByIdAsync(string id)
        {
            return await _context.Forms
                .Include(f => f.Child)
                .FirstOrDefaultAsync(f => f.Id == id);
        }

        public async Task<IEnumerable<Form>> GetByUserIdAsync(string userId)
        {
            return await _context.Forms
                .Include(f => f.Child)
                .Where(f => f.UserId == userId)
                .OrderByDescending(f => f.CreatedAt)
                .ToListAsync();
        }

        public async Task<IEnumerable<Form>> GetByChildIdAsync(string childId)
        {
            return await _context.Forms
                .Where(f => f.ChildId == childId)
                .OrderByDescending(f => f.CreatedAt)
                .ToListAsync();
        }

        public async Task<Form?> UpdateStatusAsync(string formId, string status)
        {
            var form = await _context.Forms.FindAsync(formId);
            if (form == null) return null;

            form.Status = status;
            await _context.SaveChangesAsync();
            return form;
        }

        public async Task<Form> CreateAsync(Form entity)
        {
            entity.Id = Guid.NewGuid().ToString();
            entity.CreatedAt = DateTime.UtcNow;
            entity.Status ??= "Chờ duyệt";
            _context.Forms.Add(entity);
            await _context.SaveChangesAsync();
            return entity;
        }

        public async Task<Form?> UpdateAsync(string id, Form entity)
        {
            var existing = await _context.Forms.FindAsync(id);
            if (existing == null) return null;

            existing.Title = entity.Title;
            existing.Type = entity.Type;
            existing.Date = entity.Date;
            existing.Reason = entity.Reason;
            existing.Status = entity.Status;

            await _context.SaveChangesAsync();
            return existing;
        }

        public async Task<bool> DeleteAsync(string id)
        {
            var form = await _context.Forms.FindAsync(id);
            if (form == null) return false;

            _context.Forms.Remove(form);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
