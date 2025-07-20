using ClubManagementApp.Models;

namespace ClubManagementApp.Services
{
    public interface IClubService
    {
        Task<IEnumerable<Club>> GetAllClubsAsync();
        Task<Club?> GetClubByIdAsync(int clubId);
        Task<Club> CreateClubAsync(Club club, User user);
        Task<Club> UpdateClubAsync(Club club);
        Task<bool> DeleteClubAsync(int clubId);
        Task<IEnumerable<User>> GetClubMembersAsync(int clubId);
        Task<bool> AssignClubLeadershipAsync(int clubId, int userId, UserRole role);
        Task<bool> AddUserToClubAsync(int userId, int clubId, UserRole role);
        Task<int> GetTotalClubsCountAsync();
    }
}
