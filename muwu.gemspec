Gem::Specification.new do |s|
  s.name        = 'muwu'
  s.version     = '4.0.0.alpha.0'
  s.date        = '2025-12-13'
  s.licenses    = ['GPL-3.0']
  s.summary     = 'Markup Writeup'
  s.description = 'Compile markup files (Markdown and YAML) into HTML.'
  s.authors     = ['Eli Harrison']
  s.homepage    = 'https://github.com/emh789/muwu'
  s.files       = Dir['bin/*'] + Dir['lib/**/*'] + Dir['test/*']
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 3.3'
  s.add_runtime_dependency 'commonmarker', '=> 0.23.10'
  s.add_runtime_dependency 'haml', '=> 7.1'
  s.add_runtime_dependency 'iso-639', '=> 0.3.7'
  s.add_runtime_dependency 'sassc', '=> 2.4.0'
  s.executables << 'muwu'
end
