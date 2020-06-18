$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "banhammer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "banhammer"
  spec.version     = Banhammer::VERSION
  spec.authors     = ["crimson-knight"]
  spec.email       = ["13125514+crimson-knight@users.noreply.github.com"]
  spec.homepage    = "https://www.crimsonknightstudios.com/banhammer"
  spec.summary     = "Bring on the BANHAMMER! Because f%$k spam! I hate spammers, and since I run very content-heavy sites that rely on the quality of user generated content being REAL, I made a spam filtering system. Banhammer currently handles filtering out spammy submissions and data passed into Rails."
  spec.description = "A smart, flexible way of dealing with bots, spammers and monitoring content for things you don't want."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    #spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.x", "<= 6.x"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'factory_bot_rails'
end
