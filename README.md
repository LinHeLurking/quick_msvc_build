# Quick Build using MSVC

If you are using Visual Studio to handle a simple and small C/C++ program, it might be
very bothering to spending a lot of time setting up a solution and building only a small number of files.  

You know that, with gcc, we could compile source code files by typing the command:

```shell
gcc hello_world.cpp -o hello
```

However, there's no way to perform such simple compilation with MSVC.
So, here comes this script.  

With this script, you can achieve it with following PowerShell command:

```shell
Quick-Build.ps1 hello_world.cpp -o hello
```

## Some details

This script depends on cmake, so cmake is supposed to be available in ``$ENV:PATH``.

The script is smart enough to handle file changes(at least for small projects), so there is no need to generate cmake cache every time even if input files have been changed.

## Examples

This is our simple hello_world.cpp.

```cpp
#include <iostream>

int main(){
    std::cout<<"Hello World!"<<std::endl;
    return 0;
}
```

Then we build it with Quick-Build.ps1

```shell
Quick-Build.ps1 .\hello_world.cpp -o hello
```

If we rename that file, then rebuild it. No cmake step of generating cache is needed.

```shell
cp .\hello_world.cpp another_hello.cpp
Quick-Build.ps1 .\another_hello.cpp -o hello
```

Only changing the output name leads similar results.
