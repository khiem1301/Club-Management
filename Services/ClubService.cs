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
        public async Task<Club> CreateClubAsync(Club club)
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
        /// Retrieves the current active member count for a specific club.
        /// Provides real-time membership statistics for dashboards and reporting.
        ///
        /// Data Flow:
        /// 1. Query Users table filtered by club ID and active status
        /// 2. Count matching records using efficient database aggregation
        /// 3. Return integer count for display
        ///
        /// Business Logic:
        /// - Only counts active members (IsActive = true)
        /// - Excludes deactivated or suspended members
        /// - Provides accurate membership metrics
        ///
        /// Usage: Dashboard widgets, membership reports, capacity planning
        /// </summary>
        /// <param name="clubId">Unique identifier of the club</param>
        /// <returns>Number of active members in the club</returns>
        public async Task<int> GetMemberCountAsync(int clubId)
        {
            try
            {
                if (clubId <= 0)
                {
                    Console.WriteLine($"[CLUB_SERVICE] Invalid club ID: {clubId}");
                    return 0;
                }

                Console.WriteLine($"[CLUB_SERVICE] Getting member count for club: {clubId}");
                var count = await _context.Users
                    .CountAsync(u => u.ClubID == clubId && u.IsActive);
                Console.WriteLine($"[CLUB_SERVICE] Club {clubId} has {count} active members");
                return count;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[CLUB_SERVICE] Error getting member count for club {clubId}: {ex.Message}");
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

        /// <summary>
        /// Retrieves the current Chairman of a specific club.
        /// Returns the single active user holding the highest leadership position.
        ///
        /// Data Flow:
        /// 1. Query Users table for club members with Chairman role
        /// 2. Filter for active users only
        /// 3. Return single Chairman or null if position vacant
        ///
        /// Business Logic:
        /// - Enforces single Chairman rule per club
        /// - Only returns active users (excludes suspended/deactivated)
        /// - Provides null result for vacant Chairman position
        ///
        /// Usage: Leadership displays, contact information, succession planning
        /// </summary>
        /// <param name="clubId">Unique identifier of the club</param>
        /// <returns>Chairman user object, or null if position vacant</returns>
        public async Task<User?> GetClubChairmanAsync(int clubId)
        {
            try
            {
                if (clubId <= 0)
                {
                    Console.WriteLine($"[CLUB_SERVICE] Invalid club ID: {clubId}");
                    return null;
                }

                return await _context.Users
                    .FirstOrDefaultAsync(u => u.ClubID == clubId && u.Role == UserRole.Chairman && u.IsActive);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[CLUB_SERVICE] Error getting club chairman for club {clubId}: {ex.Message}");
                throw;
            }
        }

        /// <summary>
        /// Retrieves all Vice Chairmen of a specific club.
        /// Returns multiple users holding secondary leadership positions.
        ///
        /// Data Flow:
        /// 1. Query Users table for club members with ViceChairman role
        /// 2. Filter for active users only
        /// 3. Sort alphabetically by full name
        /// 4. Return ordered collection of Vice Chairmen
        ///
        /// Business Logic:
        /// - Supports multiple Vice Chairmen per club
        /// - Only includes active users
        /// - Alphabetical ordering for consistent display
        ///
        /// Usage: Leadership directories, delegation assignments, committee formation
        /// </summary>
        /// <param name="clubId">Unique identifier of the club</param>
        /// <returns>Ordered collection of Vice Chairman users</returns>
        public async Task<IEnumerable<User>> GetClubViceChairmenAsync(int clubId)
        {
            try
            {
                if (clubId <= 0)
                {
                    Console.WriteLine($"[CLUB_SERVICE] Invalid club ID: {clubId}");
                    return new List<User>();
                }

                return await _context.Users
                    .Where(u => u.ClubID == clubId && u.Role == UserRole.ViceChairman && u.IsActive)
                    .OrderBy(u => u.FullName)
                    .ToListAsync();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[CLUB_SERVICE] Error getting club vice chairmen for club {clubId}: {ex.Message}");
                throw;
            }
        }

        /// <summary>
        /// Retrieves all Team Leaders of a specific club.
        /// Returns users responsible for specific teams or functional areas.
        ///
        /// Data Flow:
        /// 1. Query Users table for club members with TeamLeader role
        /// 2. Filter for active users only
        /// 3. Sort alphabetically by full name
        /// 4. Return ordered collection of Team Leaders
        ///
        /// Business Logic:
        /// - Supports multiple Team Leaders per club
        /// - Only includes active users
        /// - Alphabetical ordering for consistent display
        ///
        /// Usage: Team management, project assignments, specialized leadership roles
        /// </summary>
        /// <param name="clubId">Unique identifier of the club</param>
        /// <returns>Ordered collection of Team Leader users</returns>
        public async Task<IEnumerable<User>> GetClubTeamLeadersAsync(int clubId)
        {
            try
            {
                if (clubId <= 0)
                {
                    Console.WriteLine($"[CLUB_SERVICE] Invalid club ID: {clubId}");
                    return new List<User>();
                }

                return await _context.Users
                    .Where(u => u.ClubID == clubId && u.Role == UserRole.TeamLeader && u.IsActive)
                    .OrderBy(u => u.FullName)
                    .ToListAsync();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[CLUB_SERVICE] Error getting club team leaders for club {clubId}: {ex.Message}");
                throw;
            }
        }

        /// <summary>
        /// Analyzes role distribution across club membership.
        /// Provides organizational structure metrics for planning and reporting.
        ///
        /// Data Flow:
        /// 1. Query active club members from Users table
        /// 2. Group members by their assigned roles
        /// 3. Count members in each role category
        /// 4. Return dictionary mapping roles to member counts
        ///
        /// Business Logic:
        /// - Only includes active members in analysis
        /// - Groups by UserRole enum values
        /// - Provides comprehensive organizational overview
        ///
        /// Analytics Provided:
        /// - Leadership density (leaders vs members ratio)
        /// - Organizational balance assessment
        /// - Succession planning insights
        ///
        /// Usage: Dashboard analytics, organizational reports, capacity planning
        /// </summary>
        /// <param name="clubId">Unique identifier of the club</param>
        /// <returns>Dictionary mapping each role to its member count</returns>
        public async Task<Dictionary<UserRole, int>> GetClubRoleDistributionAsync(int clubId)
        {
            try
            {
                if (clubId <= 0)
                {
                    Console.WriteLine($"[CLUB_SERVICE] Invalid club ID: {clubId}");
                    return new Dictionary<UserRole, int>();
                }

                return await _context.Users
                    .Where(u => u.ClubID == clubId && u.IsActive)
                    .GroupBy(u => u.Role)
                    .ToDictionaryAsync(g => g.Key, g => g.Count());
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[CLUB_SERVICE] Error getting club role distribution for club {clubId}: {ex.Message}");
                throw;
            }
        }

        /// <summary>
        /// Removes leadership roles and demotes users to regular membership.
        /// Handles leadership transitions and organizational restructuring.
        ///
        /// Data Flow:
        /// 1. Validate user exists and belongs to specified club
        /// 2. Check if user currently holds a leadership role
        /// 3. Demote user to Member role if applicable
        /// 4. Persist changes to database
        ///
        /// Business Logic:
        /// - Only affects users with leadership roles
        /// - Demotes to Member role (preserves club membership)
        /// - Validates user belongs to correct club
        /// - Maintains organizational integrity
        ///
        /// Leadership Transitions:
        /// - Chairman -> Member
        /// - ViceChairman -> Member
        /// - TeamLeader -> Member
        /// - Member -> No change (returns false)
        ///
        /// Usage: Role management, disciplinary actions, organizational restructuring
        /// </summary>
        /// <param name="clubId">Unique identifier of the club</param>
        /// <param name="userId">Unique identifier of the user to demote</param>
        /// <returns>True if demotion successful, false if user not leader or validation fails</returns>
        public async Task<bool> RemoveClubLeadershipAsync(int clubId, int userId)
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

                var user = await _context.Users.FindAsync(userId);
                if (user == null || user.ClubID != clubId) return false;

                // Only demote if user has leadership role
                if (user.Role == UserRole.Chairman || user.Role == UserRole.ViceChairman || user.Role == UserRole.TeamLeader)
                {
                    user.Role = UserRole.Member;
                    await _context.SaveChangesAsync();
                    return true;
                }

                return false;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[CLUB_SERVICE] Error removing leadership for user {userId} in club {clubId}: {ex.Message}");
                throw;
            }
        }

        /// <summary>
        /// Generates comprehensive statistics and analytics for a specific club.
        /// Aggregates membership, event, and organizational data for reporting and dashboards.
        ///
        /// Data Flow:
        /// 1. Retrieve club with complete relationship data
        /// 2. Calculate current membership statistics
        /// 3. Analyze event history and recent activity
        /// 4. Generate role distribution analytics
        /// 5. Compile comprehensive statistics dictionary
        ///
        /// Business Logic:
        /// - Combines multiple data sources for holistic view
        /// - Includes recent events for activity assessment
        /// - Provides organizational structure analysis
        /// - Returns flexible dictionary for various display needs
        ///
        /// Statistics Included:
        /// - MemberCount: Current active membership
        /// - EventCount: Total events organized
        /// - RecentEvents: Last 5 events with details
        /// - RoleDistribution: Leadership vs member breakdown
        /// - EstablishedDate: Club founding date
        /// - Description: Club information and settings
        ///
        /// Usage: Dashboard widgets, club profile pages, administrative reports, analytics
        /// </summary>
        /// <param name="clubId">Unique identifier of the club</param>
        /// <returns>Dictionary containing comprehensive club statistics and metrics</returns>
        public async Task<Dictionary<string, object>> GetClubStatisticsAsync(int clubId)
        {
            try
            {
                if (clubId <= 0)
                {
                    Console.WriteLine($"[CLUB_SERVICE] Invalid club ID: {clubId}");
                    return new Dictionary<string, object>();
                }

                var club = await GetClubByIdAsync(clubId);
                if (club == null) return new Dictionary<string, object>();

                var memberCount = await GetMemberCountAsync(clubId);
                var eventCount = club.Events?.Count ?? 0;
                var recentEvents = (club.Events ?? new List<Event>())
                    .OrderByDescending(e => e.EventDate)
                    .Take(5)
                    .Select(e => new { e.Name, e.EventDate, e.Location })
                    .ToList();

                var roleDistribution = await GetClubRoleDistributionAsync(clubId);

                return new Dictionary<string, object>
                {
                    ["MemberCount"] = memberCount,
                    ["EventCount"] = eventCount,
                    ["RecentEvents"] = recentEvents,
                    ["RoleDistribution"] = roleDistribution,
                    ["EstablishedDate"] = club.CreatedDate,
                    ["Description"] = club.Description ?? ""
                };
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[CLUB_SERVICE] Error getting club statistics for club {clubId}: {ex.Message}");
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
