## README (pm-architectures-project)

[![GitHub release](https://img.shields.io/github/release/danielrherber/pm-architectures-project.svg)](https://github.com/danielrherber/pm-architectures-project/releases/latest)
[![](https://img.shields.io/badge/language-matlab-EF963C.svg)](https://www.mathworks.com/products/matlab.html)
[![](https://img.shields.io/github/issues-raw/danielrherber/pm-architectures-project.svg)](https://github.com/danielrherber/pm-architectures-project/issues)
[![GitHub contributors](https://img.shields.io/github/contributors/danielrherber/pm-architectures-project.svg)](https://github.com/danielrherber/pm-architectures-project/graphs/contributors)

[![license](https://img.shields.io/github/license/danielrherber/pm-architectures-project.svg)](https://github.com/danielrherber/pm-architectures-project/blob/master/License)

Generate the set of unique useful architectures with a perfect matching-based approach.

![readme image](http://www.danielherber.com/img/projects/pm-architectures-project/readme_image.svg "Readme Image")

---
### Install
* Download the [project files](https://github.com/danielrherber/pm-architectures-project/archive/master.zip)
* Run [INSTALL_PMA_project.m](https://github.com/danielrherber/pm-architectures-project/blob/master/INSTALL_PMA_project.m) in the MATLAB Command Window until no errors are seen
(*automatically adds project files to your MATLAB path, downloads the required files, checks your Python setup, and opens an example*)

```matlab
INSTALL_PMA_project
```
* See [ex_md161635_CaseStudy1.m](https://github.com/danielrherber/pm-architectures-project/blob/master/examples/md-16-1635/ex_md161635_CaseStudy1.m) for an example with problem setup and options
```matlab
open ex_md161635_CaseStudy1
```

### Citation
Many elements of this project are discussed in the following papers. Please cite them if you use the project.

* DR Herber, T Guo, JT Allison. **Enumeration of architectures with perfect matchings**. Journal of Mechanical Design, 139(5), p. 051403, May 2017. [[PDF]](http://systemdesign.illinois.edu/publications/Her16b.pdf)
	- *Abstract: In this article, a class of architecture design problems is explored with perfect matchings (PMs). A perfect matching in a graph is a set of edges such that every vertex is present in exactly one edge. The perfect matching approach has many desirable properties such as complete design space coverage. Improving on the pure perfect matching approach, a tree search algorithm is developed that more efficiently covers the same design space. The effect of specific network structure constraints (NSCs) and colored graph isomorphisms on the desired design space is demonstrated. This is accomplished by determining all unique feasible graphs for a select number of architecture problems, explicitly demonstrating the specific challenges of architecture design. With this methodology, it is possible to enumerate all possible architectures for moderate scale-systems, providing both a viable solution technique for certain problems and a rich data set for the development of more capable generative methods and other design studies.*
* DR Herber, JT Allison. **Enhancements to the perfect matching-based tree algorithm for generating architectures**. Technical report, Engineering System Design Lab, UIUC-ESDL-2017-02, Urbana, IL, USA, Dec. 2017. [[URL]](http://hdl.handle.net/2142/98990) [[PDF]](http://systemdesign.illinois.edu/publications/Her17d.pdf)
	- *Abstract: In this report, a number of enhancements to the perfect matching-based tree algorithm for generating the set of unique, feasible architectures are discussed. The original algorithm was developed to generate a set of colored graphs covering the graph structure space defined by (C,R,P) and various additional network structure constraints. The proposed enhancements either more efficiently cover the same graph structure space or allow additional network structure constraints to be defined. The seven enhancements in this report are replicate ordering, avoiding loops, avoiding multi-edges, avoiding line-connectivity constraints, checking for saturated subgraphs, enumerating subcatalogs, and alternative tree traversal strategies. Some theory, implementation details, and examples are provided for each enhancement.*

This project has been used in the following papers to solve various engineering architecture design problems.

* DR Herber. **Advances in combined architecture, plant, and control design.** PhD Dissertation, University of Illinois at Urbana-Champaign, Urbana, IL, USA, Dec. 2017. [[URL]](http://hdl.handle.net/2142/99394) [[PDF]](https://systemdesign.illinois.edu/publications/Her17e.pdf#page=162)
	- *Synthesis of passive analog circuits*
* DR Herber, JT Allison. **A problem class with combined architecture, plant, and control design applied to vehicle suspensions.** In ASME 2018 International Design Engineering Technical Conferences, DETC2018-86213, Quebec City, Canada, Aug. 2018. [[DOI]](https://doi.org/10.1115/DETC2018-86213) [[PDF]](https://systemdesign.illinois.edu/publications/Her18a.pdf)
	- *Synthesis of active vehicle suspensions*
* T Guo, DR Herber, JT Allison. **Reducing evaluation cost for circuit synthesis using active learning.** In ASME 2018 International Design Engineering Technical Conferences, DETC2018-85654,Quebec City, Canada, Aug. 2018. [[DOI]](https://doi.org/10.1115/DETC2018-85654) [[PDF]](https://systemdesign.illinois.edu/publications/Guo2018d.pdf)
	- *Circuit design data for machine learning generated using this project*
* T Guo, DR Herber, JT Allison. **Circuit synthesis using generative adversarial networks (GANs)**. In AIAA 2019 Science and Technology Forum and Exposition, AIAA 2019-2350, San Diego, CA, USA, Jan. 2019. [[DOI]](https://doi.org/10.2514/6.2019-2350) [[PDF]](https://systemdesign.illinois.edu/publications/Guo2019a.pdf)
	- *Circuit design data for machine learning generated using this project*

### External Includes
* See [INSTALL_PMA_project.m](https://github.com/danielrherber/pm-architectures-project/blob/master/INSTALL_PMA_project.m) for more information
* **MATLAB File Exchange Submission IDs** (10922, 23629, 29438, 40397, 44673, 47246, 52301)
* **Python** (Python 3.5, numpy package, igraph package), *optional depending on isomorphism checking option*

---
### General Information

#### Contributors
* [Daniel R. Herber](https://github.com/danielrherber) (primary)
* [Tinghao Guo](https://github.com/TinghaoGuo)
* James T. Allison
* [Shangting Li](https://github.com/shangtingli)

#### Project Links
* [https://github.com/danielrherber/pm-architectures-project](https://github.com/danielrherber/pm-architectures-project)
* [http://www.mathworks.com/matlabcentral/fileexchange/58799](http://www.mathworks.com/matlabcentral/fileexchange/58799)
