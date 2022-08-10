## Test environments
* locally: R 4.1.2
* remotely: Ubuntu-latest, MacOS-latest and Windows-latest (on github actions-ci)

  
## R CMD check results

### Version 1.0.0
0 errors ✔ | 0 warnings ✔ | 1 notes ✖

* Possibly misspelled words in DESCRIPTION ... NOTE
  Cudeck (9:350)
  Kullback (9:216)
  Leibler (9:225)
  SEM (2:8, 9:77)
  SEMs (9:133, 9:466)
 
  
  - The above list of words are either author names, acronyms (that have been explained), or estimator names. None are mispelled. 


## Comments from CRAN admins:
  > Please always write package names, software names and API (application
  >  programming interface) names in single quotes in title and description.
  > e.g: --> 'cvsem'
  - Single quotes added
  
  > Please note that package names are case sensitive
  - All package names are in the correct case. 

  > Please always explain all acronyms in the description text. -> 'KL'
  - An explanation for the KL acronym was added.  

  > Please do not start the description with "This package", "Functions
  > for", package name,
  > title or similar.
  
  - Beginning of DESCRIPTION changed 
