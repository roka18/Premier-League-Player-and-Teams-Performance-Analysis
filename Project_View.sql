-- ============================================
-- MASTER VIEW - Contains ALL KPIs (Players + Teams)
-- All columns have unique names
-- ============================================

CREATE OR ALTER VIEW vw_Football_Master_All_Data AS
SELECT 
    -- Player Information
    p.PlayerName,
    p.Team,
    p.Matches as Player_Matches,
    p.MinutesPlayed as Player_MinutesPlayed,
    
    -- Player Attack KPIs
    p.Goals as Player_Goals,
    p.Assists as Player_Assists,
    p.Goal_Contribution as Player_Goal_Contribution,
    p.Goals_per_Match as Player_Goals_per_Match,
    p.Goals_per_90 as Player_Goals_per_90,
    p.Shots as Player_Shots,
    p.Shot_Conversion as Player_Shot_Conversion,
    p.xG as Player_xG,
    p.xG_Efficiency as Player_xG_Efficiency,
    p.Finishing_Efficiency as Player_Finishing_Efficiency,
    p.Goal_Consistency as Player_Goal_Consistency,
    p.GC_per_Match as Player_GC_per_Match,
    p.GC_per_90 as Player_GC_per_90,
    p.Goal_Participation as Player_Goal_Participation,
    p.Finishing_Intelligence as Player_Finishing_Intelligence,
    p.Shooting_Impact as Player_Shooting_Impact,
    
    -- Player Creativity KPIs
    p.KeyPasses as Player_KeyPasses,
    p.KeyPasses_per_90 as Player_KeyPasses_per_90,
    p.Assist_Efficiency as Player_Assist_Efficiency,
    p.Dribbles as Player_Dribbles,
    p.Dribbles_per_Match as Player_Dribbles_per_Match,
    p.Chance_Creation_Index as Player_Chance_Creation_Index,
    p.Creativity_Efficiency as Player_Creativity_Efficiency,
    p.Creative_Consistency as Player_Creative_Consistency,
    p.Creative_Impact_B as Player_Creative_Impact_B,
    p.Playmaking_Load as Player_Playmaking_Load,
    p.Dribble_Impact as Player_Dribble_Impact,
    
    -- Player Defensive KPIs
    p.Tackles as Player_Tackles,
    p.Tackles_per_Match as Player_Tackles_per_Match,
    p.Interceptions as Player_Interceptions,
    p.Clearances as Player_Clearances,
    p.Defensive_Actions as Player_Defensive_Actions,
    p.Def_Actions_per_90 as Player_Def_Actions_per_90,
    p.Defensive_Impact_F as Player_Defensive_Impact_F,
    p.Defensive_Activity as Player_Defensive_Activity,
    p.Clean_Defense_Index as Player_Clean_Defense_Index,
    p.Aggression_Control_G as Player_Aggression_Control_G,
    p.Def_Discipline as Player_Def_Discipline,
    
    -- Player Discipline KPIs
    p.FoulsCommitted as Player_FoulsCommitted,
    p.YellowCards as Player_YellowCards,
    p.RedCards as Player_RedCards,
    p.Card_Rate as Player_Card_Rate,
    p.Discipline_Score as Player_Discipline_Score,
    p.Fouls_to_Cards as Player_Fouls_to_Cards,
    p.Clean_Play as Player_Clean_Play,
    
    -- Player Playing Time KPIs
    p.Usage_Rate as Player_Usage_Rate,
    p.Match_Involvement as Player_Match_Involvement,
    p.Playing_Consistency as Player_Playing_Consistency,
    p.Availability_Score as Player_Availability_Score,
    
    -- Player Overall Performance
    p.Avg_Rating as Player_Avg_Rating,
    p.Performance_Index as Player_Performance_Index,
    p.Overall_Contribution as Player_Overall_Contribution,
    p.Star_Index as Player_Star_Index,
    p.Balanced_Performance as Player_Balanced_Performance,
    
    -- Team Attack KPIs
    t.Matches_Played as Team_Matches_Played,
    t.Unique_Players as Team_Unique_Players,
    t.Goals as Team_Goals,
    t.Assists as Team_Assists,
    t.Team_Goal_Contribution as Team_Goal_Contribution,
    t.Shots as Team_Shots,
    t.Team_Shot_Efficiency as Team_Shot_Efficiency,
    t.Avg_Goals_per_Player as Team_Avg_Goals_per_Player,
    t.Team_Goals_per_Match as Team_Goals_per_Match,
    t.Team_Assists_per_Match as Team_Assists_per_Match,
    
    -- Team Creativity KPIs
    t.KeyPasses as Team_KeyPasses,
    t.KeyPasses_per_Match as Team_KeyPasses_per_Match,
    t.Avg_KeyPasses_per_Player as Team_Avg_KeyPasses_per_Player,
    t.Dribbles as Team_Dribbles,
    t.Dribbles_per_Match as Team_Dribbles_per_Match,
    t.Avg_Dribbles_per_Player as Team_Avg_Dribbles_per_Player,
    t.Creativity_Index as Team_Creativity_Index,
    
    -- Team Passing KPIs
    t.Avg_Pass_Accuracy as Team_Avg_Pass_Accuracy,
    t.Pass_Accuracy_Std as Team_Pass_Accuracy_Std,
    t.Passing_Consistency_Index as Team_Passing_Consistency_Index,
    t.Passing_Volume as Team_Passing_Volume,
    
    -- Team Defensive KPIs
    t.Tackles as Team_Tackles,
    t.Tackles_per_Match as Team_Tackles_per_Match,
    t.Interceptions as Team_Interceptions,
    t.Interceptions_per_Match as Team_Interceptions_per_Match,
    t.Clearances as Team_Clearances,
    t.Clearances_per_Match as Team_Clearances_per_Match,
    t.Total_Defensive_Actions as Team_Total_Defensive_Actions,
    t.Def_Actions_per_Match as Team_Def_Actions_per_Match,
    t.Def_Actions_per_Player as Team_Def_Actions_per_Player,
    t.Defensive_Impact as Team_Defensive_Impact,
    
    -- Team Discipline KPIs
    t.FoulsCommitted as Team_FoulsCommitted,
    t.Fouls_per_Match as Team_Fouls_per_Match,
    t.YellowCards as Team_YellowCards,
    t.Yellow_per_Match as Team_Yellow_per_Match,
    t.RedCards as Team_RedCards,
    t.Red_per_Match as Team_Red_per_Match,
    t.Team_Card_Rate as Team_Card_Rate,
    t.Team_Discipline_Score as Team_Discipline_Score,
    t.Clean_Play_Index as Team_Clean_Play_Index,
    
    -- Team Overall Performance
    t.Avg_Team_Rating as Team_Avg_Rating,
    t.Team_Impact_Score as Team_Impact_Score,
    t.Team_Contribution_Index as Team_Contribution_Index,
    t.Team_Performance_per_Match as Team_Performance_per_Match,
    t.Star_Team_Index as Team_Star_Index,
    t.Balanced_Team_Score as Team_Balanced_Score

FROM PlayerStats p
LEFT JOIN TeamStats t ON p.Team = t.Team;
GO

-- ============================================
-- VERIFY: Check if view was created successfully
-- ============================================

SELECT 
    COUNT(*) as Total_Columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'vw_Football_Master_All_Data';
GO

-- ============================================
-- VIEW: Sample data from Master View
-- ============================================

SELECT TOP 5
    PlayerName,
    Team,
    Player_Goals,
    Player_Assists,
    Player_Avg_Rating,
    Team_Goals,
    Team_Assists,
    Team_Avg_Rating
FROM vw_Football_Master_All_Data
ORDER BY Player_Goal_Contribution DESC;
GO

-- ============================================
-- VIEW: List all columns in Master View
-- ============================================

SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'vw_Football_Master_All_Data'
ORDER BY ORDINAL_POSITION;
GO

-- ============================================
-- SUCCESS MESSAGE (FIXED)
-- ============================================

DECLARE @ColumnCount INT;
SELECT @ColumnCount = COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'vw_Football_Master_All_Data';

PRINT '============================================';
PRINT 'vw_Football_Master_All_Data created successfully!';
PRINT '============================================';
PRINT 'Total columns: ' + CAST(@ColumnCount AS VARCHAR);
PRINT 'All KPIs are ready for Power BI';
PRINT '============================================';
GO