#!/usr/bin/env node
var path = require('path');
var rootPath = process.argv[2];

try {
  var packageJson = require(path.join(rootPath, 'package.json'));
  var scripts = Object.keys(packageJson.scripts);
  process.stdout.write(scripts.join('\n'));
} catch(e) {}
