namespace :housekeeping do
  desc 'Renew guest data'
  task guest_data: :environment do
    guest_user = User.find_by_email!(User::GUEST_EMAIL)
    guest_user.devices.each { |device| DestroyDevice.new(device).destroy! }
    Rake::Task['seed_data:for_guest_user'].invoke
  end
end
