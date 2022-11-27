UPDATE datas SET ot = (ot - 4) | 32 WHERE ot & 4 = 4;
VACUUM;
