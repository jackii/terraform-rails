# AWS Command Line Interface

The AWS CLI is an open source tool that provides commands for interacting with AWS services.

## pyenv

pyenv is Python Version Management. pyenv lets you easily switch multiple versions of python

See https://github.com/pyenv/pyenv

## virtualenv

virtualenv is a tool to create isolated Python environments.

See https://virtualenv.pypa.io/en/latest/

### Installation

Install `virtualenv` if you have not installed

```
pip install --user virtualenv
```

If you have installed `virtualenv`

```
pyenv virtualenv
```

See list of virtual envs

```
pyenv virtualenvs
```


## awscli

Install `awscli` using `pyenv` and `virtualenv`.

```
# create a virtualenv
pyenv virtualenv 3.5.1 awscli

# activate the virtualenv
pyenv activate awscli
```

And then install `awscli`

```
pip install --upgrade awscli
```

Check

```
$ aws --version
aws-cli/1.16.43 Python/3.5.1 Darwin/16.7.0 botocore/1.12.33
```


References:

https://docs.aws.amazon.com/cli/latest/userguide/awscli-install-virtualenv.html

