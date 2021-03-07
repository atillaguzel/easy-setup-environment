# About

Tools to speed up setting environment from scratch


</br>

## System Environment - Setup

Install `rbenv`
```command
brew install rbenv
```

Install `conda` for [Apple silicon](https://conda-forge.org/blog/posts/2020-10-29-macos-arm64/)
```command
bash ~/Downloads/Miniforge3-MacOSX-arm64.sh
```

Create `conda` env
```command
conda create -n <ENV_NAME> python=3.9
```

</br>

## Pip - Configuration


Install multiple packages:
```command
python -m pip install --user --upgrade -r requirements.txt
```

Export current environment configuration:
```command
python -m pip freeze
```

To search for a package:
```command
python -m pip search <PACKAGE_NAME>
```

Show package information:
```command
python -m pip show <PACKAGE_NAME>
```

Uninstall package:
```command
python -m pip uninstall <PACKAGE_NAME>
```

</br>

## Zsh - Configuration

Install homebrew cask fontSize
```command
$ brew tap homebrew/cask-fonts                  # you only have to do this once!
$ brew cask install font-meslo-nerd-font
```

</br>

## Jupyter Lab - Configuration

Runing Jupyter Lab as a desktop application is simple. Generate jupyter lab configuration if you haven't done before.
```command
jupyter lab --generate-config
```

Add the line below to your configuration file located here `~/.jupyter/jupyter_notebook_config.py`:
```
c.LabApp.browser = '/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --app=%s'
```

</br>

## Links

- [Installing Conda on macOS](https://docs.anaconda.com/anaconda/install/mac-os/)
- [macOS ARM builds on conda-forge](https://conda-forge.org/blog/posts/2020-10-29-macos-arm64/)
- [Elegant theme dev experience with zsh and hyper terminal](https://www.robertcooper.me/elegant-development-experience-with-zsh-and-hyper-terminal)
- [Hyper](https://hyper.is/)
- [Spaceship-prompt](https://denysdovhan.com/spaceship-prompt/#features)
- [Hyper night owl theme](https://github.com/pbomb/hyper-night-owl)
- [Publish packages to npm](https://zellwk.com/blog/publish-to-npm/)
- [Packaging Python Projects](https://packaging.python.org/tutorials/packaging-projects/)
