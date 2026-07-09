-- =========================================
-- EPL Team KPIs SQL Script
-- Database: KPI_TEAM
-- Author: Youssef
-- =========================================

USE [KPI_TEAM];
GO


-- =========================================
DROP TABLE IF EXISTS dbo.team_kpis;
DROP TABLE IF EXISTS dbo.epl_performance;
DROP TABLE IF EXISTS dbo.epl_performance_raw;
GO


-- =========================================
CREATE TABLE dbo.epl_performance_raw (
    PlayerID NVARCHAR(50),
    PlayerName NVARCHAR(100),
    Team NVARCHAR(100),
    Position NVARCHAR(50),
    MatchDate NVARCHAR(50),
    Opponent NVARCHAR(100),
    MinutesPlayed NVARCHAR(50),
    Goals NVARCHAR(50),
    Assists NVARCHAR(50),
    Shots NVARCHAR(50),
    xG NVARCHAR(50),
    xA NVARCHAR(50),
    KeyPasses NVARCHAR(50),
    Dribbles NVARCHAR(50),
    PassAccuracy NVARCHAR(50),
    Tackles NVARCHAR(50),
    Interceptions NVARCHAR(50),
    Clearances NVARCHAR(50),
    FoulsCommitted NVARCHAR(50),
    YellowCards NVARCHAR(50),
    RedCards NVARCHAR(50),
    Rating NVARCHAR(50)
);
GO


-- =========================================
BULK INSERT dbo.epl_performance_raw
FROM 'C:\Users\Youssef\Downloads\epl_performance.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO


-- =========================================
CREATE TABLE dbo.epl_performance (
    PlayerID INT,
    PlayerName NVARCHAR(100),
    Team NVARCHAR(100),
    Position NVARCHAR(50),
    MatchDate DATE,
    Opponent NVARCHAR(100),
    MinutesPlayed INT,
    Goals INT,
    Assists INT,
    Shots INT,
    xG FLOAT,
    xA FLOAT,
    KeyPasses INT,
    Dribbles INT,
    PassAccuracy FLOAT,
    Tackles INT,
    Interceptions INT,
    Clearances INT,
    FoulsCommitted INT,
    YellowCards INT,
    RedCards INT,
    Rating FLOAT
);
GO


-- =========================================
INSERT INTO dbo.epl_performance
SELECT
    TRY_CONVERT(INT, PlayerID),
    PlayerName,
    Team,
    Position,
    TRY_CONVERT(DATE, MatchDate),
    Opponent,
    TRY_CONVERT(INT, MinutesPlayed),
    TRY_CONVERT(INT, Goals),
    TRY_CONVERT(INT, Assists),
    TRY_CONVERT(INT, Shots),
    TRY_CONVERT(FLOAT, xG),
    TRY_CONVERT(FLOAT, xA),
    TRY_CONVERT(INT, KeyPasses),
    TRY_CONVERT(INT, Dribbles),
    TRY_CONVERT(FLOAT, PassAccuracy),
    TRY_CONVERT(INT, Tackles),
    TRY_CONVERT(INT, Interceptions),
    TRY_CONVERT(INT, Clearances),
    TRY_CONVERT(INT, FoulsCommitted),
    TRY_CONVERT(INT, YellowCards),
    TRY_CONVERT(INT, RedCards),
    TRY_CONVERT(FLOAT, Rating)
FROM dbo.epl_performance_raw;
GO


-- =========================================
SELECT 
    Team,
    COUNT(*) AS Matches,
    SUM(Goals) AS TotalGoals,
    SUM(Assists) AS TotalAssists,
    SUM(Shots) AS TotalShots,

    CAST(SUM(Goals) * 1.0 / NULLIF(SUM(Shots),0) AS DECIMAL(10,2)) AS ConversionRate,
    CAST(SUM(Goals) * 1.0 / NULLIF(SUM(xG),0) AS DECIMAL(10,2)) AS xG_Efficiency,

    SUM(KeyPasses) AS ChanceCreation,
    SUM(Tackles + Interceptions + Clearances) AS DefensiveActions,

    CAST((SUM(Goals) + SUM(Assists)) * 1.0 / COUNT(*) AS DECIMAL(10,2)) AS ContributionPerMatch

INTO dbo.team_kpis
FROM dbo.epl_performance
GROUP BY Team;
GO


-- =========================================
ALTER TABLE dbo.team_kpis
ADD DefensiveIntensity FLOAT,
    Overperformance FLOAT,
    TeamScore FLOAT;
GO


-- =========================================
UPDATE dbo.team_kpis
SET 
    DefensiveIntensity = DefensiveActions * 1.0 / Matches,

    Overperformance = TotalGoals - (TotalGoals / xG_Efficiency),

    TeamScore = 
        ContributionPerMatch 
        + xG_Efficiency 
        + ConversionRate 
        + (DefensiveActions * 1.0 / Matches);
GO


-- =========================================
SELECT 
    Team,
    TotalGoals,
    CAST(xG_Efficiency AS DECIMAL(10,2)) AS xG_Efficiency,
    CAST(ConversionRate AS DECIMAL(10,2)) AS ConversionRate,
    CAST(DefensiveIntensity AS DECIMAL(10,2)) AS DefensiveIntensity,
    CAST(Overperformance AS DECIMAL(10,2)) AS Overperformance,
    CAST(TeamScore AS DECIMAL(10,2)) AS TeamScore,

    RANK() OVER (ORDER BY TotalGoals DESC) AS GoalRank,
    RANK() OVER (ORDER BY xG_Efficiency DESC) AS EfficiencyRank,
    RANK() OVER (ORDER BY ConversionRate DESC) AS ConversionRank

FROM dbo.team_kpis
ORDER BY TeamScore DESC;
GO