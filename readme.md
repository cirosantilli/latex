latex shared files, meant to be included as a submodule on other projects to be shared amongst projects.

for a new project, consider using the latex template located in the `latex-template` repo directly.

this only contains files which are cannot be shared for all projects easily and must actually be copied
for each new project. Therefore, the following should not be here:

- `.sty` files: those can be put on the latex search path. See: <https://github.com/cirosantilli/latex-cheat/blob/86cdba6be7a3b4900e9459d7dcd516db6d0121f4/readme.md#sty-search-path> for how to use the search path.
