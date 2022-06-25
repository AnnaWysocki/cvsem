## Test environments
* locally: R 4.1.2
* remotely: Ubuntu-latest, MacOS-latest and Windows-latest (on github actions-ci)

  
## R CMD check results

### Version 0.0.0.9000
0 errors ✔ | 0 warnings ✔ | 2 notes ✖

* checking CRAN incoming feasibility ... NOTE
Version contains large components (0.0.0.9000)

- Compiled code is relatively large

* checking R code for possible problems ... NOTE
Found if() conditions comparing class() to string:
File 'cvsem/R/cvsem.R': if (!class(Models) == "cvgather") ...
File 'cvsem/R/lavaanWrapper.R': if (class(Models[[i]]) != "lavaan") ...
Use inherits() (or maybe is()) instead.

- If statement is useful here to run different code depending on what the model class is
