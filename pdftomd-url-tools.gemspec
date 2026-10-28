Gem::Specification.new do |spec|
  spec.name = 'pdftomd-url-tools'
  spec.version = '0.1.0'
  spec.summary = 'Free in-browser pdf to md tool. Drop a text PDF, preview Markdown, copy or download—files stay on your device. No account required.'
  spec.description = 'Free in-browser pdf to md tool. Drop a text PDF, preview Markdown, copy or download—files stay on your device. No account required.'
  spec.authors = ['wangneo276-lgtm']
  spec.homepage = 'https://pdftomd.tools/'
  spec.license = 'MIT'
  spec.files = Dir['ruby/lib/**/*.rb', 'README.md', 'LICENSE']
  spec.require_paths = ['ruby/lib']
  spec.required_ruby_version = '>= 3.0'
  spec.metadata = {
    'homepage_uri' => 'https://pdftomd.tools/',
    'source_code_uri' => 'https://github.com/wangneo276-lgtm/pdftomd-url-tools'
  }
end
