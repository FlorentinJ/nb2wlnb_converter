# Open Mathematica Notebooks with VS Code 

These two scripts are designed to convert Mathematica Notebook to the ``.wlnb`` format, that can be understood by the [wolfram-language-notebook extension](https://github.com/njpipeorgan/wolfram-language-notebook).

## Getting Started

 - Make sure ``wolframscript`` is installed and available on the terminal. Note that it is freely available on https://www.wolfram.com/engine/. 
 - Place the two programs in a folder on PATH.
 - Run ``nb2wlnb /path/to/notebook.nb``

In some cases, the formatting of the original notebook cannot be properly translated. In that case, you can try the following:

 - Open the notebook using Mathematica. This requires a valid license.
 - Save the notebook as a ``.m`` file.
 - Run ``nb2wlnb /path/to/notebook.m``

## Features

**``.nb`` to ``.m`` converter**: The program nb2m is a wolframscript executable that can convert a notebook to a module without a payed Mathematica licence. In addition to standard wolfram language, it only supports basic notebook formatting options: exponents, subscripts, square roots and fractions. Most text cells are also supported, but outputs are lost in the conversion.

**``.m`` to ``.wlnb`` converter**: The program nb2wlnb can convert any ``.m`` package into a notebook readable by VIsual Studio Code, through the wolfram-language-notebook extension.

## FAQ

**nb2wlnb fails with a ``NotImplentedError``.**
 - Try reducing the formatting of the notebook as much as possible. Due to the limited fontsizes available in markdown, the only supported cell formats are: Input, Title, Chapter, Section, Subsection, Subsubsection, and Text.

**nb2m fails because of licensing issues.**
 - If you don't have Mathematica installed, you need to register on the [Wolfram website](https://www.wolfram.com/engine/) in order to apply for a free wolframscript key.
 - The free key only allows for 2 simultaneous instances of ``wolframscript``. If you have some notebooks running, you might need to quit the kernel before running the script.

**There is unreadable code with ``Box`` everywhere.**
 - Try removing or flattening any notebook-only notations such as matrices, limits, integrals, pictures, etc.
 - If everything fails, save the notebook as a ``.m`` file and convert that.

**My code worked in Mathematica but not in VS Code.**
 - Front-end function such as ``NotebookDirectory[]`` are not supported by the wolfram-language-notebook extension.

**How does it work?**
 - Converting from ``.nb`` to ``.m`` works by flattening recursively the ``RowBox`` expressions that compose the notebook input cells into a single string. This is implemented using a single ``ReplaceRepeated``. Text cells are simpler since they are already represented by strings.
 - Once everything has been converted to a string, the conversion to ``.wlnb`` is easy. The various sizes of text are achieved by prefixing Title/Chapter/Section/Subsection/etc cells with a various number of ``#``.
 
 ## Special thanks
  Special thanks to everyone behind the [Wolfram Language in VS Code project](https://github.com/njpipeorgan/wolfram-language-notebook)
 
