--ruleid 21 ERROR: age > 150  (TODO lower number seems more appropriate)

--HINT DISTRIBUTE_ON_KEY(analysis_id)
select
	analysis_id,
	ACHILLES_HEEL_warning,
	rule_id,
	record_count
	into @scratchDatabaseSchema@schemaDelim@tempHeelPrefix_@heelName
from
(
  SELECT or1.analysis_id,
  	CAST(CONCAT('ERROR: ', cast(or1.analysis_id as VARCHAR(10)), '-', oa1.analysis_name, '; should not have age > 150, (n=', cast(sum(or1.count_value) as VARCHAR(19)), ')') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
    21 as rule_id,
    sum(or1.count_value) as record_count
  FROM @resultsDatabaseSchema.achilles_results or1
  INNER JOIN @resultsDatabaseSchema.ACHILLES_analysis oa1
  	ON or1.analysis_id = oa1.analysis_id
  WHERE or1.analysis_id IN (101)
  	AND CAST(or1.stratum_1 AS INT) > 150
  	AND or1.count_value > 0
  GROUP BY or1.analysis_id,
    oa1.analysis_name
) A;
