class Admin::Settings::WatermarkRegenerationsController < Admin::BaseController
  def create
    count = 0
    FieldItem.includes(:photo_attachment).find_each do |item|
      next unless item.photo.attached?
      ImageVariantJob.perform_later(item, watermark: true)
      count += 1
    end
    redirect_to edit_admin_settings_path, notice: "Queued watermark regeneration for #{count} photo(s)"
  end
end
