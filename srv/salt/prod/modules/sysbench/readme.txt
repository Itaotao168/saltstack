Build and Install
    ./autogen.sh
    # Add --with-pgsql to build with PostgreSQL support
    ./configure
    make -j
    make install
The above will build sysbench with MySQL support by default. If you have MySQL headers and libraries in non-standard locations (and no mysql_config can be found in the PATH), you can specify them explicitly with --with-mysql-includes and --with-mysql-libs options to ./configure.

To compile sysbench without MySQL support, use --without-mysql. If no database drivers are available database-related scripts will not work, but other benchmarks will be functional.
