namespace :import do

  desc 'Import users from csv'
  task users: :environment do
    import = User::Import.new file: File.open('users.csv')
    import.process!
    puts "Imported #{import.imported_count} users"
    puts import.erros.full_messages
  end
end
