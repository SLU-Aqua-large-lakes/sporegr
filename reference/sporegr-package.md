# sporegr: tools and templates to work with and create reports from Spöreg data

This package will help you Work with data from the Spöreg mobile app.
The package contains functions to read (and do some cleanup) of data
files exported from predefined queries in APEX.

## Data Import and Export

Functions to import data from csv or xlsx files exported from the APEX
service (<https://fd2.slu.se/ords/r/aqua/store100107/home>). Some
cleanup and renaming is done to make the dataset more R friendly.

- [`read_resa_clean`](https://kagervall.github.io/sporegr/reference/read_resa_clean.md):
  import data from with trip info (*resor*)

- [`read_fangst_clean`](https://kagervall.github.io/sporegr/reference/read_fangst_clean.md):
  import data from with catches (*fångst*)

- `read_fangst_ovrighandelse`: import data from with misc data

## See also

Useful links:

- <https://github.com/SLU-Aqua-large-lakes/sporegr>

- <https://slu-aqua-large-lakes.github.io/sporegr/>

- Report bugs at
  <https://github.com/SLU-Aqua-large-lakes/sporegr/issues>

## Author

**Maintainer**: Göran Sundblad <goran.sundblad@slu.se>
([ORCID](https://orcid.org/0000-0001-8970-9996))

Authors:

- Anders Kagervall <anders.kagervall@gmail.com>
  ([ORCID](https://orcid.org/0000-0003-4790-2696))
