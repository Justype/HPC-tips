# Vim

Vim is a text editor.

[Interactive tutorial](https://www.openvim.com/)

## Enter Commands

- `:` Then Enter Command
- `:w` write the changes
- `:q` quit the file
- `:q!` quit and ignore changes
- `:wq` write and quit

## Mode

- Normal
- Insert
- Visual (View and Edit or Copy)

### Normal mode

- Navigation
  - `h` ← `j` ↓ `k` ↑ `l` →
  - `w`, `e`, `b` jump words
    - `w` start of next word
    - `e` end of the word
    - `b` beginning of the word
  - `f` go to the next character
    - `3fg` go to the 3rd g
  - `%` jump to the matching brackets () {} []
  - `0`, `$` Line
    - `0` beginning of the line
    - `$` end of the line
  - `*` `#` occurrence of the wordG
    - `*` next occurrence of the word
    - `#` previous occurrence of the word
  - `gg` `G` File
    - `gg` start of the file
    - `G` end of the file
    - `2G` go to line 2
- Search `/`
  - `n` next
  - `N` previous
- Delete
  - `x` delete the character under the cursor and go left

### Insert Mode

- `i` Enter Insert Mode
- `a` move right, and Enter Insert Mode
- `o` create a new line below, and Enter Insert Mode
- `O` create a new line above, and Enter Insert Mode

### Visual Mode

- `v` Enter View Mode
- Same navigation keys as the normal mode
- `y` yank (copy)


## Key Combination Example

- `3h`: press `h` 3 times, so three left
- `9w`: press `w` 9 times

numbers and input mode

- `10i-` `Esc`: ----------
- `3igo` `Esc`: gogogo

finding

- `3fq` find the third q

copying (y + y or position)

- `yy` copy current line
- `y3e` copy 3 words
- `y0` copy to the start of the line
- `yG` copy to the end of the file

Deleting (d + d or position)

- `dd` delete current line
- `d3e` delete 3 words
- `d0` delete to the start of the line
- `dG` delete to the end of the file

## Substitute Characters

`:%s/where to change/replacement/` (only the first one in each line)
`:%s/where to change/replacement/g` (global: all)
