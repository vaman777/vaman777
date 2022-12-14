USE [DBA]
GO
--https://docs.microsoft.com/en-us/sql/relational-databases/backup-restore/manage-the-suspect-pages-table-sql-server?view=sql-server-2017
DROP TABLE IF EXISTS [dbo].[suspect_pages]
GO

/****** Object:  Table [dbo].[suspect_pages]    Script Date: 3/12/2019 10:15:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[suspect_pages]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[suspect_pages](
	[ServerName] [varchar](128) NOT NULL,
	[DatabaseName] [varchar](128) NOT NULL,
	[database_id] [int] NOT NULL,
	[file_id] [int] NOT NULL,
	[page_id] [bigint] NOT NULL,
	[event_type] [int] NOT NULL,
	[error_count] [int] NOT NULL,
	[last_update_date] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo_suspect_pages] PRIMARY KEY CLUSTERED 
(
	[DatabaseName] ASC,
	[page_id] ASC,
	[last_update_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
END
GO

---TEST VALUES
--INSERT INTO dbo.suspect_pages (ServerName, DatabaseName, database_id, file_id, page_id, event_type, error_count, last_update_date)
--values (@@SERVERNAME, 'Demographics',39, 1,1111, 1, 1, GETDATE())

USE msdb;
GO

-- Select nonspecific 824, bad checksum, and torn page errors.  
SELECT	@@SERVERNAME AS ServerName
	, d.name AS DatabaseName
	, sp.*
FROM	dbo.suspect_pages AS sp
	INNER JOIN sys.databases AS d ON sp.database_id = d.database_id
WHERE	event_type IN (1,2,3);
GO


