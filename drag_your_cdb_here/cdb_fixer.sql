DELETE FROM datas WHERE
	(ot IS NULL) OR
	(alias IS NULL) OR
	(setcode IS NULL) OR
	(type IS NULL) OR
	(atk IS NULL) OR
	(def IS NULL) OR
	(level IS NULL) OR
	(race IS NULL) OR
	(attribute IS NULL) OR
	(category IS NULL);
UPDATE datas SET setcode = setcode + 4294967296
	WHERE setcode BETWEEN -2147483648 AND -1;
UPDATE datas SET race = race + 4294967296
	WHERE race BETWEEN -2147483648 AND -1;
UPDATE datas SET category = category - 4294967296
	WHERE category BETWEEN 2147483648 AND 4294967295;
UPDATE texts SET name = IFNULL(name, '') where name IS NULL;
UPDATE texts SET desc = IFNULL(desc, '') where desc IS NULL;
UPDATE texts SET str1 = IFNULL(str1, '') where str1 IS NULL;
UPDATE texts SET str2 = IFNULL(str2, '') where str2 IS NULL;
UPDATE texts SET str3 = IFNULL(str3, '') where str3 IS NULL;
UPDATE texts SET str4 = IFNULL(str4, '') where str4 IS NULL;
UPDATE texts SET str5 = IFNULL(str5, '') where str5 IS NULL;
UPDATE texts SET str6 = IFNULL(str6, '') where str6 IS NULL;
UPDATE texts SET str7 = IFNULL(str7, '') where str7 IS NULL;
UPDATE texts SET str8 = IFNULL(str8, '') where str8 IS NULL;
UPDATE texts SET str9 = IFNULL(str9, '') where str9 IS NULL;
UPDATE texts SET str10 = IFNULL(str10, '') where str10 IS NULL;
UPDATE texts SET str11 = IFNULL(str11, '') where str11 IS NULL;
UPDATE texts SET str12 = IFNULL(str12, '') where str12 IS NULL;
UPDATE texts SET str13 = IFNULL(str13, '') where str13 IS NULL;
UPDATE texts SET str14 = IFNULL(str14, '') where str14 IS NULL;
UPDATE texts SET str15 = IFNULL(str15, '') where str15 IS NULL;
UPDATE texts SET str16 = IFNULL(str16, '') where str16 IS NULL;
VACUUM;
