CREATE TABLE setcode_tbl (
	setcode integer,
	hex_setcode text,
	lists text
);
INSERT INTO setcode_tbl (setcode, lists)
WITH tmp1 AS (SELECT id, setcode, name FROM
	(SELECT setcode, id FROM datas WHERE setcode != 0 ORDER BY id ASC)
LEFT JOIN
	(SELECT id as temp, name FROM texts)
ON id = temp)
SELECT setcode, lists FROM
(SELECT setcode, order_setcode, GROUP_CONCAT(id||' ('||name||')','
') as lists FROM
	(SELECT id, (setcode1 % 4096) * 16 + ((setcode1 - (setcode1 % 4096)) / 4096) AS order_setcode, setcode1 AS setcode, name FROM
		(SELECT id, setcode % 65536 AS setcode1, name FROM tmp1 WHERE setcode1 != 0
		UNION SELECT id, ((setcode - (setcode % 65536)) / 65536) % 65536 AS setcode2, name FROM tmp1 WHERE setcode2 != 0
		UNION SELECT id, ((setcode - (setcode % 4294967296)) / 4294967296) % 65536 AS setcode3, name FROM tmp1 WHERE setcode3 != 0
		UNION SELECT id, (setcode - (setcode % 281474976710656)) / 281474976710656 AS setcode4, name FROM tmp1 WHERE setcode4 != 0
		ORDER BY setcode1 ASC, id ASC)
	ORDER BY order_setcode ASC, id ASC)
GROUP BY setcode ORDER BY order_setcode ASC);
UPDATE setcode_tbl
SET hex_setcode = '0x'||iif(setcode<4096,'',iif(setcode<40960,(setcode-(setcode%4096))/4096,CHAR((setcode-(setcode%4096))/4096+87)))
	||iif(setcode<256,'',iif(setcode%4096<2560,((setcode%4096)-(setcode%256))/256,CHAR(((setcode%4096)-(setcode%256))/256+87)))
	||iif(setcode<16,'',iif(setcode%256<160,((setcode%256)-(setcode%16))/16,CHAR(((setcode%256)-(setcode%16))/16+87)))
	||iif(setcode%16<10,setcode%16,CHAR((setcode%16)+87));
DROP TABLE datas;
DROP TABLE texts;
VACUUM;
