# Basic Cheat Sheet

#### View files commmands

```
ls                      - will show ls command with icons and colors
l                       - will show ls -la with icons and colors
lt                      - will show tree of files with icons and colors

bat somefile.txt       - will show contents with pager and syntax highlighting
```

#### Navigation

```
..                      - go back one directory
...                     - go back two directories
....                    - go back three directories

cd                      - now used zoxide and will cache your directories (i.e cd tower, cd arya saas, cd tower console)
cdi                     - will display the options in case of multiple options

cl                      - clear
```

#### fzf

```
fzf                     - run fzf on a directory to search every file in it
cd something**          - run fzf with preview of directories on something...
Ctrl+r                  - run fzf on the history of commands
something Ctrl+r        - run fzf on the history of commands containing something
cat somefile.txt | fzf  - pipe the contents of the file to fzf (can be good for logs and live searching)
vim som**               - search for "some" file and autocomplete using Enter to edit with vim
nvim som**              - search for "some" file and autocomplete using Enter to edit with neovim
```

#### Kubernetes

```
k9s                     - opens k9s tool on the current Kubernetes context
kconf                   - get all kubectl contexts available
kctx context_name       - switch to some context using the context name
```

#### git

```
lg                      - open LazyGit UI on the current directory
```
