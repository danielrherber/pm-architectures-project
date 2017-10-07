# README #

[![GitHub release](https://img.shields.io/github/release/danielrherber/pm-architectures-project.svg)](https://github.com/danielrherber/pm-architectures-project/releases/latest)
[![](https://img.shields.io/badge/language-matlab-EF963C.svg)](https://www.mathworks.com/products/matlab.html)
[![](https://img.shields.io/github/issues-raw/danielrherber/pm-architectures-project.svg)](https://github.com/danielrherber/pm-architectures-project/issues)
[![GitHub contributors](https://img.shields.io/github/contributors/danielrherber/pm-architectures-project.svg)](https://github.com/danielrherber/pm-architectures-project/graphs/contributors)

[![license](https://img.shields.io/github/license/danielrherber/pm-architectures-project.svg)](https://github.com/danielrherber/pm-architectures-project/blob/master/License)

Generate the set of unique useful architectures with a perfect matching-based approach.

![readme image](http://www.danielherber.com/img/projects/pm-architectures-project/readme_image.svg "Readme Image")

### Install ###
* Download the [PM Architectures Project](https://github.com/danielrherber/pm-architectures-project/archive/master.zip)
* Run [INSTALL_PM_Architectures_Project.m](https://github.com/danielrherber/pm-architectures-project/blob/master/INSTALL_PM_Architectures_Project.m) in the MATLAB Command Window until no errors are seen
(*automatically adds project files to your MATLAB path, downloads the required MATLAB File Exchange submissions, and checks your Python setup*)
```matlab
INSTALL_PM_Architectures_Project
```
* See [ex_md161635_CaseStudy1.m](https://github.com/danielrherber/pm-architectures-project/blob/master/examples/md-16-1635/ex_md161635_CaseStudy1.m) for an example with problem setup and options
```matlab
open ex_md161635_CaseStudy1
```

### Citation ###
Many elements of this project are discussed in the following papers. Please cite them if you use the project.

* DR Herber, T Guo, JT Allison. **Enumeration of Architectures with Perfect Matchings**. Journal of Mechanical Design, 139(5), p. 051403, May 2017. [[PDF]](http://systemdesign.illinois.edu/publications/Her16b.pdf)
	- *Abstract: In this article, a class of architecture design problems is explored with perfect matchings (PMs). A perfect matching in a graph is a set of edges such that every vertex is present in exactly one edge. The perfect matching approach has many desirable properties such as complete design space coverage. Improving on the pure perfect matching approach, a tree search algorithm is developed that more efficiently covers the same design space. The effect of specific network structure constraints (NSCs) and colored graph isomorphisms on the desired design space is demonstrated. This is accomplished by determining all unique feasible graphs for a select number of architecture problems, explicitly demonstrating the specific challenges of architecture design. With this methodology, it is possible to enumerate all possible architectures for moderate scale-systems, providing both a viable solution technique for certain problems and a rich data set for the development of more capable generative methods and other design studies.*
* DR Herber, JT Allison. **Enhancements to the Perfect Matching-based Tree Algorithm for Generating Architectures**. Technical report, Engineering System Design Lab, preprint-v2, Urbana, IL, USA, Apr. 2017. [[PDF]](http://systemdesign.illinois.edu/publications/Her17d.pdf)
	- *Abstract: In this report, a number of enhancements to the perfect matching-based tree algorithm for generating the set of unique, feasible architectures are discussed. The original algorithm was developed to generate a set of colored graphs covering the graph structure space defined by (C, R, P) and various additional network structure constraints. The proposed enhancements either more efficiently cover the same graph structure space or allow additional network structure constraints to be defined. The six enhancements in this report are replicate ordering, avoiding loops, avoiding multi-edges, avoiding line-connectivity constraints, checking for saturated subgraphs, and enumerating subcatalogs. Some theory, implementation details, and examples are provided for each enhancement.*

### External Includes ###
* See [INSTALL_PM_Architectures_Project.m](https://github.com/danielrherber/pm-architectures-project/blob/master/INSTALL_PM_Architectures_Project.m) for more information
* **MATLAB File Exchange Submission IDs** (10922, 23629, 29438, 40397, 44673, 47246)
* **Python** (Python 3.5, numpy package, igraph package), *optional depending on isomorphism checking option*

### Contributors ###
* [Daniel R. Herber](https://github.com/danielrherber) (primary)
* Tinghao Guo
* James T. Allison
* [Shangting Li](https://github.com/shangtingli)

### Project Links ###
* [https://github.com/danielrherber/pm-architectures-project](https://github.com/danielrherber/pm-architectures-project)
* [http://www.mathworks.com/matlabcentral/fileexchange/58799](http://www.mathworks.com/matlabcentral/fileexchange/58799)
