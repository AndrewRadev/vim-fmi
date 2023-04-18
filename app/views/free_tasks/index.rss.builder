xml.instruct! :xml, version: "1.0", encoding: 'UTF-8'
xml.rss 'version' => '2.0', 'xmlns:dc' => 'http://purl.org/dc/elements/1.1/', 'xmlns:content' => 'http://purl.org/rss/1.0/modules/content' do
  xml.channel do
    xml.title       "#{Rails.application.config.course_name} :: Упражнения"
    xml.link        tasks_url
    xml.description "Упражнения от курса \"#{Rails.application.config.course_name}\""
    xml.language    'bg-BG'

    @free_tasks.each do |task|
      xml.item do
        xml.title   task.label
        xml.link    task_path(task, only_path: false)

        xml.description { xml.cdata! Markup.format(task.description || '') }
        xml.tag!('content:encoded') { xml.cdata! Markup.format(task.description) }

        xml.pubDate task.opens_at.rfc2822
        xml.guid    task_path(task, only_path: false)
      end
    end
  end
end
