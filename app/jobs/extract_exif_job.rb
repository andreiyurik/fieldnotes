class ExtractExifJob < ApplicationJob
  queue_as :default

  def perform(field_item_id)
    item = FieldItem.find(field_item_id)
    return unless item.photo.attached?

    item.photo.open do |file|
      data = read_exif(file.path)
      next unless data

      item.update!(
        camera_make:   data["Make"],
        camera_model:  data["Model"],
        lens:          data["LensModel"] || data["Lens"],
        focal_length:  data["FocalLength"]&.to_s,
        aperture:      data["FNumber"] ? "f/#{data["FNumber"]}" : nil,
        shutter_speed: data["ExposureTime"]&.to_s,
        iso:           data["ISO"]&.to_i,
        taken_at:      parse_exif_date(data["DateTimeOriginal"]),
        gps_latitude:  data["GPSLatitude"],
        gps_longitude: data["GPSLongitude"]
      )

      if item.position == 1 && data["GPSLatitude"] && item.field_series.latitude.blank?
        item.field_series.update!(
          latitude:  data["GPSLatitude"],
          longitude: data["GPSLongitude"]
        )
      end
    end
  end

  private

  def read_exif(path)
    JSON.parse(IO.popen([ "exiftool", "-j", "-n", path ], &:read))&.first
  rescue => e
    Rails.logger.error("ExtractExifJob EXIF read failed: #{e.message}")
    nil
  end

  def parse_exif_date(value)
    return unless value
    Time.strptime(value, "%Y:%m:%d %H:%M:%S")
  rescue ArgumentError
    nil
  end
end
