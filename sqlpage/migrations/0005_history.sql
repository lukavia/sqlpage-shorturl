CREATE TABLE history(
    ID INTEGER PRIMARY KEY,
    AT timestamp DEFAULT current_timestamp,
    BY TEXT NOT NULL,
    action TEXT CHECK( action IN ('create','update','delete') ),
    path TEXT NOT NULL,
    url TEXT NOT NULL DEFAULT ''
)