# SQLite Compile Flags

This document explains the SQLite compile-time options used in this project.

## Enabled Features

### SQLITE_THREADSAFE=1
Enables full thread-safety with serialized mode as default. SQLite will be safe to use in multi-threaded applications.

**Documentation**: https://www.sqlite.org/threadsafe.html

### SQLITE_ENABLE_FTS5
Enables the FTS5 full-text search extension. FTS5 is the latest and most advanced full-text search module in SQLite, featuring:
- BM25 ranking algorithm
- Phrase queries
- NEAR queries
- Boolean operators (AND, OR, NOT)
- Column filters
- Custom tokenizers

**Documentation**: https://www.sqlite.org/fts5.html

### SQLITE_ENABLE_JSON1
Enables JSON functions and operators, including:
- `json()` - Validate and minify JSON
- `json_array()` - Create JSON arrays
- `json_object()` - Create JSON objects
- `json_extract()` - Extract values from JSON
- `json_insert()`, `json_replace()`, `json_set()` - Modify JSON
- `json_each()`, `json_tree()` - Parse JSON into table format

**Documentation**: https://www.sqlite.org/json1.html

### SQLITE_ENABLE_RTREE
Enables the R*Tree index extension for efficient range queries on multi-dimensional data. Useful for:
- Geographic information systems (GIS)
- Bounding box queries
- Spatial indexing
- Game development (collision detection)

**Documentation**: https://www.sqlite.org/rtree.html

### SQLITE_ENABLE_GEOPOLY
Enables the Geopoly extension for geographic polygon queries. Extends R-Tree with:
- Geographic polygon storage
- Point-in-polygon tests
- Polygon overlap detection
- Area calculations

**Documentation**: https://www.sqlite.org/geopoly.html

### SQLITE_ENABLE_MATH_FUNCTIONS
Enables additional mathematical functions:
- Trigonometric: `acos()`, `asin()`, `atan()`, `atan2()`, `cos()`, `sin()`, `tan()`
- Logarithmic: `log()`, `log10()`, `log2()`, `exp()`
- Power: `pow()`, `sqrt()`
- Rounding: `ceil()`, `floor()`, `trunc()`
- Other: `degrees()`, `radians()`, `pi()`

**Documentation**: https://www.sqlite.org/lang_mathfunc.html

### SQLITE_ENABLE_COLUMN_METADATA
Enables functions to retrieve metadata about table columns:
- `sqlite3_column_database_name()`
- `sqlite3_column_table_name()`
- `sqlite3_column_origin_name()`

Useful for introspection and building dynamic database tools.

**Documentation**: https://www.sqlite.org/c3ref/column_database_name.html

## Security Features

### SQLITE_OMIT_LOAD_EXTENSION
Disables the ability to load external shared libraries at runtime. This prevents:
- Loading potentially malicious extensions
- Security vulnerabilities from dynamic code loading
- Ensures the SQLite build is self-contained

**Why enabled**: Security best practice, especially for embedded/library use.

**Documentation**: https://www.sqlite.org/loadext.html

## Modifying Compile Flags

To add or remove features, edit the `SQLITE_FLAGS` section in `Clib/Makefile`:

```makefile
SQLITE_FLAGS = /DSQLITE_THREADSAFE=1 \
               /DSQLITE_ENABLE_FTS5 \
               /DSQLITE_ENABLE_JSON1 \
               # Add your flags here
```

After modifying flags, rebuild:

```cmd
cd Clib
nmake /f Makefile clean
nmake /f Makefile
```

## Additional Resources

- [SQLite Compile-Time Options](https://www.sqlite.org/compile.html) - Complete list of all available options
- [SQLite Recommended Compile-Time Options](https://www.sqlite.org/compile.html#recommended_compile_time_options)
- [SQLite Extensions](https://www.sqlite.org/loadext.html) - Available extensions and their features
