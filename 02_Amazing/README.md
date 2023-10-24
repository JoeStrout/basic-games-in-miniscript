### Amazing

This program will print out a different maze every time it is run and guarantees only one path through. You can choose the dimensions of the maze — i.e. the number of squares wide and long.

The original program author was Jack Hauber of Windsor, Connecticut.

---

As published in Basic Computer Games (1978):
- [Atari Archives](https://www.atariarchives.org/basicgames/showpage.php?page=3)
- [Annarchive](https://annarchive.com/files/Basic_Computer_Games_Microcomputer_Edition.pdf#page=18)

Downloaded from Vintage Basic at
http://www.vintage-basic.net/games.html

#### Known Bugs

- The input dimensions are checked for values of 1, but not for values of 0 or less.  Such inputs will cause the program to break.

#### Porting Notes

**2022-01-04:** patched original source in [#400](https://github.com/coding-horror/basic-computer-games/pull/400) to fix a minor bug where a generated maze may be missing an exit, particularly at small maze sizes.
