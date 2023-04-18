require 'csv'

desc "Migrate existing closed tasks to free tasks"
task create_free_tasks: :environment do
  admin = User.where(admin: true).find_by!(name: 'Андрей')

  Task.where('closes_at < ?', Time.current).in_chronological_order.find_each do |task|
    next if FreeTask.exists?(label: task.label)

    FreeTask.create!({
      label: task.label,
      user: admin,
      **task.slice(:description, :input, :output, :filetype, :file_extension)
    })
  end
end
