# Setup Guide for Python Colored Graph Isomorphism Option 

This is the setup guide for using the `Python` option to check for colored graph isomorphisms. This option is enabled with:
```matlab
opts.isomethod = 'Python';
```
## Steps (Windows)
1. Install `Python` (download from the [python website](https://www.python.org/downloads/windows/))
	- `MATLAB` supports `Python` versions 2.7, 3.4, 3.5, and 3.6 (see [MATLAB engine API for python](https://www.mathworks.com/help/matlab/matlab-engine-for-python.html))
	- Make sure you select the installer that is compatible with your 32/64-bit machine (almost always 64-bit)
	- Other options to check during installation
		- Add Python X.X to PATH
		- Install for all users
		- Precompile standard library
	- Confirmed working with 64-bit installation of `Python 3.5.3 - 2017-01-17` 
2. Make sure `pip` is installed. You can test this with the command `pip` in `cmd`
	- What is `pip`? [Wikipedia page](https://en.wikipedia.org/wiki/Pip_(package_manager))
	- If `pip` is not installed, you can manually install it
		- Add the location of `pip` to your PATH (typically located at `C:\Program Files\PythonXX\Scripts`)
3. Install `numpy` using the command `pip install numpy` in `cmd`
	- Alternatively, you can manually install by downloading the correct .whl file from from [Unofficial Windows Binaries for Python Extension Packages](http://www.lfd.uci.edu/~gohlke/pythonlibs/#numpy) and installing with `pip`
		- See http://stackoverflow.com/questions/27885397 for more info on installing .whl with `pip`
		- Make sure you select the .whl file that is compatible with your `Python` version and 32/64-bit installation
	- Confirmed working with `numpy-1.12.0+mkl-cp35-cp35m-win_amd64.whl` for `Python 3.5` 64-bit and `MATLAB` 64-bit
4. Install igraph using `pip` and the correct .whl from [Unofficial Windows Binaries for Python Extension Packages](http://www.lfd.uci.edu/~gohlke/pythonlibs/#python-igraph)
	- See http://stackoverflow.com/questions/27885397 for more info on installing .whl with `pip`
	- Make sure you select the .whl file that is compatible with your `Python` version and 32/64-bit installation
	- Confirmed working with `python_igraph-0.7.1.post6-cp35-none-win_amd64.whl` for `Python 3.5` 64-bit and `MATLAB` 64-bit
5. Run [INSTALL_PM_Architectures_Project.m](https://github.com/danielrherber/pm-architectures-project/blob/master/INSTALL_PM_Architectures_Project.m) in `MATLAB` to determine if everything is setup correctly
	- The desired output in the command window is:
	```MATLAB
	python is available
	numpy  is available
	igraph is available
	opts.isomethod = 'Python' is available
	```
	- If `Python` is unavailable, try to point `MATLAB` at the `Python` executable
		- See [pyversion documenation](https://www.mathworks.com/help/`MATLAB`/ref/pyversion.html)
		- `___ = pyversion executable` specifies full path to `Python` executable. Use on any platform or for repackaged CPython implementation downloads.
		- `executable` is typically `C:\Program Files\PythonXX`

## Steps (Linux)

1. Install `Python`
	- `MATLAB` supports `Python` versions 2.7, 3.4, 3.5, and 3.6 (see [MATLAB engine API for python](https://www.mathworks.com/help/matlab/matlab-engine-for-python.html))
	- You can check if a version of Python 3 is already installed using the command: `python3 --version`
	- To install Python 3.5, run the following command: `sudo apt-get install python3.5`
	- Confirmed working with 64-bit installation of `Python 3.5` 
2. Install the igraph libraries using the command: `sudo apt-get install libigraph0-dev`
	- See https://stackoverflow.com/questions/28435418/failing-to-install-python-igraph
3. Install `pip` using the command: `sudo apt-get install python3-pip`
	- What is `pip`? [Wikipedia page](https://en.wikipedia.org/wiki/Pip_(package_manager))
4. Install `numpy` using the command: `pip3 install numpy`
5. Install `igraph` using the command: `pip3 install python-igraph`
6. Run [INSTALL_PM_Architectures_Project.m](https://github.com/danielrherber/pm-architectures-project/blob/master/INSTALL_PM_Architectures_Project.m) in `MATLAB` to determine if everything is setup correctly
	- The desired output in the command window is:
	```MATLAB
	python is available
	numpy  is available
	igraph is available
	opts.isomethod = 'Python' is available
	```
	- If `Python` is unavailable, try to point `MATLAB` at the `Python` executable
		- See [pyversion documenation](https://www.mathworks.com/help/matlab/ref/pyversion.html)
		- `___ = pyversion executable` specifies full path to `Python` executable. Use on any platform or for repackaged CPython implementation downloads.
		- `executable` is typically `/usr/bin/python3.5`

## Steps (Mac)

1. Install `Python`
	- `MATLAB` supports `Python` versions 2.7, 3.4, 3.5, and 3.6 (see [MATLAB engine API for python](https://www.mathworks.com/help/matlab/matlab-engine-for-python.html))
	- You can check if a version of Python 3 is already installed using the command: `python3 --version`
	- To install Python 3.5, run the following command: `brew install python3`
	- If `python3 --version` produces an error after installation, run `brew link —overwrite python3`. This changes the default PATH 
	to `/usr/local/Cellar/python3/`
	- `pip` should be installed as well
		- What is `pip`? [Wikipedia page](https://en.wikipedia.org/wiki/Pip_(package_manager))
	- Confirmed working with 64-bit installation of `Python 3.5` 
4. Install `numpy` using the command: `pip3 install numpy`
5. Install `igraph` using the command: `pip3 install python-igraph`
6. Run [INSTALL_PM_Architectures_Project.m](https://github.com/danielrherber/pm-architectures-project/blob/master/INSTALL_PM_Architectures_Project.m) in `MATLAB` to determine if everything is setup correctly
	- The desired output in the command window is:
	```MATLAB
	python is available
	numpy  is available
	igraph is available
	opts.isomethod = 'Python' is available
	```
	- If `Python` is unavailable, try to point `MATLAB` at the `Python` executable
		- See [pyversion documenation](https://www.mathworks.com/help/matlab/ref/pyversion.html)
		- `___ = pyversion executable` specifies full path to `Python` executable. Use on any platform or for repackaged CPython implementation downloads.
		- Use `which python3` to determine installation location of your `Python` setup