# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'csv_to_ledger/version'

Gem::Specification.new do |spec|
  spec.name          = "csv_to_ledger"
  spec.version       = CsvToLedger::VERSION
  spec.authors       = ["Jason Thompson"]
  spec.email         = ["jason@jthompson.ca"]
  spec.description   = %q{Converts csv bank statement to ledger format.}
  spec.summary       = %q{Converts csv bank statement to ledger format.}
  spec.homepage      = "http://github.com/jasonthompson/csv_to_ledger"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "sqlite3"
  spec.add_runtime_dependency "sequel"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
end
