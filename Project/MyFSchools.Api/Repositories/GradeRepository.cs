using Microsoft.EntityFrameworkCore;
using MyFSchools.Api.Data;
using MyFSchools.Api.Models;

namespace MyFSchools.Api.Repositories
{
    public class GradeRepository : IGradeRepository
    {
        private readonly ApplicationDbContext _context;

        public GradeRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Grade>> GetAllAsync()
        {
            return await _context.Grades.ToListAsync();
        }

        public async Task<Grade?> GetByIdAsync(string id)
        {
            return await _context.Grades.FindAsync(id);
        }

        public async Task<IEnumerable<Grade>> GetByChildIdAsync(string childId)
        {
            return await _context.Grades
                .Where(g => g.ChildId == childId)
                .ToListAsync();
        }

        public async Task<IEnumerable<Grade>> GetByChildIdAndTermAsync(string childId, string term)
        {
            return await _context.Grades
                .Where(g => g.ChildId == childId && g.Term != null && g.Term.Contains(term))
                .ToListAsync();
        }

        public async Task<Grade> CreateAsync(Grade entity)
        {
            entity.Id = Guid.NewGuid().ToString();
            _context.Grades.Add(entity);
            await _context.SaveChangesAsync();
            return entity;
        }

        public async Task<Grade?> UpdateAsync(string id, Grade entity)
        {
            var existing = await _context.Grades.FindAsync(id);
            if (existing == null) return null;

            existing.Subject = entity.Subject;
            existing.Term = entity.Term;
            existing.Average = entity.Average;
            existing.Status = entity.Status;

            await _context.SaveChangesAsync();
            return existing;
        }

        public async Task<bool> DeleteAsync(string id)
        {
            var grade = await _context.Grades.FindAsync(id);
            if (grade == null) return false;

            _context.Grades.Remove(grade);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
