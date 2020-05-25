# Setup Guide for Python-based Labeled Graph Isomorphism Options

This is the setup guide for using the `Python` option to check for labeled graph isomorphisms. The current options are enabled with:
```matlab
opts.isomethod = 'python'; % (defaults to py-igraph)
opts.isomethod = 'py-igraph';
opts.isomethod = 'py-networkx';
```

## Steps (Windows)
> Lasted updated on 2020-04-29

1. Install `Python`
	- Check the following link for the Python versions that MATLAB officially supports: [MATLAB engine API for python](https://www.mathworks.com/help/matlab/matlab-engine-for-python.html)
	- Make sure you select an installer that is compatible with your 32/64-bit machine (almost always 64-bit now)
	- Other options to consider during installation:
		- Add Python X.X to PATH (this is needed so MATLAB can easily find the installation)
		- Install `pip` (for the later steps)
		- Install for all users
		- Precompile standard library
	- There are a few options for installation:
		- [Recommended] Directly from the [python website](https://www.python.org/downloads/windows/). ```Windows x86-64 executable installer``` for the most recent Python 3.X distribution is probably the correct option
		- Using [Anaconda](https://www.anaconda.com/products/individual)
		- Using the appropriate [Python](https://chocolatey.org/packages?q=python) package in the [Chocolatey package manager](https://chocolatey.org/). The following command most likely is appropriate for installing a recent Python 3.X distribution: ```> choco install python```
	- Confirmed working with 64-bit installation of `Python 3.8.2 (tags/v3.8.2:7b3ab59, Feb 25 2020, 23:03:10)`
1. Make sure `pip` is installed. You can test this with the command `pip` in cmd
	- What is `pip`? [Wikipedia page](https://en.wikipedia.org/wiki/Pip_(package_manager))
	- If `pip` is not installed, you should [manually install it](https://pip.pypa.io/en/stable/installing/)
	- Ensure that the location of `pip` is in your PATH by typing command `pip` in cmd (`pip.exe` is typically located at `C:\Program Files\PythonXX\Scripts`)
1. Install `numpy` using the command `pip install numpy` in cmd
	- Confirmed working with `numpy-1.18.3-cp38-cp38-win_amd64.whl` for Python 3.8 64-bit and MATLAB 64-bit
1. Install `igraph` using the command `pip install python-igraph` in cmd
	- Confirmed working with `python_igraph-0.8.2-cp38-cp38-win_amd64.whl` for Python 3.8 64-bit and MATLAB 64-bit
1. Install `networkx` using the command `pip install networkx` in cmd
	- Confirmed working with `networkx-2.4-py3-none-any.whl` for Python 3.8 64-bit and MATLAB 64-bit
1. Ensure MATLAB is using the correct Python installation. If Python is unavailable, try to point MATLAB to the appropriate `python.exe` file
	- See [pyenv](https://www.mathworks.com/help/matlab/ref/pyenv.html) documentation (older MATLAB versions use [pyversion](https://www.mathworks.com/help/matlab/ref/pyversion.html))
	- ```pyenv('Version',version)``` changes the default Python version to `version`. For example, ```pyenv('Version','3.8')```
	- ```pyenv('Version',executable)``` specifies the full path to the Python executable, and `executable` is typically located at `C:\PythonXX` or `C:\Program Files\PythonXX`
1. Run [INSTALL_PMA_project.m](../INSTALL_PMA_project.m) in MATLAB to determine if everything is setup correctly
	- The desired output in the command window is:
	```
	--- Checking Python setup
	Available: python 3.8.3
	Available: numpy 1.18.3
	Available: igraph 0.8.2
	Available: networkx 2.4
	opts.isomethod = 'python' is available
	```

## Steps (Linux)
> Lasted updated on 2020-04-29

1. Update all packages by running the commands `sudo apt update` and then `sudo apt full-upgrade` in the terminal
1. Install `Python`
	- Check the following link for the Python versions that MATLAB officially supports: [MATLAB engine API for python](https://www.mathworks.com/help/matlab/matlab-engine-for-python.html)
	- You can check if Python 3.X is already installed using the command `python3 --version` in the terminal
	- To install Python 3.X, run the following command `sudo apt install python3` in the terminal
	- Confirmed working with 64-bit installation of Python 3.6.9 on Linux Mint 19.3-cinnamon 64-bit
1. Install `pip3` using the command `sudo apt install python3-pip` in the terminal
	- What is `pip3`? [Wikipedia page](https://en.wikipedia.org/wiki/Pip_(package_manager))
	- Confirmed working with `9.0.1` for Python 3.6.9 64-bit
1. Install `setuptools` using the command `sudo apt install python3-setuptools` in the terminal
	- Confirmed working with `39.0.1` for Python 3.6.9 64-bit
1. Install `numpy` using the command `pip3 install numpy` in the terminal
	- Confirmed working with `1.18.3` for Python 3.6.9 64-bit and MATLAB 2020a Update 1 64-bit
1. Install `igraph` using the command `sudo apt install python3-igraph` in the terminal
	- Note that this method does not always install the latest version of igraph
	- Confirmed working with `0.7.1` for Python 3.6.9 64-bit and MATLAB 2020a Update 1 64-bit
1. Install `networkx` using the command `pip3 install networkx` in the terminal
	- Confirmed working with `2.4` for Python 3.6.9 64-bit and MATLAB 2020a Update 1 64-bit
1. Ensure MATLAB is using the correct Python installation (mostly likely defaults to Python 2.X, which is not correct). If Python is unavailable, try to point MATLAB to the appropriate `python3` file
	- See [pyenv](https://www.mathworks.com/help/matlab/ref/pyenv.html) documentation (older MATLAB versions use [pyversion](https://www.mathworks.com/help/matlab/ref/pyversion.html))
	- ```pyenv('Version',executable)``` specifies the full path to the Python executable, and `executable` is typically located at `/usr/bin/python3`
	- Use `which python3` to determine installation location of your Python 3.X distribution
1. Run [INSTALL_PMA_project.m](../INSTALL_PMA_project.m) in MATLAB to determine if everything is setup correctly
	- The desired output in the command window is:
	```
	--- Checking Python setup
	Available: python 3.8.3
	Available: numpy 1.18.3
	Available: igraph 0.8.2
	Available: networkx 2.4
	opts.isomethod = 'python' is available
	```

## Steps (Mac)
> Lasted updated on 2020-04-29 (**but not verified!**)

1. Install `Python`
	- Check the following link for the Python versions that MATLAB officially supports: [MATLAB engine API for python](https://www.mathworks.com/help/matlab/matlab-engine-for-python.html)
	- You can check if Python 3.X is already installed using the command `python3 --version` in the terminal
	- To install Python 3.X, run the following command `brew install python3` in the terminal
	- If the command `python3 --version` produces an error after installation, run `brew link --overwrite python3`. This changes the default PATH to `/usr/local/Cellar/python3/`
	- Confirmed working with [**add**]
1. Confirm that `pip3` is installed by running the command `pip3` in the terminal
	- What is `pip3`? [Wikipedia page](https://en.wikipedia.org/wiki/Pip_(package_manager))
	- Confirmed working with [**add**]
1. Install `numpy` using the command `pip3 install numpy` in the terminal
	- Confirmed working with [**add**]
1. Install `igraph` using the command `pip3 install python-igraph` in the terminal
	- Confirmed working with [**add**]
1. Install `networkx` using the command `pip3 install networkx` in the terminal
	- Confirmed working with [**add**]
1. Ensure MATLAB is using the correct Python installation. If Python is unavailable, try to point MATLAB to the appropriate `python3` file
	- See [pyenv](https://www.mathworks.com/help/matlab/ref/pyenv.html) documentation (older MATLAB versions use [pyversion](https://www.mathworks.com/help/matlab/ref/pyversion.html))
	- ```pyenv('Version',executable)``` specifies the full path to the Python executable
	- Use `which python3` to determine installation location of your Python 3.X distribution
1. Run [INSTALL_PMA_project.m](../INSTALL_PMA_project.m) in MATLAB to determine if everything is setup correctly
	- The desired output in the command window is:
	```
	--- Checking Python setup
	Available: python 3.8.3
	Available: numpy 1.18.3
	Available: igraph 0.8.2
	Available: networkx 2.4
	opts.isomethod = 'python' is available
	```

![Python](https://www.python.org/static/community_logos/python-logo-generic.svg)