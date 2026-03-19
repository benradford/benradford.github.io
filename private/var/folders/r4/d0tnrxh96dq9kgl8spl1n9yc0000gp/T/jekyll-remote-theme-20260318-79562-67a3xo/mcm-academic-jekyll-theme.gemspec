# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "mcm-academic-jekyll-theme"
  spec.version       = "0.1.0"
  spec.authors       = ["Benjamin J. Radford"]
  spec.summary       = "A mid-century modern academic Jekyll theme."
  spec.homepage      = "https://github.com/BJR113/mcm-academic-jekyll-theme"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select do |f|
    f.match(%r!^(assets|_layouts|_includes|_sass)/!i)
  end

  spec.add_runtime_dependency "jekyll", ">= 3.5", "< 5.0"
  spec.add_runtime_dependency "jekyll-paginate", "~> 1.1"
end
