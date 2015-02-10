guard :rspec, cmd: 'bundle exec rspec', all_after_pass: true, failed_mode: :focus do
  watch(%r{^spec/factory_girl_library/.+_spec\.rb$})
  watch(%r{^lib/factory_girl_library/(.+)\.rb$})     { |m| "spec/factory_girl_library/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
  watch('spec/factory_girl_library_spec.rb')  { "spec" }
end
