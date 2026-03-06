using Microsoft.EntityFrameworkCore;
using MyFSchools.Api.Data;
using MyFSchools.Api.Models;

namespace MyFSchools.Api.Repositories
{
    public class ClubRepository : IClubRepository
    {
        private readonly ApplicationDbContext _context;

        public ClubRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Club>> GetAllAsync()
        {
            return await _context.Clubs.ToListAsync();
        }

        public async Task<Club?> GetByIdAsync(string id)
        {
            return await _context.Clubs.FindAsync(id);
        }

        public async Task<IEnumerable<Club>> GetByChildIdAsync(string childId)
        {
            return await _context.ChildClubs
                .Where(cc => cc.ChildId == childId)
                .Include(cc => cc.Club)
                .Select(cc => cc.Club!)
                .ToListAsync();
        }

        public async Task<bool> JoinClubAsync(string childId, string clubId)
        {
            var alreadyJoined = await _context.ChildClubs
                .AnyAsync(cc => cc.ChildId == childId && cc.ClubId == clubId);

            if (alreadyJoined) return false;

            _context.ChildClubs.Add(new ChildClub { ChildId = childId, ClubId = clubId });

            var club = await _context.Clubs.FindAsync(clubId);
            if (club != null) club.MemberCount++;

            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> LeaveClubAsync(string childId, string clubId)
        {
            var membership = await _context.ChildClubs
                .FirstOrDefaultAsync(cc => cc.ChildId == childId && cc.ClubId == clubId);

            if (membership == null) return false;

            _context.ChildClubs.Remove(membership);

            var club = await _context.Clubs.FindAsync(clubId);
            if (club != null && club.MemberCount > 0) club.MemberCount--;

            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<Club> CreateAsync(Club entity)
        {
            _context.Clubs.Add(entity);
            await _context.SaveChangesAsync();
            return entity;
        }

        public async Task<Club?> UpdateAsync(string id, Club entity)
        {
            var existing = await _context.Clubs.FindAsync(id);
            if (existing == null) return null;

            existing.Name = entity.Name;
            existing.Category = entity.Category;

            await _context.SaveChangesAsync();
            return existing;
        }

        public async Task<bool> DeleteAsync(string id)
        {
            var club = await _context.Clubs.FindAsync(id);
            if (club == null) return false;

            _context.Clubs.Remove(club);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
