USE [master]
GO
/****** Object:  Database [ClubManagementDB]    Script Date: 7/22/2025 8:50:09 PM ******/
CREATE DATABASE [ClubManagementDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ClubManagementDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\ClubManagementDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ClubManagementDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\ClubManagementDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [ClubManagementDB] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ClubManagementDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ClubManagementDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ClubManagementDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ClubManagementDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ClubManagementDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ClubManagementDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [ClubManagementDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ClubManagementDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ClubManagementDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ClubManagementDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ClubManagementDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ClubManagementDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ClubManagementDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ClubManagementDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ClubManagementDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ClubManagementDB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [ClubManagementDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ClubManagementDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ClubManagementDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ClubManagementDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ClubManagementDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ClubManagementDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ClubManagementDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ClubManagementDB] SET RECOVERY FULL 
GO
ALTER DATABASE [ClubManagementDB] SET  MULTI_USER 
GO
ALTER DATABASE [ClubManagementDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ClubManagementDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ClubManagementDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ClubManagementDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ClubManagementDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ClubManagementDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'ClubManagementDB', N'ON'
GO
ALTER DATABASE [ClubManagementDB] SET QUERY_STORE = ON
GO
ALTER DATABASE [ClubManagementDB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [ClubManagementDB]
GO
/****** Object:  Table [dbo].[Clubs]    Script Date: 7/22/2025 8:50:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clubs](
	[ClubID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[ContactEmail] [nvarchar](150) NULL,
	[ContactPhone] [nvarchar](20) NULL,
	[Website] [nvarchar](200) NULL,
	[MeetingSchedule] [nvarchar](200) NULL,
	[FoundedDate] [datetime2](7) NULL,
	[IsActive] [bit] NOT NULL,
	[IsSelected] [bit] NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ClubID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventParticipants]    Script Date: 7/22/2025 8:50:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventParticipants](
	[ParticipantID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[EventID] [int] NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[RegistrationDate] [datetime2](7) NOT NULL,
	[AttendanceDate] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[ParticipantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Events]    Script Date: 7/22/2025 8:50:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Events](
	[EventID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Description] [nvarchar](1000) NULL,
	[EventDate] [datetime2](7) NOT NULL,
	[Location] [nvarchar](300) NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[RegistrationDeadline] [datetime2](7) NULL,
	[MaxParticipants] [int] NULL,
	[Status] [nvarchar](50) NOT NULL,
	[ClubID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EventID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reports]    Script Date: 7/22/2025 8:50:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reports](
	[ReportID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](200) NOT NULL,
	[Type] [nvarchar](50) NOT NULL,
	[Content] [nvarchar](max) NOT NULL,
	[GeneratedDate] [datetime2](7) NOT NULL,
	[Semester] [nvarchar](50) NULL,
	[ClubID] [int] NULL,
	[GeneratedByUserID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ReportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 7/22/2025 8:50:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[FullName] [nvarchar](100) NOT NULL,
	[Email] [nvarchar](150) NOT NULL,
	[Password] [nvarchar](255) NOT NULL,
	[StudentID] [nvarchar](20) NULL,
	[PhoneNumber] [nvarchar](20) NULL,
	[Role] [nvarchar](50) NOT NULL,
	[JoinDate] [datetime2](7) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[ClubID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Clubs] ON 

INSERT [dbo].[Clubs] ([ClubID], [Name], [Description], [ContactEmail], [ContactPhone], [Website], [MeetingSchedule], [FoundedDate], [IsActive], [IsSelected], [CreatedDate], [CreatedBy]) VALUES (1, N'Computer Science Club', N'A club for computer science enthusiasts to learn and share knowledge about programming, algorithms, and technology.', N'cs.club@university.edu', N'555-0101', N'https://csclub.university.edu', N'Fridays 3:00 PM - Room 201', CAST(N'2020-09-15T00:00:00.0000000' AS DateTime2), 1, 0, CAST(N'2025-01-15T00:00:00.0000000' AS DateTime2), 1)
INSERT [dbo].[Clubs] ([ClubID], [Name], [Description], [ContactEmail], [ContactPhone], [Website], [MeetingSchedule], [FoundedDate], [IsActive], [IsSelected], [CreatedDate], [CreatedBy]) VALUES (2, N'Drama Society', N'Dedicated to theatrical performances, script writing, and dramatic arts education.', N'drama@university.edu', N'555-0102', N'https://drama.university.edu', N'Wednesdays 4:00 PM - Theater', CAST(N'2019-03-20T00:00:00.0000000' AS DateTime2), 1, 0, CAST(N'2025-01-20T00:00:00.0000000' AS DateTime2), 2)
INSERT [dbo].[Clubs] ([ClubID], [Name], [Description], [ContactEmail], [ContactPhone], [Website], [MeetingSchedule], [FoundedDate], [IsActive], [IsSelected], [CreatedDate], [CreatedBy]) VALUES (3, N'Environmental Club', N'Focused on environmental conservation, sustainability projects, and eco-friendly initiatives.', N'eco.club@university.edu', N'555-0103', N'https://ecoclub.university.edu', N'Tuesdays 2:00 PM - Green Room', CAST(N'2021-04-22T00:00:00.0000000' AS DateTime2), 1, 0, CAST(N'2025-02-01T00:00:00.0000000' AS DateTime2), 3)
INSERT [dbo].[Clubs] ([ClubID], [Name], [Description], [ContactEmail], [ContactPhone], [Website], [MeetingSchedule], [FoundedDate], [IsActive], [IsSelected], [CreatedDate], [CreatedBy]) VALUES (4, N'Photography Club', N'For photography enthusiasts to improve skills, share techniques, and organize photo walks.', N'photo@university.edu', N'555-0104', N'https://photoclub.university.edu', N'Saturdays 10:00 AM - Studio', CAST(N'2020-11-10T00:00:00.0000000' AS DateTime2), 1, 0, CAST(N'2025-02-10T00:00:00.0000000' AS DateTime2), 4)
INSERT [dbo].[Clubs] ([ClubID], [Name], [Description], [ContactEmail], [ContactPhone], [Website], [MeetingSchedule], [FoundedDate], [IsActive], [IsSelected], [CreatedDate], [CreatedBy]) VALUES (5, N'Debate Society', N'Enhancing public speaking, critical thinking, and argumentation skills through structured debates.', N'debate@university.edu', N'555-0105', N'https://debate.university.edu', N'Thursdays 5:00 PM - Hall A', CAST(N'2018-01-15T00:00:00.0000000' AS DateTime2), 1, 0, CAST(N'2025-02-15T00:00:00.0000000' AS DateTime2), 5)
INSERT [dbo].[Clubs] ([ClubID], [Name], [Description], [ContactEmail], [ContactPhone], [Website], [MeetingSchedule], [FoundedDate], [IsActive], [IsSelected], [CreatedDate], [CreatedBy]) VALUES (6, N'Music Club', N'Bringing together musicians of all levels to perform, collaborate, and appreciate various music genres.', N'music@university.edu', N'555-0106', N'https://musicclub.university.edu', N'Mondays 6:00 PM - Music Room', CAST(N'2017-08-30T00:00:00.0000000' AS DateTime2), 1, 0, CAST(N'2025-03-01T00:00:00.0000000' AS DateTime2), 6)
INSERT [dbo].[Clubs] ([ClubID], [Name], [Description], [ContactEmail], [ContactPhone], [Website], [MeetingSchedule], [FoundedDate], [IsActive], [IsSelected], [CreatedDate], [CreatedBy]) VALUES (7, N'Sports Club', N'Organizing various sports activities, tournaments, and promoting physical fitness among students.', N'sports@university.edu', N'555-0107', N'https://sportsclub.university.edu', N'Daily 7:00 AM - Gym', CAST(N'2016-05-12T00:00:00.0000000' AS DateTime2), 1, 0, CAST(N'2025-03-05T00:00:00.0000000' AS DateTime2), 40)
INSERT [dbo].[Clubs] ([ClubID], [Name], [Description], [ContactEmail], [ContactPhone], [Website], [MeetingSchedule], [FoundedDate], [IsActive], [IsSelected], [CreatedDate], [CreatedBy]) VALUES (8, N'Literature Society', N'For book lovers, creative writers, and those passionate about literature and poetry.', N'literature@university.edu', N'555-0108', N'https://litclub.university.edu', N'Sundays 3:00 PM - Library', CAST(N'2019-10-05T00:00:00.0000000' AS DateTime2), 1, 0, CAST(N'2025-03-10T00:00:00.0000000' AS DateTime2), 27)
INSERT [dbo].[Clubs] ([ClubID], [Name], [Description], [ContactEmail], [ContactPhone], [Website], [MeetingSchedule], [FoundedDate], [IsActive], [IsSelected], [CreatedDate], [CreatedBy]) VALUES (9, N'Science Innovation Lab', N'Encouraging scientific research, innovation projects, and STEM education initiatives.', N'scilab@university.edu', N'555-0109', N'https://scilab.university.edu', N'Wednesdays 1:00 PM - Lab 301', CAST(N'2021-02-28T00:00:00.0000000' AS DateTime2), 1, 0, CAST(N'2025-03-15T00:00:00.0000000' AS DateTime2), 52)
INSERT [dbo].[Clubs] ([ClubID], [Name], [Description], [ContactEmail], [ContactPhone], [Website], [MeetingSchedule], [FoundedDate], [IsActive], [IsSelected], [CreatedDate], [CreatedBy]) VALUES (10, N'Cultural Heritage Club', N'Preserving and promoting cultural traditions, organizing cultural events and festivals.', N'culture@university.edu', N'555-0110', N'https://culture.university.edu', N'Fridays 4:00 PM - Cultural Center', CAST(N'2020-07-18T00:00:00.0000000' AS DateTime2), 1, 0, CAST(N'2025-03-20T00:00:00.0000000' AS DateTime2), 103)
INSERT [dbo].[Clubs] ([ClubID], [Name], [Description], [ContactEmail], [ContactPhone], [Website], [MeetingSchedule], [FoundedDate], [IsActive], [IsSelected], [CreatedDate], [CreatedBy]) VALUES (13, N'b new', N'bbbbbb', NULL, NULL, NULL, NULL, CAST(N'2025-07-20T00:00:00.0000000' AS DateTime2), 1, 0, CAST(N'2025-07-20T16:27:03.3747544' AS DateTime2), 12)
SET IDENTITY_INSERT [dbo].[Clubs] OFF
GO
SET IDENTITY_INSERT [dbo].[EventParticipants] ON 

INSERT [dbo].[EventParticipants] ([ParticipantID], [UserID], [EventID], [Status], [RegistrationDate], [AttendanceDate]) VALUES (1, 2, 1, N'Attended', CAST(N'2025-06-15T00:00:00.0000000' AS DateTime2), CAST(N'2025-12-15T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[EventParticipants] ([ParticipantID], [UserID], [EventID], [Status], [RegistrationDate], [AttendanceDate]) VALUES (2, 3, 1, N'Registered', CAST(N'2025-06-16T00:00:00.0000000' AS DateTime2), NULL)
INSERT [dbo].[EventParticipants] ([ParticipantID], [UserID], [EventID], [Status], [RegistrationDate], [AttendanceDate]) VALUES (3, 4, 1, N'Registered', CAST(N'2025-06-17T00:00:00.0000000' AS DateTime2), NULL)
INSERT [dbo].[EventParticipants] ([ParticipantID], [UserID], [EventID], [Status], [RegistrationDate], [AttendanceDate]) VALUES (4, 5, 1, N'Absent', CAST(N'2025-06-18T00:00:00.0000000' AS DateTime2), NULL)
INSERT [dbo].[EventParticipants] ([ParticipantID], [UserID], [EventID], [Status], [RegistrationDate], [AttendanceDate]) VALUES (5, 2, 2, N'Registered', CAST(N'2025-06-20T00:00:00.0000000' AS DateTime2), NULL)
INSERT [dbo].[EventParticipants] ([ParticipantID], [UserID], [EventID], [Status], [RegistrationDate], [AttendanceDate]) VALUES (6, 3, 2, N'Registered', CAST(N'2025-06-21T00:00:00.0000000' AS DateTime2), NULL)
INSERT [dbo].[EventParticipants] ([ParticipantID], [UserID], [EventID], [Status], [RegistrationDate], [AttendanceDate]) VALUES (7, 4, 2, N'Registered', CAST(N'2025-06-22T00:00:00.0000000' AS DateTime2), NULL)
INSERT [dbo].[EventParticipants] ([ParticipantID], [UserID], [EventID], [Status], [RegistrationDate], [AttendanceDate]) VALUES (8, 5, 2, N'Registered', CAST(N'2025-06-23T00:00:00.0000000' AS DateTime2), NULL)
INSERT [dbo].[EventParticipants] ([ParticipantID], [UserID], [EventID], [Status], [RegistrationDate], [AttendanceDate]) VALUES (9, 6, 2, N'Registered', CAST(N'2025-06-24T00:00:00.0000000' AS DateTime2), NULL)
INSERT [dbo].[EventParticipants] ([ParticipantID], [UserID], [EventID], [Status], [RegistrationDate], [AttendanceDate]) VALUES (10, 5, 4, N'Attended', CAST(N'2025-06-25T00:00:00.0000000' AS DateTime2), CAST(N'2025-12-12T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[EventParticipants] ([ParticipantID], [UserID], [EventID], [Status], [RegistrationDate], [AttendanceDate]) VALUES (11, 6, 4, N'Attended', CAST(N'2025-06-26T00:00:00.0000000' AS DateTime2), CAST(N'2025-12-12T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[EventParticipants] ([ParticipantID], [UserID], [EventID], [Status], [RegistrationDate], [AttendanceDate]) VALUES (12, 7, 4, N'Attended', CAST(N'2025-06-27T00:00:00.0000000' AS DateTime2), CAST(N'2025-12-12T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[EventParticipants] ([ParticipantID], [UserID], [EventID], [Status], [RegistrationDate], [AttendanceDate]) VALUES (13, 8, 4, N'Absent', CAST(N'2025-06-28T00:00:00.0000000' AS DateTime2), NULL)
INSERT [dbo].[EventParticipants] ([ParticipantID], [UserID], [EventID], [Status], [RegistrationDate], [AttendanceDate]) VALUES (14, 4, 9, N'Attended', CAST(N'2025-06-29T00:00:00.0000000' AS DateTime2), CAST(N'2025-12-13T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[EventParticipants] ([ParticipantID], [UserID], [EventID], [Status], [RegistrationDate], [AttendanceDate]) VALUES (15, 5, 9, N'Attended', CAST(N'2025-06-30T00:00:00.0000000' AS DateTime2), CAST(N'2025-12-13T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[EventParticipants] ([ParticipantID], [UserID], [EventID], [Status], [RegistrationDate], [AttendanceDate]) VALUES (16, 6, 9, N'Attended', CAST(N'2025-07-01T00:00:00.0000000' AS DateTime2), CAST(N'2025-12-13T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[EventParticipants] ([ParticipantID], [UserID], [EventID], [Status], [RegistrationDate], [AttendanceDate]) VALUES (17, 2, 9, N'Attended', CAST(N'2025-07-02T00:00:00.0000000' AS DateTime2), CAST(N'2025-12-13T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[EventParticipants] ([ParticipantID], [UserID], [EventID], [Status], [RegistrationDate], [AttendanceDate]) VALUES (18, 7, 9, N'Attended', CAST(N'2025-07-03T00:00:00.0000000' AS DateTime2), CAST(N'2025-12-13T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[EventParticipants] ([ParticipantID], [UserID], [EventID], [Status], [RegistrationDate], [AttendanceDate]) VALUES (19, 10, 14, N'Attended', CAST(N'2025-07-20T17:29:30.2499629' AS DateTime2), CAST(N'2025-07-21T10:56:26.3436366' AS DateTime2))
SET IDENTITY_INSERT [dbo].[EventParticipants] OFF
GO
SET IDENTITY_INSERT [dbo].[Events] ON 

INSERT [dbo].[Events] ([EventID], [Name], [Description], [EventDate], [Location], [CreatedDate], [IsActive], [RegistrationDeadline], [MaxParticipants], [Status], [ClubID]) VALUES (1, N'Python Workshop', N'Learn Python programming from basics to advanced concepts', CAST(N'2025-12-15T14:00:00.0000000' AS DateTime2), N'Computer Lab A', CAST(N'2025-06-01T00:00:00.0000000' AS DateTime2), 1, CAST(N'2025-07-10T00:00:00.0000000' AS DateTime2), 30, N'Scheduled', 1)
INSERT [dbo].[Events] ([EventID], [Name], [Description], [EventDate], [Location], [CreatedDate], [IsActive], [RegistrationDeadline], [MaxParticipants], [Status], [ClubID]) VALUES (2, N'Hackathon 2025', N'24-hour coding competition with exciting prizes', CAST(N'2025-12-20T09:00:00.0000000' AS DateTime2), N'Main Auditorium', CAST(N'2025-06-05T00:00:00.0000000' AS DateTime2), 1, CAST(N'2025-07-10T00:00:00.0000000' AS DateTime2), 100, N'Scheduled', 1)
INSERT [dbo].[Events] ([EventID], [Name], [Description], [EventDate], [Location], [CreatedDate], [IsActive], [RegistrationDeadline], [MaxParticipants], [Status], [ClubID]) VALUES (3, N'AI and Machine Learning Seminar', N'Industry experts discuss the future of AI', CAST(N'2026-01-10T16:00:00.0000000' AS DateTime2), N'Conference Room B', CAST(N'2025-06-10T00:00:00.0000000' AS DateTime2), 1, CAST(N'2025-07-10T00:00:00.0000000' AS DateTime2), 50, N'Scheduled', 1)
INSERT [dbo].[Events] ([EventID], [Name], [Description], [EventDate], [Location], [CreatedDate], [IsActive], [RegistrationDeadline], [MaxParticipants], [Status], [ClubID]) VALUES (4, N'Nature Photography Walk', N'Capture the beauty of campus nature', CAST(N'2025-12-12T08:00:00.0000000' AS DateTime2), N'University Gardens', CAST(N'2025-06-02T00:00:00.0000000' AS DateTime2), 1, CAST(N'2025-07-08T00:00:00.0000000' AS DateTime2), 20, N'Scheduled', 4)
INSERT [dbo].[Events] ([EventID], [Name], [Description], [EventDate], [Location], [CreatedDate], [IsActive], [RegistrationDeadline], [MaxParticipants], [Status], [ClubID]) VALUES (5, N'Portrait Photography Workshop', N'Learn professional portrait techniques', CAST(N'2025-12-18T13:00:00.0000000' AS DateTime2), N'Studio Room 1', CAST(N'2025-06-06T00:00:00.0000000' AS DateTime2), 1, CAST(N'2025-07-10T00:00:00.0000000' AS DateTime2), 15, N'Scheduled', 4)
INSERT [dbo].[Events] ([EventID], [Name], [Description], [EventDate], [Location], [CreatedDate], [IsActive], [RegistrationDeadline], [MaxParticipants], [Status], [ClubID]) VALUES (6, N'Photo Exhibition Setup', N'Prepare for the annual photo exhibition', CAST(N'2026-01-15T10:00:00.0000000' AS DateTime2), N'Gallery Hall', CAST(N'2025-06-12T00:00:00.0000000' AS DateTime2), 1, CAST(N'2025-07-10T00:00:00.0000000' AS DateTime2), 25, N'Scheduled', 4)
INSERT [dbo].[Events] ([EventID], [Name], [Description], [EventDate], [Location], [CreatedDate], [IsActive], [RegistrationDeadline], [MaxParticipants], [Status], [ClubID]) VALUES (7, N'Romeo and Juliet Auditions', N'Auditions for the spring play', CAST(N'2025-12-14T15:00:00.0000000' AS DateTime2), N'Theater Room', CAST(N'2025-06-03T00:00:00.0000000' AS DateTime2), 1, CAST(N'2025-07-10T00:00:00.0000000' AS DateTime2), 40, N'Scheduled', 2)
INSERT [dbo].[Events] ([EventID], [Name], [Description], [EventDate], [Location], [CreatedDate], [IsActive], [RegistrationDeadline], [MaxParticipants], [Status], [ClubID]) VALUES (8, N'Acting Workshop', N'Improve your acting skills with professional coaches', CAST(N'2025-12-21T11:00:00.0000000' AS DateTime2), N'Drama Studio', CAST(N'2025-06-07T00:00:00.0000000' AS DateTime2), 1, CAST(N'2025-07-10T00:00:00.0000000' AS DateTime2), 25, N'Scheduled', 2)
INSERT [dbo].[Events] ([EventID], [Name], [Description], [EventDate], [Location], [CreatedDate], [IsActive], [RegistrationDeadline], [MaxParticipants], [Status], [ClubID]) VALUES (9, N'Campus Cleanup Drive', N'Help keep our campus clean and green', CAST(N'2025-12-13T07:00:00.0000000' AS DateTime2), N'Campus Grounds', CAST(N'2025-06-04T00:00:00.0000000' AS DateTime2), 1, CAST(N'2025-07-10T00:00:00.0000000' AS DateTime2), 50, N'Scheduled', 3)
INSERT [dbo].[Events] ([EventID], [Name], [Description], [EventDate], [Location], [CreatedDate], [IsActive], [RegistrationDeadline], [MaxParticipants], [Status], [ClubID]) VALUES (10, N'Sustainability Fair', N'Learn about sustainable living practices', CAST(N'2025-12-19T12:00:00.0000000' AS DateTime2), N'Student Center', CAST(N'2025-06-08T00:00:00.0000000' AS DateTime2), 1, CAST(N'2025-07-10T00:00:00.0000000' AS DateTime2), 100, N'Scheduled', 3)
INSERT [dbo].[Events] ([EventID], [Name], [Description], [EventDate], [Location], [CreatedDate], [IsActive], [RegistrationDeadline], [MaxParticipants], [Status], [ClubID]) VALUES (11, N'Winter Concert', N'Showcase of student musical talents', CAST(N'2025-12-22T19:00:00.0000000' AS DateTime2), N'Music Hall', CAST(N'2025-06-09T00:00:00.0000000' AS DateTime2), 1, CAST(N'2025-07-10T00:00:00.0000000' AS DateTime2), 200, N'Scheduled', 6)
INSERT [dbo].[Events] ([EventID], [Name], [Description], [EventDate], [Location], [CreatedDate], [IsActive], [RegistrationDeadline], [MaxParticipants], [Status], [ClubID]) VALUES (12, N'Songwriting Workshop', N'Learn to write your own songs', CAST(N'2026-01-08T14:00:00.0000000' AS DateTime2), N'Music Room 2', CAST(N'2025-06-11T00:00:00.0000000' AS DateTime2), 1, CAST(N'2025-07-10T00:00:00.0000000' AS DateTime2), 20, N'Scheduled', 6)
INSERT [dbo].[Events] ([EventID], [Name], [Description], [EventDate], [Location], [CreatedDate], [IsActive], [RegistrationDeadline], [MaxParticipants], [Status], [ClubID]) VALUES (14, N'sự kiện nè new', N'fdsádà', CAST(N'2025-07-22T10:00:00.0000000' AS DateTime2), N'fdsà', CAST(N'2025-07-20T17:28:05.1816580' AS DateTime2), 1, CAST(N'2025-07-20T00:00:00.0000000' AS DateTime2), 12, N'InProgress', 13)
SET IDENTITY_INSERT [dbo].[Events] OFF
GO
SET IDENTITY_INSERT [dbo].[Reports] ON 

INSERT [dbo].[Reports] ([ReportID], [Title], [Type], [Content], [GeneratedDate], [Semester], [ClubID], [GeneratedByUserID]) VALUES (1, N'Computer Science Club - Fall 2025 Member Statistics', N'MemberStatistics', N'{"totalMembers": 1, "activeMembers": 1, "newMembers": 1, "membersByRole": {"Chairman": 1, "Member": 0}}', CAST(N'2025-11-15T00:00:00.0000000' AS DateTime2), N'Fall 2025', 1, 2)
INSERT [dbo].[Reports] ([ReportID], [Title], [Type], [Content], [GeneratedDate], [Semester], [ClubID], [GeneratedByUserID]) VALUES (2, N'Photography Club - Event Outcomes Report', N'EventOutcomes', N'{"eventsHeld": 2, "totalParticipants": 7, "averageAttendance": 85, "topEvent": "Nature Photography Walk"}', CAST(N'2025-11-20T00:00:00.0000000' AS DateTime2), N'Fall 2025', 4, 5)
INSERT [dbo].[Reports] ([ReportID], [Title], [Type], [Content], [GeneratedDate], [Semester], [ClubID], [GeneratedByUserID]) VALUES (3, N'Environmental Club - Activity Tracking', N'ActivityTracking', N'{"activitiesCompleted": 1, "volunteersParticipated": 5, "impactMetrics": {"wasteCollected": "50kg", "areasCleaned": 3}}', CAST(N'2025-11-25T00:00:00.0000000' AS DateTime2), N'Fall 2025', 3, 4)
INSERT [dbo].[Reports] ([ReportID], [Title], [Type], [Content], [GeneratedDate], [Semester], [ClubID], [GeneratedByUserID]) VALUES (4, N'University-wide Semester Summary', N'SemesterSummary', N'{"totalClubs": 10, "totalMembers": 8, "totalEvents": 12, "overallEngagement": "High", "topPerformingClubs": ["Computer Science Club", "Photography Club", "Environmental Club"]}', CAST(N'2025-11-30T00:00:00.0000000' AS DateTime2), N'Fall 2025', NULL, 1)
INSERT [dbo].[Reports] ([ReportID], [Title], [Type], [Content], [GeneratedDate], [Semester], [ClubID], [GeneratedByUserID]) VALUES (5, N'Drama Society - Member Statistics', N'MemberStatistics', N'{"totalMembers": 1, "activeMembers": 1, "upcomingProductions": 1, "auditionParticipants": 15}', CAST(N'2025-12-01T00:00:00.0000000' AS DateTime2), N'Fall 2025', 2, 3)
INSERT [dbo].[Reports] ([ReportID], [Title], [Type], [Content], [GeneratedDate], [Semester], [ClubID], [GeneratedByUserID]) VALUES (6, N'Music Club - Event Outcomes', N'EventOutcomes', N'{"concertsPlanned": 1, "workshopsHeld": 0, "expectedAttendance": 200, "repertoireSize": 12}', CAST(N'2025-12-05T00:00:00.0000000' AS DateTime2), N'Fall 2025', 6, 7)
SET IDENTITY_INSERT [dbo].[Reports] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (1, N'System Administrator', N'admin@gmail.com', N'jZae727K08KaOmKSgOaGzww/XVqGr/PKEgIMkjrcbJI=', NULL, N'012345678', N'Admin', CAST(N'2025-01-01T00:00:00.0000000' AS DateTime2), 1, NULL)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (2, N'Alice Johnson', N'alice.johnson@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'CS2025001', NULL, N'Chairman', CAST(N'2025-01-15T00:00:00.0000000' AS DateTime2), 1, 1)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (3, N'Bob Smith', N'bob.smith@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'DR2025002', NULL, N'Chairman', CAST(N'2025-01-20T00:00:00.0000000' AS DateTime2), 1, 2)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (4, N'Carol Davis', N'carol.davis@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'EN2025003', NULL, N'Member', CAST(N'2025-02-01T00:00:00.0000000' AS DateTime2), 1, 3)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (5, N'David Wilson', N'david.wilson@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'PH2025004', NULL, N'Member', CAST(N'2025-02-10T00:00:00.0000000' AS DateTime2), 1, 4)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (6, N'Emma Brown', N'emma.brown@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'DB2025005', NULL, N'Member', CAST(N'2025-02-15T00:00:00.0000000' AS DateTime2), 1, 5)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (7, N'Frank Miller', N'frank.miller@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'MU2025006', NULL, N'Member', CAST(N'2025-03-01T00:00:00.0000000' AS DateTime2), 1, 6)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (8, N'Grace Lee', N'grace.lee@gmail.com', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'SP2025007', NULL, N'Chairman', CAST(N'2025-03-05T00:00:00.0000000' AS DateTime2), 1, 7)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (10, N'bbb', N'bbb@gmail.com', N'jZae727K08KaOmKSgOaGzww/XVqGr/PKEgIMkjrcbJI=', NULL, N'123456789', N'Member', CAST(N'2025-07-20T16:23:33.5356931' AS DateTime2), 1, NULL)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (11, N'ccc', N'ccc@gmail.com', N'jZae727K08KaOmKSgOaGzww/XVqGr/PKEgIMkjrcbJI=', NULL, N'1234567890', N'Member', CAST(N'2025-07-20T16:24:00.6592478' AS DateTime2), 1, 13)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (12, N'bb', N'b@gmail.com', N'jZae727K08KaOmKSgOaGzww/XVqGr/PKEgIMkjrcbJI=', NULL, N'12343241233421', N'Chairman', CAST(N'2025-07-20T16:26:09.9985357' AS DateTime2), 1, 13)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (13, N'test', N'test@gmail.com', N'jZae727K08KaOmKSgOaGzww/XVqGr/PKEgIMkjrcbJI=', NULL, N'1234321423', N'Chairman', CAST(N'2025-07-21T03:50:51.0778264' AS DateTime2), 1, NULL)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (14, N'Michael Thompson', N'michael.thompson@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'CS2025008', NULL, N'Member', CAST(N'2025-03-11T00:00:00.0000000' AS DateTime2), 1, 1)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (15, N'Sarah White', N'sarah.white@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'DR2025009', NULL, N'Member', CAST(N'2025-03-12T00:00:00.0000000' AS DateTime2), 1, 2)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (16, N'James Harris', N'james.harris@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'EN2025010', NULL, N'Member', CAST(N'2025-03-13T00:00:00.0000000' AS DateTime2), 1, 3)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (17, N'Jessica Martinez', N'jessica.martinez@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'PH2025011', NULL, N'Member', CAST(N'2025-03-14T00:00:00.0000000' AS DateTime2), 1, 4)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (18, N'Daniel Clark', N'daniel.clark@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'DB2025012', NULL, N'Member', CAST(N'2025-03-15T00:00:00.0000000' AS DateTime2), 1, 5)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (19, N'Emily Lewis', N'emily.lewis@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'MU2025013', NULL, N'Member', CAST(N'2025-03-16T00:00:00.0000000' AS DateTime2), 1, 6)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (20, N'Matthew Walker', N'matthew.walker@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'SP2025014', NULL, N'Member', CAST(N'2025-03-17T00:00:00.0000000' AS DateTime2), 1, 7)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (21, N'Ashley Hall', N'ashley.hall@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'LI2025015', NULL, N'Member', CAST(N'2025-03-18T00:00:00.0000000' AS DateTime2), 1, 8)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (22, N'Joshua Young', N'joshua.young@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'SC2025016', NULL, N'Member', CAST(N'2025-03-19T00:00:00.0000000' AS DateTime2), 1, 9)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (23, N'Amanda King', N'amanda.king@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'CU2025017', NULL, N'Member', CAST(N'2025-03-20T00:00:00.0000000' AS DateTime2), 1, 10)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (24, N'William Wright', N'william.wright@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'CS2025018', NULL, N'Member', CAST(N'2025-03-21T00:00:00.0000000' AS DateTime2), 1, 1)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (25, N'Olivia Lopez', N'olivia.lopez@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'DR2025019', NULL, N'Member', CAST(N'2025-03-22T00:00:00.0000000' AS DateTime2), 1, 2)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (26, N'Andrew Scott', N'andrew.scott@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'EN2025020', NULL, N'Member', CAST(N'2025-03-23T00:00:00.0000000' AS DateTime2), 1, 3)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (27, N'Lauren Baker', N'lauren.baker@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'PH2025021', NULL, N'Chairman', CAST(N'2025-03-24T00:00:00.0000000' AS DateTime2), 1, 4)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (28, N'Christopher Gonzalez', N'christopher.gonzalez@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'DB2025022', NULL, N'Member', CAST(N'2025-03-25T00:00:00.0000000' AS DateTime2), 1, 5)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (29, N'Megan Nelson', N'megan.nelson@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'MU2025023', NULL, N'Member', CAST(N'2025-03-26T00:00:00.0000000' AS DateTime2), 1, 6)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (30, N'Ryan Carter', N'ryan.carter@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'SP2025024', NULL, N'Member', CAST(N'2025-03-27T00:00:00.0000000' AS DateTime2), 1, 7)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (31, N'Abigail Perez update', N'abigail.perez@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'LI2025025', NULL, N'Member', CAST(N'2025-03-28T00:00:00.0000000' AS DateTime2), 1, 8)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (32, N'Tyler Edwards', N'tyler.edwards@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'SC2025026', NULL, N'Member', CAST(N'2025-03-29T00:00:00.0000000' AS DateTime2), 1, 9)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (33, N'Madison Collins', N'madison.collins@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'CU2025027', NULL, N'Member', CAST(N'2025-03-30T00:00:00.0000000' AS DateTime2), 1, 10)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (34, N'Joseph Morgan', N'joseph.morgan@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'CS2025028', NULL, N'Member', CAST(N'2025-03-31T00:00:00.0000000' AS DateTime2), 1, 1)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (35, N'Hannah Reed', N'hannah.reed@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'DR2025029', NULL, N'Member', CAST(N'2025-04-01T00:00:00.0000000' AS DateTime2), 1, 2)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (36, N'Nicholas Bailey', N'nicholas.bailey@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'EN2025030', NULL, N'Member', CAST(N'2025-04-02T00:00:00.0000000' AS DateTime2), 1, 3)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (37, N'Victoria Rivera', N'victoria.rivera@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'PH2025031', NULL, N'Member', CAST(N'2025-04-03T00:00:00.0000000' AS DateTime2), 1, 4)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (38, N'Jonathan Cooper', N'jonathan.cooper@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'DB2025032', NULL, N'Member', CAST(N'2025-04-04T00:00:00.0000000' AS DateTime2), 1, 5)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (39, N'Samantha Murphy', N'samantha.murphy@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'MU2025033', NULL, N'Member', CAST(N'2025-04-05T00:00:00.0000000' AS DateTime2), 1, 6)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (40, N'Benjamin Rogers', N'benjamin.rogers@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'SP2025034', NULL, N'Chairman', CAST(N'2025-04-06T00:00:00.0000000' AS DateTime2), 1, 7)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (41, N'Natalie Peterson', N'natalie.peterson@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'LI2025035', NULL, N'Member', CAST(N'2025-04-07T00:00:00.0000000' AS DateTime2), 1, 8)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (42, N'Jacob Torres', N'jacob.torres@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'SC2025036', NULL, N'Member', CAST(N'2025-04-08T00:00:00.0000000' AS DateTime2), 1, 9)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (43, N'Sofia Bennett', N'sofia.bennett@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'CU2025037', NULL, N'Member', CAST(N'2025-04-09T00:00:00.0000000' AS DateTime2), 1, 10)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (44, N'David Hughes', N'david.hughes@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'CS2025038', NULL, N'Member', CAST(N'2025-04-10T00:00:00.0000000' AS DateTime2), 1, 1)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (45, N'Chloe Ramirez', N'chloe.ramirez@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'DR2025039', NULL, N'Member', CAST(N'2025-04-11T00:00:00.0000000' AS DateTime2), 1, 2)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (46, N'Alexander Brooks', N'alexander.brooks@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'EN2025040', NULL, N'Member', CAST(N'2025-04-12T00:00:00.0000000' AS DateTime2), 1, 3)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (47, N'Ella Kelly', N'ella.kelly@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'PH2025041', NULL, N'Member', CAST(N'2025-04-13T00:00:00.0000000' AS DateTime2), 1, 4)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (48, N'Brandon Sanders', N'brandon.sanders@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'DB2025042', NULL, N'Member', CAST(N'2025-04-14T00:00:00.0000000' AS DateTime2), 1, 5)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (49, N'Avery Price', N'avery.price@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'MU2025043', NULL, N'Member', CAST(N'2025-04-15T00:00:00.0000000' AS DateTime2), 1, 6)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (50, N'Ethan Gray', N'ethan.gray@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'SP2025044', NULL, N'Member', CAST(N'2025-04-16T00:00:00.0000000' AS DateTime2), 1, 7)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (51, N'Zoe Barnes', N'zoe.barnes@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'LI2025045', NULL, N'Member', CAST(N'2025-04-17T00:00:00.0000000' AS DateTime2), 1, 8)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (52, N'Christian Powell', N'christian.powell@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'SC2025046', NULL, N'Chairman', CAST(N'2025-04-18T00:00:00.0000000' AS DateTime2), 1, 9)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (53, N'Lily James', N'lily.james@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'CU2025047', NULL, N'Member', CAST(N'2025-04-19T00:00:00.0000000' AS DateTime2), 1, 10)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (54, N'Jack Russell', N'jack.russell@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'CS2025048', NULL, N'Member', CAST(N'2025-04-20T00:00:00.0000000' AS DateTime2), 1, 1)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (55, N'Ella Fisher', N'ella.fisher@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'DR2025049', NULL, N'Member', CAST(N'2025-04-21T00:00:00.0000000' AS DateTime2), 1, 2)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (56, N'Samuel Bell', N'samuel.bell@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'EN2025050', NULL, N'Member', CAST(N'2025-04-22T00:00:00.0000000' AS DateTime2), 1, 3)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (57, N'Avery Howard', N'avery.howard@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'PH2025051', NULL, N'Member', CAST(N'2025-04-23T00:00:00.0000000' AS DateTime2), 1, 4)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (58, N'Caleb Ward', N'caleb.ward@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'DB2025052', NULL, N'Member', CAST(N'2025-04-24T00:00:00.0000000' AS DateTime2), 1, 5)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (59, N'Harper Cox', N'harper.cox@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'MU2025053', NULL, N'Member', CAST(N'2025-04-25T00:00:00.0000000' AS DateTime2), 1, 6)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (60, N'Mason Diaz', N'mason.diaz@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'SP2025054', NULL, N'Member', CAST(N'2025-04-26T00:00:00.0000000' AS DateTime2), 1, 7)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (61, N'Layla Hayes', N'layla.hayes@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'LI2025055', NULL, N'Member', CAST(N'2025-04-27T00:00:00.0000000' AS DateTime2), 1, 8)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (62, N'Owen Reed', N'owen.reed@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'SC2025056', NULL, N'Member', CAST(N'2025-04-28T00:00:00.0000000' AS DateTime2), 1, 9)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (63, N'Brooklyn Bryant', N'brooklyn.bryant@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'CU2025057', NULL, N'Member', CAST(N'2025-04-29T00:00:00.0000000' AS DateTime2), 1, 10)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (64, N'Jason Phillips', N'jason.phillips@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'CS2025058', NULL, N'Member', CAST(N'2025-04-30T00:00:00.0000000' AS DateTime2), 1, 1)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (65, N'Victoria Russell', N'victoria.russell@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'DR2025059', NULL, N'Member', CAST(N'2025-05-01T00:00:00.0000000' AS DateTime2), 1, 2)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (66, N'Connor Griffin', N'connor.griffin@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'EN2025060', NULL, N'Member', CAST(N'2025-05-02T00:00:00.0000000' AS DateTime2), 1, 3)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (67, N'Jasmine Stevens', N'jasmine.stevens@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'PH2025061', NULL, N'Member', CAST(N'2025-05-03T00:00:00.0000000' AS DateTime2), 1, 4)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (68, N'Logan Foster', N'logan.foster@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'DB2025062', NULL, N'Member', CAST(N'2025-05-04T00:00:00.0000000' AS DateTime2), 1, 5)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (69, N'Alyssa Sanders', N'alyssa.sanders@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'MU2025063', NULL, N'Member', CAST(N'2025-05-05T00:00:00.0000000' AS DateTime2), 1, 6)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (70, N'Jonathan Jenkins', N'jonathan.jenkins@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'SP2025064', NULL, N'Member', CAST(N'2025-05-06T00:00:00.0000000' AS DateTime2), 1, 7)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (71, N'Madeline Perry', N'madeline.perry@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'LI2025065', NULL, N'Member', CAST(N'2025-05-07T00:00:00.0000000' AS DateTime2), 1, 8)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (72, N'Lucas Patterson', N'lucas.patterson@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'SC2025066', NULL, N'Member', CAST(N'2025-05-08T00:00:00.0000000' AS DateTime2), 1, 9)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (73, N'Kaitlyn Alexander', N'kaitlyn.alexander@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'CU2025067', NULL, N'Member', CAST(N'2025-05-09T00:00:00.0000000' AS DateTime2), 1, 10)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (74, N'Gabriel Long', N'gabriel.long@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'CS2025068', NULL, N'Member', CAST(N'2025-05-10T00:00:00.0000000' AS DateTime2), 1, 1)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (75, N'Katherine Shaw', N'katherine.shaw@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'DR2025069', NULL, N'Member', CAST(N'2025-05-11T00:00:00.0000000' AS DateTime2), 1, 2)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (76, N'Dylan Armstrong', N'dylan.armstrong@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'EN2025070', NULL, N'Member', CAST(N'2025-05-12T00:00:00.0000000' AS DateTime2), 1, 3)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (77, N'Hailey Lawrence', N'hailey.lawrence@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'PH2025071', NULL, N'Member', CAST(N'2025-05-13T00:00:00.0000000' AS DateTime2), 1, 4)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (78, N'Evan Webb', N'evan.webb@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'DB2025072', NULL, N'Member', CAST(N'2025-05-14T00:00:00.0000000' AS DateTime2), 1, 5)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (79, N'Anna Grant', N'anna.grant@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'MU2025073', NULL, N'Member', CAST(N'2025-05-15T00:00:00.0000000' AS DateTime2), 1, 6)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (80, N'Cameron Hicks', N'cameron.hicks@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'SP2025074', NULL, N'Member', CAST(N'2025-05-16T00:00:00.0000000' AS DateTime2), 1, 7)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (81, N'Julia Barrett', N'julia.barrett@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'LI2025075', NULL, N'Member', CAST(N'2025-05-17T00:00:00.0000000' AS DateTime2), 1, 8)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (82, N'Adam Douglas', N'adam.douglas@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'SC2025076', NULL, N'Member', CAST(N'2025-05-18T00:00:00.0000000' AS DateTime2), 1, 9)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (83, N'Rebecca Owens', N'rebecca.owens@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'CU2025077', NULL, N'Member', CAST(N'2025-05-19T00:00:00.0000000' AS DateTime2), 1, 10)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (84, N'Hunter Bryant', N'hunter.bryant@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'CS2025078', NULL, N'Member', CAST(N'2025-05-20T00:00:00.0000000' AS DateTime2), 1, 1)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (85, N'Sydney Henry', N'sydney.henry@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'DR2025079', NULL, N'Member', CAST(N'2025-05-21T00:00:00.0000000' AS DateTime2), 1, 2)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (86, N'Jack Warren', N'jack.warren@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'EN2025080', NULL, N'Member', CAST(N'2025-05-22T00:00:00.0000000' AS DateTime2), 1, 3)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (87, N'Paige Bishop', N'paige.bishop@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'PH2025081', NULL, N'Member', CAST(N'2025-05-23T00:00:00.0000000' AS DateTime2), 1, 4)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (88, N'Caleb Richards', N'caleb.richards@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'DB2025082', NULL, N'Member', CAST(N'2025-05-24T00:00:00.0000000' AS DateTime2), 1, 5)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (89, N'Gabriella Cunningham', N'gabriella.cunningham@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'MU2025083', NULL, N'Member', CAST(N'2025-05-25T00:00:00.0000000' AS DateTime2), 1, 6)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (90, N'Nathan Johnston', N'nathan.johnston@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'SP2025084', NULL, N'Member', CAST(N'2025-05-26T00:00:00.0000000' AS DateTime2), 1, 7)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (91, N'Savannah Watts', N'savannah.watts@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'LI2025085', NULL, N'Member', CAST(N'2025-05-27T00:00:00.0000000' AS DateTime2), 1, 8)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (92, N'Christian Wheeler', N'christian.wheeler@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'SC2025086', NULL, N'Member', CAST(N'2025-05-28T00:00:00.0000000' AS DateTime2), 1, 9)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (93, N'Brooklyn Ford', N'brooklyn.ford@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'CU2025087', NULL, N'Member', CAST(N'2025-05-29T00:00:00.0000000' AS DateTime2), 1, 10)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (94, N'Cole Mason', N'cole.mason@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'CS2025088', NULL, N'Member', CAST(N'2025-05-30T00:00:00.0000000' AS DateTime2), 1, 1)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (95, N'Morgan Hayes', N'morgan.hayes@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'DR2025089', NULL, N'Member', CAST(N'2025-05-31T00:00:00.0000000' AS DateTime2), 1, 2)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (96, N'Xavier Beck', N'xavier.beck@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'EN2025090', NULL, N'Member', CAST(N'2025-06-01T00:00:00.0000000' AS DateTime2), 1, 3)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (97, N'Leah Fleming', N'leah.fleming@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'PH2025091', NULL, N'Member', CAST(N'2025-06-02T00:00:00.0000000' AS DateTime2), 1, 4)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (98, N'Easton Dean', N'easton.dean@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'DB2025092', NULL, N'Member', CAST(N'2025-06-03T00:00:00.0000000' AS DateTime2), 1, 5)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (99, N'Bailey Goodwin', N'bailey.goodwin@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'MU2025093', NULL, N'Member', CAST(N'2025-06-04T00:00:00.0000000' AS DateTime2), 1, 6)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (100, N'Parker Kennedy', N'parker.kennedy@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'SP2025094', NULL, N'Member', CAST(N'2025-06-05T00:00:00.0000000' AS DateTime2), 1, 7)
GO
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (101, N'Stella Spencer', N'stella.spencer@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'LI2025095', NULL, N'Member', CAST(N'2025-06-06T00:00:00.0000000' AS DateTime2), 1, 8)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (102, N'Hudson Burke', N'hudson.burke@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'SC2025096', NULL, N'Member', CAST(N'2025-06-07T00:00:00.0000000' AS DateTime2), 1, 9)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (103, N'Allison Craig', N'allison.craig@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'CU2025097', NULL, N'Chairman', CAST(N'2025-06-08T00:00:00.0000000' AS DateTime2), 1, 10)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (104, N'Robert Pope', N'robert.pope@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'CS2025098', NULL, N'Member', CAST(N'2025-06-09T00:00:00.0000000' AS DateTime2), 1, 1)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (105, N'Elena Shepherd', N'elena.shepherd@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'DR2025099', NULL, N'Member', CAST(N'2025-06-10T00:00:00.0000000' AS DateTime2), 1, 2)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (106, N'Miles Payne', N'miles.payne@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'EN2025100', NULL, N'Member', CAST(N'2025-06-11T00:00:00.0000000' AS DateTime2), 1, 3)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (107, N'Rachel Osborne', N'rachel.osborne@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'PH2025101', NULL, N'Member', CAST(N'2025-06-12T00:00:00.0000000' AS DateTime2), 1, 4)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (108, N'Anthony Walters', N'anthony.walters@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'DB2025102', NULL, N'Member', CAST(N'2025-06-13T00:00:00.0000000' AS DateTime2), 1, 5)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (109, N'Claire Holland', N'claire.holland@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'MU2025103', NULL, N'Member', CAST(N'2025-06-14T00:00:00.0000000' AS DateTime2), 1, 6)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (110, N'Blake Franklin', N'blake.franklin@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'SP2025104', NULL, N'Member', CAST(N'2025-06-15T00:00:00.0000000' AS DateTime2), 1, 7)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (111, N'Isabelle Sutton', N'isabelle.sutton@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'LI2025105', NULL, N'Member', CAST(N'2025-06-16T00:00:00.0000000' AS DateTime2), 1, 8)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (112, N'Carson Cross', N'carson.cross@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'SC2025106', NULL, N'Member', CAST(N'2025-06-17T00:00:00.0000000' AS DateTime2), 1, 9)
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [Password], [StudentID], [PhoneNumber], [Role], [JoinDate], [IsActive], [ClubID]) VALUES (113, N'Lila Marsh', N'lila.marsh@student.edu', N'JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=', N'CU2025107', NULL, N'Member', CAST(N'2025-06-18T00:00:00.0000000' AS DateTime2), 1, 10)
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Clubs_Name]    Script Date: 7/22/2025 8:50:09 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Clubs_Name] ON [dbo].[Clubs]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_EventParticipants_UserID_EventID]    Script Date: 7/22/2025 8:50:09 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_EventParticipants_UserID_EventID] ON [dbo].[EventParticipants]
(
	[UserID] ASC,
	[EventID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Users_Email]    Script Date: 7/22/2025 8:50:09 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users_Email] ON [dbo].[Users]
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Clubs] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Clubs] ADD  DEFAULT ((0)) FOR [IsSelected]
GO
ALTER TABLE [dbo].[Clubs] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[EventParticipants] ADD  DEFAULT ('Registered') FOR [Status]
GO
ALTER TABLE [dbo].[EventParticipants] ADD  DEFAULT (getdate()) FOR [RegistrationDate]
GO
ALTER TABLE [dbo].[Events] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Events] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Events] ADD  DEFAULT ('Scheduled') FOR [Status]
GO
ALTER TABLE [dbo].[Reports] ADD  DEFAULT (getdate()) FOR [GeneratedDate]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [JoinDate]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[EventParticipants]  WITH CHECK ADD FOREIGN KEY([EventID])
REFERENCES [dbo].[Events] ([EventID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EventParticipants]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Events]  WITH CHECK ADD FOREIGN KEY([ClubID])
REFERENCES [dbo].[Clubs] ([ClubID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Reports]  WITH CHECK ADD FOREIGN KEY([ClubID])
REFERENCES [dbo].[Clubs] ([ClubID])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Reports]  WITH CHECK ADD FOREIGN KEY([GeneratedByUserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD FOREIGN KEY([ClubID])
REFERENCES [dbo].[Clubs] ([ClubID])
ON DELETE SET NULL
GO
USE [master]
GO
ALTER DATABASE [ClubManagementDB] SET  READ_WRITE 
GO
