# README #

Generate the set of unique useful architectures with a perfect matching-based approach.

![readme image](https://github.com/danielrherber/pm-architectures-project/blob/master/readme_image.png "Readme Image")

### Install ###
* Download the [PM Architectures Project](https://github.com/danielrherber/pm-architectures-project/archive/master.zip)
* Run [INSTALL_PM_Architectures_Project.m](https://github.com/danielrherber/pm-architectures-project/blob/master/INSTALL_PM_Architectures_Project.m) in the MATLAB Command Window
(*automatically adds project files to your MATLAB path, downloads the required MATLAB File Exchange submissions, and checks your Python setup*)
```matlab
INSTALL_PM_Architectures_Project
```
* See [ex_CaseStudy1.m](https://github.com/danielrherber/pm-architectures-project/blob/master/examples/idetc2016_60212/ex_CaseStudy1.m) for an example with problem setup and options
```matlab
open ex_CaseStudy1
```

### Citation ###
Many elements of this project are discussed in the following papers. Please cite them if you use project.

* DR Herber, T Guo, JT Allison. **Enumeration of Architectures with Perfect Matchings**, In ASME International Design Engineering Technical Conference, Charlotte, NC, USA, IDETC2016-60212, Aug. 21-24 2016. [http://systemdesign.illinois.edu/publications/Her16b.pdf](http://systemdesign.illinois.edu/publications/Her16b.pdf)
	- *Abstract: In this article a class of architecture design problems is explored with perfect matchings. A perfect matching in a graph is a set of edges such that every vertex is present in exactly one edge. The perfect matching approach has many desirable properties such as complete design space coverage. Improving on the pure perfect matching approach, a tree search algorithm is developed that more efficiently covers the same design space. The effect of specific network structure constraints and colored graph isomorphisms on the desired design space is demonstrated. This is accomplished by determining all unique feasible graphs for a select number of architecture problems, explicitly demonstrating the specific challenges of architecture design. Additional applications of this work to the larger architecture design process is also discussed.*

### Include ####
See [INSTALL_PM_Architectures_Project.m](https://github.com/danielrherber/pm-architectures-project/blob/master/INSTALL_PM_Architectures_Project.m) for more information.

##### Python #####
* Python 3.5
* numpy package
* igraph package

##### MATLAB File Exchange Submission IDs #####
* 10922
* 23629
* 40397
* 44673
* 47246

### Contributors ###
* [Daniel R. Herber](https://github.com/danielrherber) (primary)
* Tinghao Guo
* James T. Allison

### Project Links ###
* [https://github.com/danielrherber/pm-architectures-project](https://github.com/danielrherber/pm-architectures-project)
* [http://www.mathworks.com/matlabcentral/fileexchange/58799](http://www.mathworks.com/matlabcentral/fileexchange/58799)