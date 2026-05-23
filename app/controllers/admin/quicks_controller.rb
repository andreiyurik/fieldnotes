class Admin::QuicksController < Admin::BaseController
  def new
    @field_series = FieldSeries.new
  end

  def create
    @field_series = FieldSeries.new(quick_params)
    @field_series.kind = "photo"

    if @field_series.save
      photos_params.each_with_index do |photo, i|
        item = @field_series.field_items.create!(kind: "photo", position: i + 1)
        item.photo.attach(photo)
      end
      redirect_to edit_admin_field_path(@field_series), notice: "Draft created — add details"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def quick_params
    params.require(:field_series).permit(:title, :location)
  end

  def photos_params
    params.dig(:field_series, :photos) || []
  end
end
