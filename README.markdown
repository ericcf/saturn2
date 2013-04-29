Set up development user and database
Note: this creates a user (role) with superuser privileges, so only do this in development!
createuser -s saturn2
createdb -E UTF8 -O saturn2 saturn2_development

Set up test databse
createdb -E UTF8 -O saturn2 saturn2_test
