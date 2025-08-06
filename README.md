# fzf Windows Tools

A collection of pre-configured fzf commands for Windows.

## Installation dependencies

After running the installer you will be asked to install some dependencies:

- [`fzf`](https://github.com/junegunn/fzf): for fuzzy search
- [`fd`](https://github.com/sharkdp/fd): to find files
- [`bat`](https://github.com/sharkdp/bat): to display file previews

You can also do this manually via the following commands:

```shell
winget install -e --id junegunn.fzf
winget install -e --id sharkdp.fd
winget install -e --id sharkdp.bat
```

## Tools

### fzfd

`fzfd` is a tool to search for files by name.\
It is fast, has a preview window and it opens the file in explorer when you press enter.

The installer creates a shortcut on the Desktop which will search for files in your user folder.
