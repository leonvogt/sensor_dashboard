namespace :housekeeping do
  desc 'Renew guest data'
  task guest_data: :environment do
    # Delete Guest User, so that all associated data will be deleted as well
    User.find_by_email!(User::GUEST_EMAIL).destroy!
    Rake::Task['seed_data:for_guest_user'].invoke
  end
end
