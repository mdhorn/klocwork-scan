# Klocwork Scanning for SPR BKC

Scripts for scanning packages with Klocwork static analysis tool for
the Security Development Lifecycle (SDL).

These scripts should be run from the extracted sources to be scanned.
It will create a build directory in /build (which should be a fast cache
file system), build the code with KW enabled, and upload the KW results
to the server.

