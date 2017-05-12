#!/usr/bin/env node
var path = require('path');
var packageJsonPath = path.join(process.argv[2], 'package.json');
var paths = process.argv[3] || '';

try {
  var packageJson = require(packageJsonPath);
  if (paths) {
    var keys = paths.split(',')
        .reduce(function(acc, p) {
            var keysToAdd = Object.keys(
                p.split('.')
                    .reduce(function(d, seg) {
                        return d[seg] || {};
                    }, packageJson)
            );

            return acc.concat(keysToAdd);;
        }, []);
  } else {
      var keys = Object.keys(packageJson);
  }

  process.stdout.write(keys.join('\n'));
} catch(e) {}
