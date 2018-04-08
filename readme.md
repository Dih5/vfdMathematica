# VFD package for Mathematica


Interface to use the [VFD tools](https://github.com/dih5/vfd) with Mathematica.



* [Features](#features)
* [Usage](#usage)
* [Installation](#installation)
    * [Automatic installation](#automatic-installation)
    * [Manual installation](#manual-installation)
    * [No installation](#no-installation)
* [Documentation](#documentation)
* [Compatibility](#compatibility)
* [Contributing](#contributing)
* [Versioning](#versioning)


## Features
* Create VFD files from Mathematica.
* Call the vfd application from Mathematica.
* As a corollary, you can use matplotlib from Mathematica.


![alt tag](https://raw.github.com/dih5/vfdMathematica/master/demo.png)

## Installation


### Automatic installation

To install the VFD package evaluate:
```Mathematica
Get["https://raw.githubusercontent.com/dih5/vfdMathematica/master/BootstrapInstall.m"]
```

This method uses [MathematicaBootstrapInstaller](https://github.com/jkuczm/MathematicaBootstrapInstaller) and will also install
[ProjectInstaller](https://github.com/lshifr/ProjectInstaller) package if you don't have it already installed.

To load the package evaluate: ``Needs["VFD`"]``.


### Manual installation

1. Download latest released
   [vfdMathematica.zip](https://github.com/dih5/vfdMathematica/releases/download/v0.1.0/vfdMathematica.zip)
   file.

2. Extract downloaded `vfdMathematica.zip` to any directory which is on the Mathematica `$Path`,
   e.g. to install for the current user `FileNameJoin[{$UserBaseDirectory,"Applications"}]`,
   for all users `FileNameJoin[{$BaseDirectory,"Applications"}]`.

3. To load the package evaluate: ``Needs["VFD`"]``.


### No installation

To use package directly from the Web, without installation, evaluate:
```Mathematica
Get["https://raw.githubusercontent.com/dih5/vfdMathematica/master/VFD/VFD.m"]
```

Note that with this method of initialization
package documentation will not be available in Mathematica Documentation Center.


## Documentation

This application comes with documentation integrated with the Mathematica Documentation Center.
After installation search for "VFD" in documentation center
or press `F1` key with cursor on name of any of symbols introduced by this application.




## Compatibility

The package requires Mathematica > 10.0 to work.



## Contributing

If you find any bugs or have a feature request you may create an
[issue on GitHub](https://github.com/dih5/vfdMathematica/issues).

Feel free to fork and send pull requests if you want to, all contributions are welcome.



## Versioning

This is not a mature project. The API is unstable.
