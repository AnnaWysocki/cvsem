## Test environments
* locally: R 4.1.2
* remotely: Ubuntu-latest, MacOS-latest and Windows-latest (on github actions-ci)

  
## R CMD check results

### Version 1.0.0
0 errors ✔ | 0 warnings ✔ | 1 notes ✖

* Possibly misspelled words in DESCRIPTION ... NOTE
  Cudeck (9:350)
  SEM (2:8, 9:77)
  SEMs (9:133, 9:466)
  cvsem (9:159)
  lavaan (9:144)
  
  - The above list of words are either author names, acronyms (that have been explained), or package names. None are mispelled. 


## Comments from CRAN admins:
  > Please always explain all acronyms in the description text. e.g.: SEM
  - Explanation for acronym added
  
  > Please do not start the description with "This package", package name, 
  > title or "Functions that".
  - Modified beginning of description 

  > The Description field is intended to be a (one paragraph) description of
  > what the package does and why it may be useful. Please add more details
  > about the package functionality and implemented methods in your
  > Description text.
  - More information added to the description 

  > If there are references describing the methods in your package, please
  > add these in the description field of your DESCRIPTION file in the form
  - References added 
