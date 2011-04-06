desc "Check for Deals to Open"
task :open_deals do
  sh %Q{ruby script/runner -e production "app = ActionController::Integration::Session.new; app.get 'admins/open_the_deals'"}
end
