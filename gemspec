Gem::Specification.new do |spec|
  spec.name = 'flat_hash'
  spec.version = '0.0.1'
  spec.summary = "trivial but predictable serialisation for hashes"
  spec.description = <<-EOF
Hash serialisation that writes key/value pairs in a predicatable order
EOF

  spec.authors << 'Mark Ryall'
  spec.email = 'mark@ryall.name'
  spec.homepage = 'http://github.com/markryall/flat_hash'
 
  spec.files = Dir['lib/**/*'] + ['README.rdoc', 'MIT-LICENSE']

  spec.add_development_dependency 'rake', '~>0.8.7'
  spec.add_development_dependency 'rspec', '~>1.3.0'
  spec.add_development_dependency 'gemesis', '~>0.0.3'
end