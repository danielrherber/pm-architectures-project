## Structured Component Expansion

Generate the set of structured graphs from useful architectures, and eliminate resulting isomorphic graphs in the graph set.

* **Structured Components**: Components whose connection orders with other components would affect the overall design architecture. An example would be planetary gears. See [Journal](https://ise.illinois.edu/undergraduate/research-experience/reu-projects/enumeration-of-design-architecture.pdf)

* **Structured Graphs**: Unique graphs with every structured component represented by the number of simple components equal to its port numbers.

---

### Examples
* Download the [PM Architectures Project](https://github.com/danielrherber/pm-architectures-project/archive/master.zip)
* Run [INSTALL_PM_Architectures_Project.m](https://github.com/danielrherber/pm-architectures-project/blob/master/INSTALL_PM_Architectures_Project.m) in the MATLAB Command Window until no errors are seen
(*automatically adds project files to your MATLAB path, downloads the required files, checks your Python setup, and opens an example*)
```matlab
INSTALL_PM_Architectures_Project
```

* See [Structured_Bayrak2016.m]() for how to expand structured components in useful architectures. 
```matlab
open Structured_Bayrak2016.m
```

---
### Isomorphic Graphs Elimination

#### Current Methods Include:
* AIO (Eliminate isomorphic graphs after expansion of structured components).
* LOE (Eliminate isomorphic graphs during expansion of structured components).
* Sort Colored Labels before eliminate isomorphic graphs.
* See [Journal](https://ise.illinois.edu/undergraduate/research-experience/reu-projects/enumeration-of-design-architecture.pdf) for more details.
