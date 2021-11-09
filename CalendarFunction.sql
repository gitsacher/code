ALTER FUNCTION dev.GetEasterHolidays(@TheYear INT) 
--CREATE FUNCTION dev.GetEasterHolidays(@TheYear INT) 
RETURNS TABLE
WITH SCHEMABINDING
AS 
RETURN 
(
  WITH x AS 
  (
    SELECT TheDate = DATEFROMPARTS(@TheYear, [Month], [Day])
      FROM (SELECT [Month], [Day] = DaysToSunday + 28 - (31 * ([Month] / 4))
      FROM (SELECT [Month] = 3 + (DaysToSunday + 40) / 44, DaysToSunday
      FROM (SELECT DaysToSunday = paschal - ((@TheYear + (@TheYear / 4) + paschal - 13) % 7)
      FROM (SELECT paschal = epact - (epact / 28)
      FROM (SELECT epact = (24 + 19 * (@TheYear % 19)) % 30) 
        AS epact) AS paschal) AS dts) AS m) AS d
  )
  SELECT TheDate, HolidayText = 'Easter Sunday', Feiertag = 'Ostersonntag' FROM x
    UNION ALL SELECT DATEADD(DAY, -2, TheDate), 'Good Friday' , 'Karfreitag'   FROM x
    UNION ALL SELECT DATEADD(DAY,  1, TheDate), 'Easter Monday', 'Ostermontag' FROM x
    UNION ALL SELECT DATEADD(DAY,  39, TheDate), 'Ascension Day', 'Christi Himmelfahrt' FROM x
    UNION ALL SELECT DATEADD(DAY,  49, TheDate), 'Whit Sunday', 'Pfingstsonntag' FROM x
    UNION ALL SELECT DATEADD(DAY,  50, TheDate), 'Whit Monday', 'Pfingstmontag' FROM x
    UNION ALL SELECT DATEADD(DAY,  60, TheDate), 'Corpus Christi', 'Fronleichnam' FROM x
    UNION ALL SELECT DATEFROMPARTS(@TheYear, 1, 1), 'New Years Day', 'Neujahr' FROM x 
    UNION ALL SELECT DATEFROMPARTS(@TheYear, 1, 6), '3 Kings Day', 'Heilige Dreikönig' FROM x 
    UNION ALL SELECT DATEFROMPARTS(@TheYear, 5, 1), 'May Day', 'Maitag' FROM x 
    UNION ALL SELECT DATEFROMPARTS(@TheYear, 10, 3), 'German Unity Day', 'Tag der deutschen Einheit' FROM x 
    UNION ALL SELECT DATEFROMPARTS(@TheYear, 11, 1), 'All Saints Day', 'Allerheiligen' FROM x 
    UNION ALL SELECT DATEFROMPARTS(@TheYear, 12, 24), 'Christmas Eve', 'Heiligabend' FROM x 
    UNION ALL SELECT DATEFROMPARTS(@TheYear, 12, 25), 'Christmas Day', 'Erster Weihnachtsfeiertag' FROM x 
    UNION ALL SELECT DATEFROMPARTS(@TheYear, 12, 26), 'Boxing Day', 'Zweiter Weihnachtsfeiertag' FROM x
    UNION ALL SELECT DATEFROMPARTS(@TheYear, 12, 31), 'New Years Eve', 'Silvester' FROM x

);
GO
