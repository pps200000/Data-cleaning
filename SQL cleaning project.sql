select * from club_member_info;
use club_member_info;
select * from club_member_info_2;
create table clean3_club_member_info as
(
SELECT 
    Member_id,
    
    -- Extracting the first name
    TRIM(REGEXP_REPLACE(LOWER(SUBSTRING_INDEX(full_name, ' ', 1)), '[^a-zA-Z0-9]+', ' ')) AS first_name,
    
    -- Extracting the last name
    CASE 
        WHEN LENGTH(TRIM(LOWER(full_name))) - LENGTH(REPLACE(TRIM(LOWER(full_name)), ' ', '')) + 1 = 3 
            THEN CONCAT(SUBSTRING_INDEX(TRIM(LOWER(full_name)), ' ', -2)) 
        WHEN LENGTH(TRIM(LOWER(full_name))) - LENGTH(REPLACE(TRIM(LOWER(full_name)), ' ', '')) + 1 = 4 
            THEN CONCAT(SUBSTRING_INDEX(TRIM(LOWER(full_name)), ' ', -3)) 
        ELSE 
            SUBSTRING_INDEX(TRIM(LOWER(full_name)), ' ', -1)
    END AS Last_name,
    
    -- Age transformation
    CASE 
        WHEN LENGTH(CAST(age AS CHAR)) = 0 THEN NULL 
        WHEN LENGTH(CAST(age AS CHAR)) = 3 THEN SUBSTRING_INDEX(CAST(age AS CHAR), '', 2) 
        ELSE age 
    END AS age,

    -- Marital status correction
    CASE 
        WHEN TRIM(martial_status) = '' THEN NULL 
        ELSE TRIM(martial_status) 
    END AS martial_status,
    
    -- Email transformation
    TRIM(LOWER(email)) AS member_mail,
    
    -- Phone number transformation
    CASE 
        WHEN TRIM(phone) = '' THEN NULL 
        WHEN LENGTH(TRIM(phone)) < 12 THEN NULL 
        ELSE TRIM(phone) 
    END AS phone,
    
    -- Street address extraction
    TRIM(LOWER(SUBSTRING_INDEX(full_address, ',', 1))) AS Street_address,
    
    -- City extraction
    TRIM(LOWER(SUBSTRING_INDEX(SUBSTRING_INDEX(full_address, ',', 2), ',', -1))) AS city,
    
    -- State extraction
    TRIM(LOWER(SUBSTRING_INDEX(full_address, ',', -1))) AS state,
    
    -- Job title modification
    CASE 
        WHEN TRIM(LOWER(job_title)) = '' THEN NULL 
        ELSE 
            CASE 
                WHEN LENGTH(TRIM(job_title)) - LENGTH(REPLACE(TRIM(job_title), ' ', '')) > 0 
                    AND LOWER(TRIM(SUBSTRING_INDEX(TRIM(job_title), ' ', -1))) = 'i' 
                    THEN REPLACE(LOWER(job_title), ' i', ', level 1')
                
                WHEN LENGTH(TRIM(job_title)) - LENGTH(REPLACE(TRIM(job_title), ' ', '')) > 0 
                    AND LOWER(TRIM(SUBSTRING_INDEX(TRIM(job_title), ' ', -1))) = 'ii' 
                    THEN REPLACE(LOWER(job_title), ' ii', ', level 2')
                
                WHEN LENGTH(TRIM(job_title)) - LENGTH(REPLACE(TRIM(job_title), ' ', '')) > 0 
                    AND LOWER(TRIM(SUBSTRING_INDEX(TRIM(job_title), ' ', -1))) = 'iii' 
                    THEN REPLACE(LOWER(job_title), ' iii', ', level 3')
                
                WHEN LENGTH(TRIM(job_title)) - LENGTH(REPLACE(TRIM(job_title), ' ', '')) > 0 
                    AND LOWER(TRIM(SUBSTRING_INDEX(TRIM(job_title), ' ', -1))) = 'iv' 
                    THEN REPLACE(LOWER(job_title), ' iv', ', level 4')
                ELSE LOWER(job_title)
            END
    END AS job_title_modified,

    -- Membership date correction
CASE 
    WHEN YEAR(STR_TO_DATE(membership_date, '%m/%d/%Y')) < 2000 
        THEN DATE(CONCAT(REPLACE(YEAR(STR_TO_DATE(membership_date, '%m/%d/%Y')), '19', '20'), '-', 
                        LPAD(MONTH(STR_TO_DATE(membership_date, '%m/%d/%Y')), 2, '0'), '-', 
                        LPAD(DAY(STR_TO_DATE(membership_date, '%m/%d/%Y')), 2, '0')))
    ELSE STR_TO_DATE(membership_date, '%m/%d/%Y')
END AS membership_date


FROM 
    club_member_info_2
    );
    select * from clean3_club_member_info;
    SELECT 
	*
FROM clean3_club_member_info
LIMIT 10;
select member_mail,
count(member_mail)
from clean3_club_member_info
group by member_mail
having count(member_mail) > 1;

WITH CTE AS (
    SELECT 
        Member_id,
        member_mail,
        ROW_NUMBER() OVER(PARTITION BY member_mail ORDER BY Member_id) AS row_num
    FROM clean3_club_member_info
)
DELETE FROM clean3_club_member_info
WHERE Member_id IN (
    SELECT Member_id
    FROM CTE
    WHERE row_num > 1
);
With cte as
(
select Member_id,
member_mail,
row_number() over (partition by member_mail order by Member_id) as row_num
from clean3_club_member_info
)
DELETE FROM clean3_club_member_info
WHERE Member_id IN (
select Member_id 
from cte where 
row_num > 1);
select count(Member_id)
from clean3_club_member_info
group by member_mail 
having count(Member_id) >1;
select count(*) from 
clean3_club_member_info 
where martial_status is Null;
SELECT martial_status,
count(martial_status)
from clean3_club_member_info
group by 
martial_status;
UPDATE 
clean3_club_member_info
SET 
martial_status = 'divorced'
where martial_status = 'divored';
SELECT martial_status,
count(*)
from clean3_club_member_info
group by 
martial_status;
SELECT 
	state
FROM 
	clean3_club_member_info
GROUP BY 
	state;
UPDATE
	clean3_club_member_info
SET 
	state = 'kansas'
WHERE 
	state = 'kansus';

UPDATE
	clean3_club_member_info
SET 
	state = 'district of columbia'
WHERE 
	state = 'districts of columbia';

UPDATE
	clean3_club_member_info
SET 
	state = 'north carolina'
WHERE 
	state = 'northcarolina';

UPDATE
	clean3_club_member_info
SET 
	state = 'california'
WHERE 
	state = 'kalifornia';

UPDATE
	clean3_club_member_info
SET 
	state = 'texas'
WHERE 
	state = 'tejas';

UPDATE
	clean3_club_member_info
SET 
	state = 'texas'
WHERE 
	state = 'tej+f823as';

UPDATE
	clean3_club_member_info
SET 
	state = 'tennessee'
WHERE 
	state = 'tennesseeee';

UPDATE
	clean3_club_member_info
SET 
	state = 'new york'
WHERE 
	state = 'newyork';

UPDATE
	clean3_club_member_info
SET 
	state = 'puerto rico'
WHERE 
	state = ' puerto rico';

SELECT
	count(DISTINCT state)
FROM 
	clean3_club_member_info
	




 