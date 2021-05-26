# Demo showing that static linking again libheif doesn't work

## Windows
* make sure Visual Studio 2019 is installed with C++, CMake and Ninja workloads
* Open the "x64 Native Tools Command Prompt for VS2019"
* Call `batch.bat`. This will fail with linker errors.
* Call `batch.bat 1`. This will use the patched fork, and produce an executable that prints the version of `libheif`

## Linux
* TODO



