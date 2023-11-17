# dvdatetool
A tool to change the dates on packaged DV files based on the DVResuce manifest 

### Work in progress

This tool is a work in progress.


#### Usage 

`swift run dvpackagetool`

```bash
USAGE: app <path> [<package-extension>] [<package-prefix>] [<package-postfix>] [<packged-files-path>] [--create-new-files <create-new-files>] [--xml-postfix <xml-postfix>] [--verbose ...] [--recursive ...] [--dry-ryn ...]

ARGUMENTS:
  <path>                  Path to the dvresuce xml file(s)
  <package-extension>     Extension of the packaged files (default: mov)
  <package-prefix>        Package prefix
  <package-postfix>       Package postfix (default: _part)
  <packged-files-path>    Path to packaged files (default: /)

OPTIONS:
  -c, --create-new-files <create-new-files>
                          Create new files
  -x, --xml-postfix <xml-postfix>
                          The DVRescue XML postfix (default: dvrescue.xml)
  -v, --verbose           Show more logging
  -r, --recursive         Look for xml files within sub folders
  -d, --dry-ryn           Perform a dry run and show changes without making them
  -h, --help              Show help information.
```
