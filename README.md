# SF Tools Readme

## diffSandboxFiles.sh

Downloads an Apex Class file from two different sandboxes and diffs them.

`diffSandboxFiles.sh -o originalSandboxAlias -n newSandboxAlias -t type -f FileNameClass`

-o is the first sandbox we are comparing with.

-n is the second sandbox to compare against.

-t is the Case Insensitive Type of file that we are comparing. This can be APEX or LWC. 

-f is the name of the class that we are comparing against. Basically the file name, but without any extension (so NO .cls or .js-meta.xml)

