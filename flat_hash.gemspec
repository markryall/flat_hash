Gem::Specification.new do |spec|
  spec.name = 'flat_hash'
  spec.version = '0.1.1'
  spec.summary = 'trivial but predictable serialisation for hashes'
  spec.description = <<-EOF
Hash serialisation that writes key/value pairs in a predictable order
EOF

  spec.authors << 'Mark Ryall'
  spec.email = 'mark@ryall.name'
  spec.homepage = 'http://github.com/markryall/flat_hash'
 
  spec.files = Dir['lib/**/*'] + Dir['spec/**/*'] + Dir['bin/*'] + ['README.rdoc', 'MIT-LICENSE', 'HISTORY.rdoc', 'Rakefile', '.gemtest']

  spec.add_dependency 'grit', '~>2'

  spec.add_development_dependency 'rake', '~>0'
  spec.add_development_dependency 'rspec', '~>2'
end
