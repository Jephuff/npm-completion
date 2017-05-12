# npm-completion
bash and zsh completion script for npm package names.

this script will list/complete package names for remove, update and install commands.
when there are multiple options it will list them.
```bash
npm install npm-comp[tab]
#output
#npm-compact	npm-compat	npm-completion	npm-comp-stat-www
```
when theres only one possible option it will complete it.
```bash
npm install npm-compl[tab]
#result
#npm install npm-completion
```
install will look at all package names on npm. Remove and update will look at locally installed packages(if -g is in the command, it will look at global packages).

package list updated at 3am ET everyday so it's recommended that you run the update command periodically.
```bash
npm-completion-update
```

## SETUP

### manually

#### install
```bash
$ git clone https://github.com/Jephuff/npm-completion
$ ./npm-completion/setup
```

#### update
```bash
$ ./npm-completion/update
```

### npm

#### install
```bash
$ npm i -g npm-completion
```

if you use sudo to install, you will need to run the setup script manually

```bash
$ npm-completion-setup
```

#### update
```bash
$ npm-completion-update
```

### windows users
you will need to download the windows version
```bash
$ npm i -g npm-completion@windows
$ npm-completion-setup
```

## Options
set INCLUDE_YARN_COMPLETION to false in your .bashrc above the npm-completion lines to exclude yarn completion

```
INCLUDE_YARN_COMPLETION=false
# added for npm-completion https://github.com/Jephuff/npm-bash-completion
```