# frozen_string_literal: true

require_relative 'lib/forme/bs4/version'

Gem::Specification.new do |spec|
  spec.name          = 'forme-bs4'
  spec.version       = Forme::Bs4::VERSION
  spec.authors       = ['Vasily Kolesnikov']
  spec.email         = ['re.vkolesnikov@gmail.com']

  spec.summary       = 'Bootstrap 4 extensinon for Forme'
  spec.description   = 'Bootstrap 4 extensinon for Forme'
  spec.homepage      = 'https://github.com/v-kolesnikov/forme-bs4'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/v-kolesnikov/forme-bs4'
  spec.metadata['changelog_uri'] = 'https://github.com/v-kolesnikov/forme-bs4'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  end

  spec.require_paths = ["lib"]
end
