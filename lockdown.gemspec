# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{lockdown}
  s.version = "1.6.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andrew Stone"]
  s.date = %q{2009-11-28}
  s.description = %q{Restrict access to your controller actions.  Supports basic model level restrictions as well}
  s.email = %q{andy@stonean.com}
  s.extra_rdoc_files = [
    "README.txt"
  ]
  s.files = [
    ".gitignore",
     "README.txt",
     "Rakefile",
     "lib/lockdown.rb",
     "lib/lockdown/context.rb",
     "lib/lockdown/database.rb",
     "lib/lockdown/errors.rb",
     "lib/lockdown/frameworks/rails.rb",
     "lib/lockdown/frameworks/rails/controller.rb",
     "lib/lockdown/frameworks/rails/view.rb",
     "lib/lockdown/helper.rb",
     "lib/lockdown/orms/active_record.rb",
     "lib/lockdown/permission.rb",
     "lib/lockdown/references.rb",
     "lib/lockdown/rspec_helper.rb",
     "lib/lockdown/rules.rb",
     "lib/lockdown/session.rb",
     "lib/lockdown/system.rb",
     "rails_generators/lockdown/lockdown_generator.rb",
     "rails_generators/lockdown/templates/app/controllers/permissions_controller.rb",
     "rails_generators/lockdown/templates/app/controllers/sessions_controller.rb",
     "rails_generators/lockdown/templates/app/controllers/user_groups_controller.rb",
     "rails_generators/lockdown/templates/app/controllers/users_controller.rb",
     "rails_generators/lockdown/templates/app/helpers/permissions_helper.rb",
     "rails_generators/lockdown/templates/app/helpers/user_groups_helper.rb",
     "rails_generators/lockdown/templates/app/helpers/users_helper.rb",
     "rails_generators/lockdown/templates/app/models/permission.rb",
     "rails_generators/lockdown/templates/app/models/profile.rb",
     "rails_generators/lockdown/templates/app/models/user.rb",
     "rails_generators/lockdown/templates/app/models/user_group.rb",
     "rails_generators/lockdown/templates/app/views/permissions/index.html.erb",
     "rails_generators/lockdown/templates/app/views/permissions/show.html.erb",
     "rails_generators/lockdown/templates/app/views/sessions/new.html.erb",
     "rails_generators/lockdown/templates/app/views/user_groups/edit.html.erb",
     "rails_generators/lockdown/templates/app/views/user_groups/index.html.erb",
     "rails_generators/lockdown/templates/app/views/user_groups/new.html.erb",
     "rails_generators/lockdown/templates/app/views/user_groups/show.html.erb",
     "rails_generators/lockdown/templates/app/views/users/edit.html.erb",
     "rails_generators/lockdown/templates/app/views/users/index.html.erb",
     "rails_generators/lockdown/templates/app/views/users/new.html.erb",
     "rails_generators/lockdown/templates/app/views/users/show.html.erb",
     "rails_generators/lockdown/templates/config/initializers/lockit.rb",
     "rails_generators/lockdown/templates/db/migrate/create_admin_user.rb",
     "rails_generators/lockdown/templates/db/migrate/create_permissions.rb",
     "rails_generators/lockdown/templates/db/migrate/create_profiles.rb",
     "rails_generators/lockdown/templates/db/migrate/create_user_groups.rb",
     "rails_generators/lockdown/templates/db/migrate/create_users.rb",
     "rails_generators/lockdown/templates/lib/lockdown/README",
     "rails_generators/lockdown/templates/lib/lockdown/init.rb",
     "spec/lockdown/context_spec.rb",
     "spec/lockdown/database_spec.rb",
     "spec/lockdown/frameworks/rails/controller_spec.rb",
     "spec/lockdown/frameworks/rails/view_spec.rb",
     "spec/lockdown/frameworks/rails_spec.rb",
     "spec/lockdown/permission_spec.rb",
     "spec/lockdown/rspec_helper_spec.rb",
     "spec/lockdown/rules_spec.rb",
     "spec/lockdown/session_spec.rb",
     "spec/lockdown/system_spec.rb",
     "spec/lockdown_spec.rb",
     "spec/rcov.opts",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://stonean.com/wiki/lockdown}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{lockdown}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Authorization system for Rails 2.x}
  s.test_files = [
    "spec/lockdown/context_spec.rb",
     "spec/lockdown/database_spec.rb",
     "spec/lockdown/frameworks/rails/controller_spec.rb",
     "spec/lockdown/frameworks/rails/view_spec.rb",
     "spec/lockdown/frameworks/rails_spec.rb",
     "spec/lockdown/permission_spec.rb",
     "spec/lockdown/rspec_helper_spec.rb",
     "spec/lockdown/rules_spec.rb",
     "spec/lockdown/session_spec.rb",
     "spec/lockdown/system_spec.rb",
     "spec/lockdown_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end

