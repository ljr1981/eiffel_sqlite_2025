note
	description: "Test eiffel_sqlite_2025 library basic operations"
	testing: "type/manual"

class
	TEST_SQLITE_LIBRARY

inherit
	TEST_SET_BASE
		redefine
			on_prepare
		end

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
			Precursor
		end

feature -- Test routines

	test_database_opens
			-- Test that in-memory database opens successfully
		note
			testing: "covers/{SQLITE_DATABASE}.make"
			testing: "covers/{SQLITE_DATABASE}.open_create_read_write"
		local
			l_db: SQLITE_DATABASE
		do
			create l_db.make (create {SQLITE_IN_MEMORY_SOURCE})
			l_db.open_create_read_write

			assert ("database_open", not l_db.is_closed)
			assert ("database_writable", l_db.is_writable)

			l_db.close
		end

	test_interface_usable_after_open
			-- Test that is_interface_usable returns True after opening database
		note
			testing: "covers/{SQLITE_DATABASE}.is_interface_usable"
		local
			l_db: SQLITE_DATABASE
		do
			create l_db.make (create {SQLITE_IN_MEMORY_SOURCE})
			l_db.open_create_read_write

			assert ("interface_usable", l_db.is_interface_usable)

			l_db.close
		end

	test_create_table
			-- Test CREATE TABLE statement execution
		note
			testing: "covers/{SQLITE_MODIFY_STATEMENT}.execute"
			testing: "execution/isolated"
		local
			l_db: SQLITE_DATABASE
			l_stmt: SQLITE_MODIFY_STATEMENT
		do
			create l_db.make (create {SQLITE_IN_MEMORY_SOURCE})
			l_db.open_create_read_write

			create l_stmt.make ("CREATE TABLE test (id INTEGER PRIMARY KEY, name TEXT);", l_db)
			l_stmt.execute

			assert ("no_error_creating_table", not l_db.has_error)
			assert ("interface_still_usable", l_db.is_interface_usable)

			l_db.close
		end

	test_create_trigger
			-- Test CREATE TRIGGER statement execution
			-- This is the critical test to verify triggers work
		note
			testing: "covers/{SQLITE_MODIFY_STATEMENT}.execute"
			testing: "execution/isolated"
		local
			l_db: SQLITE_DATABASE
			l_stmt: SQLITE_MODIFY_STATEMENT
		do
			create l_db.make (create {SQLITE_IN_MEMORY_SOURCE})
			l_db.open_create_read_write

			-- First create the table
			create l_stmt.make ("CREATE TABLE test (id INTEGER PRIMARY KEY, name TEXT);", l_db)
			l_stmt.execute
			assert ("table_created", not l_db.has_error)

			-- Check interface is still usable before trigger
			assert ("interface_usable_before_trigger", l_db.is_interface_usable)

			-- Now create the trigger
			create l_stmt.make ("CREATE TRIGGER test_trigger AFTER INSERT ON test BEGIN INSERT INTO test (name) VALUES ('triggered'); END;", l_db)
			l_stmt.execute

			-- These assertions will reveal the issue
			assert ("no_error_creating_trigger", not l_db.has_error)
			assert ("interface_usable_after_trigger", l_db.is_interface_usable)

			l_db.close
		end

	test_create_trigger_with_json
			-- Test CREATE TRIGGER with json_object (like audit triggers use)
		note
			testing: "covers/{SQLITE_MODIFY_STATEMENT}.execute"
			testing: "execution/isolated"
		local
			l_db: SQLITE_DATABASE
			l_stmt: SQLITE_MODIFY_STATEMENT
		do
			create l_db.make (create {SQLITE_IN_MEMORY_SOURCE})
			l_db.open_create_read_write

			-- Create source table
			create l_stmt.make ("CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, age INTEGER);", l_db)
			l_stmt.execute
			assert ("users_table_created", not l_db.has_error)

			-- Create audit table
			create l_stmt.make ("CREATE TABLE users_audit (audit_id INTEGER PRIMARY KEY, operation TEXT, new_values TEXT);", l_db)
			l_stmt.execute
			assert ("audit_table_created", not l_db.has_error)

			-- Create trigger with json_object (exactly like simple_sql_audit does)
			create l_stmt.make (
				"CREATE TRIGGER users_audit_insert AFTER INSERT ON users FOR EACH ROW BEGIN " +
				"INSERT INTO users_audit (operation, new_values) VALUES ('INSERT', json_object('id', NEW.id, 'name', NEW.name, 'age', NEW.age)); END;",
				l_db
			)
			l_stmt.execute

			-- The critical assertions
			assert ("no_error_creating_json_trigger", not l_db.has_error)
			assert ("interface_usable_after_json_trigger", l_db.is_interface_usable)

			l_db.close
		end

end
