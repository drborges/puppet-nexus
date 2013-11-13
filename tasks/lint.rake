require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"
PuppetLint.configuration.ignore_paths = ["pkg/**/*.pp", "spec/**/*"]
