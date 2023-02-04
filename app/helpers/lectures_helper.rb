module LecturesHelper
  def lecture_title(lecture)
    lecture[:title].sub(/^\d+\.\s+/, '')
  end

  def lecture_url(lecture)
    if lecture[:slug]
      "/lectures/#{lecture[:slug]}"
    else
      lecture[:url]
    end
  end

  def lecture_video_links(lecture)
    video_links = (lecture[:videos] || []).map.with_index do |url, video_index|
      link_to "Видео #{video_index + 1}", url, target: '_blank'
    end

    video_links.join(', ').html_safe
  end
end
