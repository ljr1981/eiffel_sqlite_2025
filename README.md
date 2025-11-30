# Eiffel SQLite 2025

Modern SQLite wrapper for Eiffel with FTS5, JSON1, and other modern features enabled.

## Features

- **SQLite Version**: 3.51.1 (November 2025)
- **FTS5**: Full-text search with BM25 ranking ✅
- **JSON1**: JSON functions and operators ✅
- **RTREE**: Spatial indexing ✅
- **GEOPOLY**: Geographic polygon queries ✅
- **Math Functions**: Advanced mathematical operations ✅
- **Column Metadata**: Enhanced introspection ✅
- **x64 Native**: Compiled for 64-bit Windows with static runtime

For detailed information about each compile flag and enabled feature, see [COMPILE_FLAGS.md](COMPILE_FLAGS.md).

## Build Instructions

### Windows (MSVC) - x64 with FTS5

**Prerequisites:**
- Visual Studio 2022 (or 2019+) with C++ Build Tools
- x64 Native Tools Command Prompt

**Option 1: Using Makefile (EiffelStudio Runtime)**
1. Open Visual Studio x64 Native Tools Command Prompt
2. Set environment variable:
   ```cmd
   set EIFFEL_SQLITE_2025=D:\prod\eiffel_sqlite_2025
   ```
3. Build:
   ```cmd
   cd D:\prod\eiffel_sqlite_2025\Clib
   nmake /f Makefile
   ```
   Library will be created at: `spec\msvc\win64\lib\sqlite_2025.lib`

**Option 2: Manual Build (For Gobo Eiffel or Custom Paths)**
1. Open Visual Studio x64 Native Tools Command Prompt
2. Navigate to Clib directory:
   ```cmd
   cd D:\prod\eiffel_sqlite_2025\Clib
   ```
3. Compile SQLite with FTS5:
   ```cmd
   cl /c /O2 /MT /DSQLITE_ENABLE_FTS5 /DSQLITE_THREADSAFE=1 sqlite3.c
   ```
4. Compile Eiffel wrapper (adjust include path for your Eiffel installation):
   ```cmd
   cl /c /O2 /MT /I"<your-eiffel-runtime-path>" /I. esqlite.c
   ```

   For Gobo Eiffel:
   ```cmd
   cl /c /O2 /MT /I"D:\prod\gobo-gobo-25.09\gobo-gobo-25.09\tool\gec\backend\c\runtime" /I. esqlite.c
   ```

**Important Notes:**
- Use `/MT` for static runtime (not `/MD`) to avoid runtime DLL dependencies
- The `DSQLITE_ENABLE_FTS5` flag is **required** for full-text search functionality
- Object files (`*.obj`) should **not** be committed to git - they're in `.gitignore`

## Usage in EiffelStudio Projects

Add to your `.ecf` file:

```xml
<library name="sqlite_2025" location="$EIFFEL_SQLITE_2025\sqlite_2025.ecf"/>
```

Set environment variable before compiling:
```cmd
set EIFFEL_SQLITE_2025=D:\prod\eiffel_sqlite_2025
```

## Verification

To verify FTS5 is enabled, query:
```sql
PRAGMA compile_options;
```

Should include: `ENABLE_FTS5`, `THREADSAFE=1`

## Directory Structure

```
eiffel_sqlite_2025/
├── Clib/           - C source and build files
│   ├── sqlite3.c   - SQLite amalgamation (3.51.1)
│   ├── sqlite3.h   - SQLite header
│   ├── esqlite.c   - Eiffel wrapper implementation
│   └── esqlite.h   - Eiffel wrapper header (with EIF_NATURAL compatibility)
├── binding/        - Eiffel external declarations
├── support/        - Eiffel helper classes
├── spec/           - Compiled libraries (not in git)
└── sqlite_2025.ecf - ECF configuration
```

## Version

- **Library Version**: 1.0.0
- **SQLite Version**: 3.51.1
- **Build Date**: November 30, 2025
- **Architecture**: x64 (64-bit)
- **Runtime**: Static (/MT)

## Recent Changes

### November 30, 2025
- ✅ Updated SQLite to version 3.51.1
- ✅ Compiled for x64 architecture with `/MT` static runtime
- ✅ Added `EIF_NATURAL` compatibility for Gobo Eiffel runtime
- ✅ Verified FTS5 full-text search functionality
- ✅ All 181 tests passing in simple_sql integration
- ✅ Fixed special character handling in FTS5 queries

## Documentation

- [README.md](README.md) - This file (build instructions and quick start)
- [CHANGELOG.md](CHANGELOG.md) - Version history and changes
- [COMPILE_FLAGS.md](COMPILE_FLAGS.md) - Detailed SQLite compile flag documentation
- [LICENSE](LICENSE) - MIT License

## License

MIT License - see [LICENSE](LICENSE) file for details.

SQLite itself is in the Public Domain.

## Contributing

When contributing:
1. Do **not** commit `.obj` files or compiled libraries (they're in `.gitignore`)
2. Update README.md and CHANGELOG.md for significant changes
3. Test with both EiffelStudio and Gobo Eiffel if possible
4. Run the full `simple_sql` test suite (181 tests should pass)
5. Update COMPILE_FLAGS.md if modifying SQLite compilation flags
