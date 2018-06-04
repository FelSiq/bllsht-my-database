# How to use
Just run bllshtMyDatabase.py, giving a .sql as first argument containing all the CREATE TABLE commands. You may also give a optional parameter, choosing how many instances of each table must be created.
```
python bllshtMyDatabase.py <.sql with all CREATE TABLE> [Number of instances for each table]
```

# Configuration and customization
You may easily change script parameters just changing values inside the ``scriptConfig'' class inside bllshtMyDatabase.py file.

# Output
Check out sample.sql to get a idea of the program output.

# Important
Every table with SERIAL or BIGSERIAL column types must be brand-new (i.e. the autoincrementing counter must be currently on 1) in order to FOREIGN KEYS pointing to SERIAL/BIGSERIAL columns work.
