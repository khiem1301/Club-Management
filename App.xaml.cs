using ClubManagementApp.Models;
using ClubManagementApp.Services;
using ClubManagementApp.ViewModels;
using ClubManagementApp.Views;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System.IO;
using System.Runtime.InteropServices;
using System.Windows;

namespace ClubManagementApp
{
    /// <summary>
    /// Main application class that handles application startup, dependency injection configuration,
    /// and the overall application lifecycle. This class follows the WPF Application pattern
    /// and implements dependency injection using Microsoft.Extensions.DependencyInjection.
    /// 
    /// Data Flow:
    /// 1. Application starts -> OnStartup() is called
    /// 2. Dependency injection container is configured
    /// 3. Configuration service loads application settings
    /// 4. Database is initialized and migrated if needed
    /// 5. Login window is displayed to authenticate user
    /// 6. Upon successful login, main application window is shown
    /// </summary>
    public partial class App : Application
    {
        

        /// <summary>
        /// Service provider for dependency injection container.
        /// This manages the lifetime of all registered services and provides
        /// service resolution throughout the application.
        /// </summary>
        private ServiceProvider? _serviceProvider;

        /// <summary>
        /// Application startup method that initializes the entire application infrastructure.
        /// This method is called when the WPF application starts and handles:
        /// - Dependency injection container setup
        /// - Configuration loading from appsettings.json
        /// - Database initialization and migration
        /// - Initial UI setup (login window)
        /// 
        /// Data Flow:
        /// 1. Configure all services in DI container
        /// 2. Load application configuration (database connections, email settings, etc.)
        /// 3. Initialize database schema and seed data if needed
        /// 4. Create and display login window for user authentication
        /// 5. Set up event handlers for successful login transition
        /// </summary>
        /// <param name="e">Startup event arguments containing command line parameters</param>
        protected override async void OnStartup(StartupEventArgs e)
        {
            // Allocate console for debugging
            
            Console.WriteLine("=== APPLICATION STARTING ===");

            try
            {
                Console.WriteLine("Calling base.OnStartup...");
                base.OnStartup(e);
                Console.WriteLine("Base startup completed.");

                // STEP 1: Configure dependency injection container
                // This sets up all services, repositories, and ViewModels for the application
                Console.WriteLine("Configuring services...");
                var services = new ServiceCollection();
                ConfigureServices(services);
                _serviceProvider = services.BuildServiceProvider();
                Console.WriteLine("Services configured successfully.");

                // STEP 2: Initialize database
                // Ensures database exists, applies migrations, and seeds initial data
                // This includes creating default admin user and sample clubs/events
                Console.WriteLine("Initializing database...");
                using (var scope = _serviceProvider.CreateScope())
                {
                    var context = scope.ServiceProvider.GetRequiredService<ClubManagementDbContext>();

                }
                Console.WriteLine("Database initialized successfully.");

                // STEP 3: Create and display login window
                // The login window is the entry point for user authentication
                Application.Current.ShutdownMode = ShutdownMode.OnExplicitShutdown;
                Console.WriteLine("Creating login window...");
                var loginViewModel = _serviceProvider.GetRequiredService<LoginViewModel>();
                var loginWindow = new LoginWindow(loginViewModel);
                Console.WriteLine("Login window created successfully.");

                // STEP 4: Set up login success event handler
                // When user successfully logs in, transition to main application window
                loginViewModel.LoginSuccessful += async (sender, e) => await OnLoginSuccessful();

                // Display the login window to start user interaction
                Console.WriteLine("Showing login window...");
                loginWindow.Show();
                Console.WriteLine("=== APPLICATION STARTUP COMPLETE ===");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"=== STARTUP ERROR ===");
                Console.WriteLine($"Error: {ex.Message}");
                if (ex.InnerException != null)
                {
                    Console.WriteLine($"Inner exception: {ex.InnerException.Message}");
                }
                Console.WriteLine($"Stack trace: {ex.StackTrace}");
                Console.WriteLine($"=== END ERROR ===");

                // Handle any startup failures gracefully
                MessageBox.Show($"Application startup failed: {ex.Message}\n\nInner Exception: {ex.InnerException?.Message}\n\nStack Trace: {ex.StackTrace}", "Startup Error", MessageBoxButton.OK, MessageBoxImage.Error);
                Console.ReadKey(); // Wait for user input before closing
                Shutdown();
            }
        }

        /// <summary>
        /// Configures the dependency injection container with all required services.
        /// This method sets up the service lifetimes and dependencies for the entire application.
        /// 
        /// Service Lifetime Patterns:
        /// - Singleton: Services that maintain state across the application (Configuration, Email, Security)
        /// - Transient: Services that are stateless and can be created fresh each time (Business logic services, ViewModels)
        /// - Scoped: Not used in this WPF app (typically used in web applications)
        /// 
        /// Data Flow Architecture:
        /// ViewModels -> Business Services -> Data Services -> DbContext -> Database
        /// </summary>
        /// <param name="services">Service collection to configure</param>
        private void ConfigureServices(ServiceCollection services)
        {
            // CONFIGURATION SETUP
            // Register Microsoft.Extensions.Configuration.IConfiguration for services that require it
            var configuration = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory())
                .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
                .AddEnvironmentVariables()
                .Build();

            services.AddSingleton<IConfiguration>(configuration);

            // LOGGING CONFIGURATION
            // Set up application-wide logging with Information level as minimum
            // Logs are written to console and file (configured in appsettings.json)
            services.AddLogging(builder =>
            {
                builder.SetMinimumLevel(LogLevel.Information);
            });

            // DATABASE CONTEXT
            // DbContext manages Entity Framework operations and database connections
            // Using AddDbContext with SQL Server for proper connection management and scoped lifetime
            services.AddDbContext<ClubManagementDbContext>(options =>
                options.UseSqlServer(configuration.GetConnectionString("DefaultConnection")), ServiceLifetime.Transient);

            // CORE BUSINESS SERVICES (Scoped)
            // These services handle business logic and data operations
            // Scoped lifetime ensures they share the same DbContext instance within an operation scope

            // User management: Authentication, user CRUD, activity tracking
            // Changed to Singleton to maintain current user session state across the application
            services.AddTransient<IUserService, UserService>();

            // Club management: Club CRUD, leadership roles, statistics
            services.AddTransient<IClubService, ClubService>();

            // Event management: Event lifecycle, participant registration, attendance tracking
            services.AddTransient<IEventService, EventService>();

            // Report generation: Various report types, data aggregation, export functionality
            services.AddTransient<IReportService, ReportService>();

            // Authorization: Role-based access control, permission checking
            services.AddScoped<IAuthorizationService, AuthorizationService>();

            // VIEW MODELS (Transient)
            // ViewModels coordinate between Views and Services, implementing MVVM pattern
            // Transient lifetime allows fresh state for each window/view instance

            // Main application window coordination
            services.AddTransient<MainViewModel>();

            // User authentication and login flow
            services.AddTransient<LoginViewModel>();

            // Dashboard statistics and overview
            services.AddTransient<DashboardViewModel>();

            // Member list management and operations
            services.AddTransient<MemberListViewModel>();

            // Event creation, editing, and management
            services.AddTransient<EventManagementViewModel>();

            // Club administration and settings
            services.AddTransient<ClubManagementViewModel>();

            // Report generation and viewing
            services.AddTransient<ReportsViewModel>();

            services.AddTransient<ReportsView>();
            services.AddTransient<EventManagementView>();
            services.AddTransient<MemberListView>();
            services.AddTransient<ClubManagementView>();

            // UI navigation: Window management, view transitions
            services.AddSingleton<INavigationService, NavigationService>();
        }

        /// <summary>
        /// Handles the transition from login window to main application window after successful authentication.
        /// This method is called when the LoginViewModel fires the LoginSuccessful event.
        /// 
        /// Data Flow:
        /// 1. Retrieve the authenticated user from UserService
        /// 2. Initialize MainViewModel with user context
        /// 3. Create and display the main application window
        /// 4. Close the login window to complete the transition
        /// 
        /// This method ensures a smooth user experience by managing window lifecycle
        /// and establishing the user session context for the main application.
        /// </summary>
        private async Task OnLoginSuccessful()
        {
            try
            {
                // STEP 1: Retrieve the authenticated user
                // The user has already been validated during login, so we fetch their full profile
                var userService = _serviceProvider!.GetRequiredService<IUserService>();
                var currentUser = await userService.GetCurrentUserAsync();

                if (currentUser != null)
                {
                    // STEP 2: Initialize main application context
                    // Create MainViewModel and establish user session with their profile and permissions
                    var mainViewModel = _serviceProvider!.GetRequiredService<MainViewModel>();

                    // Set the current user directly since authentication is already complete
                    mainViewModel.CurrentUser = currentUser;

                    // STEP 3: Create and display main application window
                    // The MainWindow contains the primary UI with navigation, dashboard, and all features
                    await mainViewModel.LoadAsync();
                    var mainWindow = new MainWindow(mainViewModel);

                    Application.Current.ShutdownMode = ShutdownMode.OnMainWindowClose;
                    Application.Current.MainWindow = mainWindow;
                    mainWindow.Show();

                    // STEP 4: Close login window
                    // Clean up the login window to complete the transition to main application
                    foreach (Window window in Windows)
                    {
                        if (window is LoginWindow)
                        {
                            window.Close();
                            break;
                        }
                    }
                }
                else
                {
                    MessageBox.Show("Không thể lấy thông tin người dùng hiện tại.", "Lỗi", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
            catch (Exception ex)
            {
                // Handle any errors during the transition gracefully
                MessageBox.Show($"Không thể mở cửa sổ chính: {ex.Message}", "Lỗi hệ thống", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        /// <summary>
        /// Handles application shutdown and cleanup when the user exits the application.
        /// This method is called automatically by WPF when the application is closing.
        /// 
        /// Data Flow:
        /// 1. Dispose of the dependency injection service provider to clean up all services
        /// 2. Call base implementation to complete the WPF shutdown process
        /// 
        /// This ensures proper resource disposal and clean application termination.
        /// </summary>
        /// <param name="e">Exit event arguments containing exit code and cancellation options</param>
        protected override void OnExit(ExitEventArgs e)
        {
            // STEP 1: Dispose of service provider
            // This will dispose all registered services that implement IDisposable
            // including database contexts, file handles, and other managed resources
            _serviceProvider?.Dispose();

            // STEP 2: Complete WPF shutdown process
            // Call base implementation to ensure proper WPF application cleanup
            base.OnExit(e);
        }
    }
}
