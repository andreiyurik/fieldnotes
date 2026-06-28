class Admin::SettingsController < Admin::BaseController
  before_action :set_setting

  def edit
  end

  def update
    if @setting.update(setting_params)
      redirect_to edit_admin_settings_path, notice: "Settings saved"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_setting
    @setting = SiteSetting.current
  end

  def setting_params
    params.require(:site_setting).permit(
      :watermark_enabled, :watermark_position, :watermark_opacity, :watermark
    )
  end
end
