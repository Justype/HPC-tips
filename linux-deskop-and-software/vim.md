# Vim

Vim is a text editor.

[Interactive tutorial](https://www.openvim.com/)

## Mode

- Normal
- Insert

### Normal mode

- Navigate
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

- `i` Insert Mode
- `a` move right, and Insert
- `o` create a new line below, and go to Insert Mode
- `O` create a new line above, and Insert

### Combination

- `3h`: press `h` 3 times, so three left
- `9w`: press `w` 9 times

numbers and input mode

- `10i-` `Esc`: ----------
- `3igo` `Esc`: gogogo

f

- `3fq` find the third q

