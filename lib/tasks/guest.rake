namespace :guests do
 desc 'Remove Guest 1 week older'
 task cleanup: :environment do
   User.where(guest: true).where('created_at < ?', 1.week.ago).destroy_all
 end
end