xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "Fieldnotes"
    xml.link root_url
    xml.description "Essays, builds, and field notes"
    xml.language "en"

    @essays.each do |essay|
      xml.item do
        xml.title essay.title
        xml.link essay_url(slug: essay.slug)
        xml.description essay.content.to_s
        xml.pubDate essay.published_at.to_fs(:rfc822)
        xml.guid essay_url(slug: essay.slug)
      end
    end

    @series.each do |series|
      xml.item do
        xml.title series.title
        xml.link field_url(slug: series.slug)
        xml.description series.description.to_s
        xml.pubDate series.created_at.to_fs(:rfc822)
        xml.guid field_url(slug: series.slug)
      end
    end
  end
end
