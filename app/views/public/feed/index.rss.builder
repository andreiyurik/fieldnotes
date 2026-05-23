xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "Fieldnotes"
    xml.link root_url
    xml.description "Essays, builds, and field notes"
    xml.language "en"

    feed_items = @essays.map { |e| [e, e.published_at] } +
                 @series.map { |s| [s, s.created_at] }

    feed_items.sort_by { |_, date| date }.reverse_each do |item, _|
      xml.item do
        case item
        when Essay
          xml.title item.title
          xml.link essay_url(slug: item.slug)
          xml.description item.content.to_s
          xml.pubDate item.published_at.to_fs(:rfc822)
          xml.guid essay_url(slug: item.slug)
        when FieldSeries
          xml.title item.title
          xml.link field_url(slug: item.slug)
          xml.description item.description.to_s
          xml.pubDate item.created_at.to_fs(:rfc822)
          xml.guid field_url(slug: item.slug)
        end
      end
    end
  end
end
