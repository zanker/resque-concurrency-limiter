guard("rspec", :all_after_pass => false, :cli => "--fail-fast --color") do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) {|match| "spec/concurrency_limiter_spec.rb"}
end