namespace :after_party do
  desc 'Deployment task: add_first_user'
  task add_first_user: :environment do
    puts "Running deploy task 'add_first_user'"

    # Put your task implementation HERE.
    User.create(name: "admin",email: "admin@admin.com", password: "password", role: 1)

    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(_FILE_).timestamp
  end
end