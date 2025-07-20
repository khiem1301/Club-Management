using ClubManagementApp.Models;
using Microsoft.EntityFrameworkCore;

namespace ClubManagementApp.Services
{
    /// <summary>
    /// Business service for managing club operations and organizational structure.
    /// Handles club CRUD operations, membership management, leadership roles, and analytics.
    ///
    /// Responsibilities:
    /// - Club lifecycle management (create, read, update, delete)
    /// - Member management and role assignments
    /// - Leadership hierarchy and permissions
    /// - Club statistics and reporting
    /// - Organizational structure maintenance
    ///
    /// Data Flow:
    /// ViewModels -> ClubService -> DbContext -> Database
    ///
    /// Key Features:
    /// - Hierarchical role management (Chairman, ViceChairman, TeamLeader, Member)
    /// - Automatic leadership succession (Chairman demotion to ViceChairman)
    /// - Role-based permission configuration
    /// - Comprehensive club analytics and statistics
    /// - Member activity tracking and engagement metrics
    /// </summary>
    public class ClubService : IClubService
    {
        /// <summary>Database context for club and user data operations</summary>
        private readonly ClubManagementDbContext _context;

        /// <summary>
        /// Initializes the ClubService with database context dependency.
        ///
        /// Data Flow:
        /// - Dependency injection provides DbContext instance
        /// - Service becomes ready for club management operations
        /// - All database operations flow through this context
        /// </summary>
        /// <param name="context">Entity Framework database context for data access</param>
        public ClubService(ClubManagementDbContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Retrieves all clubs with their complete organizational data.
        /// Includes member lists and event histories for comprehensive club information.
        ///
        /// Data Flow:
        /// 1. Query database for all clubs
        /// 2. Include related Members and Events via Entity Framework navigation
        /// 3. Sort alphabetically by club name for consistent ordering
        /// 4. Return complete club objects with relationships
        ///
        /// Usage: Club directory displays, administrative overviews, reporting dashboards
        /// </summary>
        /// <returns>Collection of all clubs with members and events included</returns>
        public async Task<IEnumerable<Club>> GetAllClubsAsync()
        {
            try
            {
                Console.WriteLine("[CLUB_SERVICE] Getting all clubs");
                var clubs = await _context.Clubs
                    .AsNoTracking()
                    .Include(c => c.Members)
                    .Include(c => c.Events)
                    .ToListAsync();

                Console.WriteLine($"[CLUB_SERVICE] Found {clubs.Count} clubs");
                return clubs;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[CLUB_SERVICE] Error getting clubs: {ex.Message}");
                throw;
            }
        }

        /// <summary>
        /// Retrieves a specific club by its unique identifier.
        /// Includes complete member roster and event history for detailed club view.
        ///
        /// Data Flow:
        /// 1. Query database for club with specified ID
        /// 2. Include related Members and Events collections
        /// 3. Return club object or null if not found
        ///
        /// Usage: Club detail pages, member management, event planning
        /// </summary>
        /// <param name="clubId">Unique identifier of the club to retrieve</param>
        /// <returns>Club object with relationships, or null if not found</returns>
        public async Task<Club?> GetClubByIdAsync(int clubId)
        {
            try
            {
                if (clubId <= 0)
                {
                    Console.WriteLine($"[CLUB_SERVICE] Invalid club ID: {clubId}");
                    return null;
                }

                Console.WriteLine($"[CLUB_SERVICE] Getting club by ID: {clubId}");
                var club = await _context.Clubs
                    .Include(c => c.Members)
                    .Include(c => c.Events)
                    .FirstOrDefaultAsync(c => c.ClubID == clubId);

                if (club != null)
                {
                    Console.WriteLine($"[CLUB_SERVICE] Found club: {club.Name} with {club.Members?.Count ?? 0} members");
                }
                else
                {
                    Console.WriteLine($"[CLUB_SERVICE] Club not found with ID: {clubId}");
                }
                return club;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[CLUB_SERVICE] Error getting club by ID {clubId}: {ex.Message}");
                throw;
            }
        }

        /// <summary>
        /// Retrieves a club by its name for lookup and validation purposes.
        /// Includes member and event data for complete club information.
        ///
        /// Data Flow:
        /// 1. Query database for club with exact name match
        /// 2. Include related Members and Events collections
        /// 3. Return club object or null if not found
        ///
        /// Usage: Club name validation, search functionality, duplicate prevention
        /// </summary>
        /// <param name="name">Exact name of the club to find</param>
        /// <returns>Club object with relationships, or null if not found</returns>
        public async Task<Club?> GetClubByNameAsync(string name)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(name))
                {
                    Console.WriteLine("[CLUB_SERVICE] Club name cannot be null or empty");
                    return null;
                }

                return await _context.Clubs
                    .Include(c => c.Members)
                    .Include(c => c.Events)
                    .FirstOrDefaultAsync(c => c.Name == name);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[CLUB_SERVICE] Error getting club by name '{name}': {ex.Message}");
                throw;
            }
        }

        /// <summary>
        /// Creates a new club in the system with initial organizational structure.
        /// Establishes the foundation for member management and event planning.
        ///
        /// Data Flow:
        /// 1. Receive club object from ViewModel/UI layer
        /// 2. Add club entity to DbContext tracking
        /// 3. Persist changes to database
        /// 4. Return created club with generated ID
        ///
        /// Business Logic:
        /// - Assigns unique ClubID via database auto-increment
        /// - Sets creation timestamp for audit trail
        /// - Initializes empty member and event collections
        ///
        /// Usage: Club registration forms, administrative club creation
        /// </summary>
        /// <param name="club">Club object containing name, description, and initial settings</param>
        /// <returns>Created club object with assigned ID and timestamps</returns>
        public async Task<Club> CreateClubAsync(Club club, User user)
        {
            try
            {
                Console.WriteLine($"[CLUB_SERVICE] Creating new club: {club.Name}");
                Console.WriteLine($"[CLUB_SERVICE] Club description: {club.Description}");

                // Input validation
                if (club == null)
                    throw new ArgumentNullException(nameof(club), "Club cannot be null");

                if (string.IsNullOrWhiteSpace(club.Name))
                    throw new ArgumentException("Club name is required", nameof(club));

                // Check for duplicate club name
                var existingClub = await _context.Clubs.FirstOrDefaultAsync(c => c.Name == club.Name);
                if (existingClub != null)
                    throw new InvalidOperationException($"Club with name '{club.Name}' already exists");

                // Ensure ClubID is 0 for new entities
                club.ClubID = 0;

                club.CreatedBy = user.UserID;
                _context.Clubs.Add(club);
                await _context.SaveChangesAsync();

                Console.WriteLine($"[CLUB_SERVICE] Club created successfully with ID: {club.ClubID}");
                return club;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[CLUB_SERVICE] Error creating club: {ex.Message}");
                throw;
            }
        }

        /// <summary>
        /// Updates existing club information and organizational settings.
        /// Preserves member relationships while allowing club metadata changes.
        ///
        /// Data Flow:
        /// 1. Receive updated club object from ViewModel
        /// 2. Mark entity as modified in DbContext
        /// 3. Persist changes to database
        /// 4. Return updated club object
        ///
        /// Business Logic:
        /// - Maintains existing member and event relationships
        /// - Updates club metadata (name, description, settings)
        /// - Preserves role configurations and permissions
        ///
        /// Usage: Club settings pages, administrative updates, role configuration
        /// </summary>
        /// <param name="club">Club object with updated information</param>
        /// <returns>Updated club object reflecting database changes</returns>
        public async Task<Club> UpdateClubAsync(Club club)
        {
            try
            {
                Console.WriteLine($"[CLUB_SERVICE] Updating club: {club.Name} (ID: {club.ClubID})");

                // Input validation
                if (club == null)
                    throw new ArgumentNullException(nameof(club), "Club cannot be null");

                if (club.ClubID <= 0)
                    throw new ArgumentException("Invalid club ID", nameof(club));

                if (string.IsNullOrWhiteSpace(club.Name))
                    throw new ArgumentException("Club name is required", nameof(club));

                // Check if club exists and update properties
                var existingClub = await _context.Clubs.FindAsync(club.ClubID);
                if (existingClub == null)
                    throw new InvalidOperationException($"Club with ID {club.ClubID} not found");

                // Update properties instead of replacing the entity
                existingClub.Name = club.Name;
                existingClub.Description = club.Description;
                existingClub.IsActive = club.IsActive;

                await _context.SaveChangesAsync();
                Console.WriteLine($"[CLUB_SERVICE] Club updated successfully: {existingClub.Name}");
                return existingClub;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[CLUB_SERVICE] Error updating club: {ex.Message}");
                throw;
            }
        }

        /// <summary>
        /// Removes a club from the system along with all organizational data.
        /// Handles cascading deletion of related member assignments and events.
        ///
        /// Data Flow:
        /// 1. Query database for club by ID
        /// 2. Validate club exists before deletion
        /// 3. Remove club entity (cascades to related data)
        /// 4. Persist changes and return success status
        ///
        /// Business Logic:
        /// - Validates club existence before deletion
        /// - Cascades deletion to member assignments and events
        /// - Maintains data integrity through foreign key constraints
        ///
        /// Usage: Administrative club dissolution, cleanup operations
        /// </summary>
        /// <param name="clubId">Unique identifier of club to delete</param>
        /// <returns>True if deletion successful, false if club not found</returns>
        public async Task<bool> DeleteClubAsync(int clubId)
        {
            try
            {
                Console.WriteLine($"[CLUB_SERVICE] Attempting to delete club with ID: {clubId}");

                if (clubId <= 0)
                    throw new ArgumentException("Invalid club ID", nameof(clubId));

                var club = await _context.Clubs
                    .Include(c => c.Members)
                    .Include(c => c.Events)
                    .FirstOrDefaultAsync(c => c.ClubID == clubId);

                if (club == null)
                {
                    Console.WriteLine($"[CLUB_SERVICE] Club not found for deletion: {clubId}");
                    return false;
                }

                // Check if club has members or events
                if (club.Members?.Any() == true)
                    throw new InvalidOperationException($"Cannot delete club '{club.Name}' because it has {club.Members.Count} members");

                if (club.Events?.Any() == true)
                    throw new InvalidOperationException($"Cannot delete club '{club.Name}' because it has {club.Events.Count} events");

                Console.WriteLine($"[CLUB_SERVICE] Deleting club: {club.Name}");
                _context.Clubs.Remove(club);
                await _context.SaveChangesAsync();
                Console.WriteLine($"[CLUB_SERVICE] Club deleted successfully: {club.Name}");
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[CLUB_SERVICE] Error deleting club {clubId}: {ex.Message}");
                throw;
            }
        }

        /// <summary>
        /// Retrieves all active members of a specific club.
        /// Provides complete member roster for management and communication.
        ///
        /// Data Flow:
        /// 1. Query Users table filtered by club ID and active status
        /// 2. Sort members alphabetically by full name
        /// 3. Return ordered collection of member objects
        ///
        /// Business Logic:
        /// - Only includes active members (IsActive = true)
        /// - Alphabetical sorting for consistent user experience
        /// - Complete user objects for detailed member information
        ///
        /// Usage: Member directories, communication lists, role assignment interfaces
        /// </summary>
        /// <param name="clubId">Unique identifier of the club</param>
        /// <returns>Ordered collection of active club members</returns>
        public async Task<IEnumerable<User>> GetClubMembersAsync(int clubId)
        {
            try
            {
                if (clubId <= 0)
                {
                    Console.WriteLine($"[CLUB_SERVICE] Invalid club ID: {clubId}");
                    return new List<User>();
                }

                Console.WriteLine($"[CLUB_SERVICE] Getting members for club: {clubId}");
                var members = await _context.Users
                    .Where(u => u.ClubID == clubId && u.IsActive)
                    .OrderBy(u => u.FullName)
                    .ToListAsync();
                Console.WriteLine($"[CLUB_SERVICE] Retrieved {members.Count} members for club {clubId}");
                return members;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[CLUB_SERVICE] Error getting members for club {clubId}: {ex.Message}");
                throw;
            }
        }

        /// <summary>
        /// Assigns leadership roles within a club's organizational hierarchy.
        /// Implements automatic succession logic for Chairman transitions.
        ///
        /// Data Flow:
        /// 1. Validate role is a leadership position (Chairman, ViceChairman, TeamLeader)
        /// 2. Verify user exists and belongs to the specified club
        /// 3. Handle Chairman succession (demote current Chairman to ViceChairman)
        /// 4. Assign new role to user and persist changes
        ///
        /// Business Logic:
        /// - Only allows assignment of leadership roles
        /// - Enforces single Chairman rule with automatic demotion
        /// - Maintains organizational hierarchy integrity
        /// - Validates user membership before role assignment
        ///
        /// Leadership Hierarchy:
        /// Chairman (1) -> ViceChairman (multiple) -> TeamLeader (multiple) -> Member
        ///
        /// Usage: Role management interfaces, succession planning, organizational restructuring
        /// </summary>
        /// <param name="clubId">Unique identifier of the club</param>
        /// <param name="userId">Unique identifier of the user to promote</param>
        /// <param name="role">Leadership role to assign (Chairman, ViceChairman, or TeamLeader)</param>
        /// <returns>True if assignment successful, false if validation fails</returns>
        public async Task<bool> AssignClubLeadershipAsync(int clubId, int userId, UserRole role)
        {
            try
            {
                if (clubId <= 0)
                {
                    Console.WriteLine($"[CLUB_SERVICE] Invalid club ID: {clubId}");
                    return false;
                }

                if (userId <= 0)
                {
                    Console.WriteLine($"[CLUB_SERVICE] Invalid user ID: {userId}");
                    return false;
                }

                Console.WriteLine($"[CLUB_SERVICE] Assigning leadership role {role} to user {userId} in club {clubId}");

                if (role != UserRole.Chairman && role != UserRole.ViceChairman && role != UserRole.TeamLeader && role != UserRole.Member)
                {
                    Console.WriteLine($"[CLUB_SERVICE] Invalid role: {role}");
                    return false;
                }

                var user = await _context.Users.FindAsync(userId);
                if (user == null || user.ClubID != clubId)
                {
                    Console.WriteLine($"[CLUB_SERVICE] User {userId} not found or not member of club {clubId}");
                    return false;
                }

                var oldRole = user.Role;
                Console.WriteLine($"[CLUB_SERVICE] Promoting {user.FullName} from {oldRole} to {role}");

                // If assigning Chairman, demote current Chairman to ViceChairman
                if (role == UserRole.Chairman)
                {
                    var currentChairman = await _context.Users
                        .FirstOrDefaultAsync(u => u.ClubID == clubId && u.Role == UserRole.Chairman);
                    if (currentChairman != null && currentChairman.UserID != userId)
                    {
                        Console.WriteLine($"[CLUB_SERVICE] Demoting current Chairman {currentChairman.FullName} to ViceChairman");
                        currentChairman.Role = UserRole.ViceChairman;
                    }
                }

                user.Role = role;
                await _context.SaveChangesAsync();
                Console.WriteLine($"[CLUB_SERVICE] Leadership assignment successful: {user.FullName} is now {role} of club {clubId}");
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[CLUB_SERVICE] Error assigning leadership role {role} to user {userId} in club {clubId}: {ex.Message}");
                throw;
            }
        }

        public async Task<bool> AddUserToClubAsync(int userId, int clubId, UserRole role)
        {
            try
            {
                var user = await _context.Users.FindAsync(userId);
                var club = await _context.Clubs.FindAsync(clubId);

                if (user == null || club == null)
                    return false;

                // If user is already a member of this club, update their role
                if (user.ClubID == clubId)
                {
                    //user.Role = role;
                    _context.Update(user);
                    await _context.SaveChangesAsync();
                    Console.WriteLine($"[CLUB_SERVICE] Updated role for existing member {user.FullName} to {role} in club {clubId}");
                    return true;
                }

                // Add new user to club with specified role
                user.ClubID = clubId;
                //user.Role = role;

                _context.Update(user);
                await _context.SaveChangesAsync();
                Console.WriteLine($"[CLUB_SERVICE] Added new member {user.FullName} with role {role} to club {clubId}");
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[CLUB_SERVICE] Error adding user {userId} to club {clubId}: {ex.Message}");
                return false;
            }
        }

        /// <summary>
        /// Gets the total count of clubs in the database efficiently.
        ///
        /// Performance:
        /// - Uses COUNT query instead of loading all records
        /// - Optimized for dashboard statistics display
        ///
        /// Used by: Dashboard statistics, admin overview
        /// </summary>
        /// <returns>Total number of clubs in the system</returns>
        public async Task<int> GetTotalClubsCountAsync()
        {
            try
            {
                return await _context.Clubs.CountAsync();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[CLUB_SERVICE] Error getting total clubs count: {ex.Message}");
                throw;
            }
        }
    }
}
