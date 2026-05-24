class FieldSeries < ApplicationRecord
  include Sluggable
  include Taggable

  KINDS = %w[photo video mixed].freeze

  has_many :field_items, dependent: :destroy
  has_one_attached :cover do |attachable|
    attachable.variant :thumb, resize_to_fill:  [ 800, 600], format: :avif, saver: { quality: 75 }
    attachable.variant :hero,   resize_to_fill:  [1600,  900], format: :avif, saver: { quality: 85 }
    attachable.variant :medium, resize_to_limit: [ 800,  600], format: :avif, saver: { quality: 80 }
    attachable.variant :full,   resize_to_limit: [1920, 1080], format: :avif, saver: { quality: 85 }
    attachable.variant :retina, resize_to_limit: [2560, 1920], format: :avif, saver: { quality: 85 }
  end

  validates :title, presence: true
  validates :kind,  inclusion: { in: KINDS }
end
