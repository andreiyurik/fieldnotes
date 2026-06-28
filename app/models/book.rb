require "net/http"
require "json"

class Book < ApplicationRecord
  STATUSES = %w[reading completed abandoned].freeze

  has_rich_text :review

  before_validation :fetch_metadata_from_isbn, on: :create

  validates :title,  presence: true
  validates :author, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :rating, inclusion: { in: 1..5 }, allow_nil: true

  scope :completed, -> { where(status: "completed") }
  scope :reading,   -> { where(status: "reading") }
  scope :by_year,   -> { order(year_read: :desc) }

  def cover_image_url
    return cover_url if cover_url.present?

    "https://covers.openlibrary.org/b/isbn/#{isbn}-L.jpg" if isbn.present?
  end

  private

  def fetch_metadata_from_isbn
    return if isbn.blank?

    data = self.class.lookup_isbn(isbn.strip)
    return unless data

    self.title     = data[:title]     if title.blank?
    self.author    = data[:author]    if author.blank?
    self.cover_url = data[:cover_url] if cover_url.blank?
  end

  OPEN_LIBRARY_URL   = "https://openlibrary.org/api/books"
  COVER_URL_TEMPLATE = "https://covers.openlibrary.org/b/isbn/%s-L.jpg"

  def self.lookup_isbn(isbn, http: Net::HTTP)
    Rails.cache.fetch("open_library:#{isbn}", expires_in: 7.days) do
      uri  = URI("#{OPEN_LIBRARY_URL}?bibkeys=ISBN:#{isbn}&format=json&jscmd=data")
      resp = http.get_response(uri)
      return nil unless resp.is_a?(Net::HTTPSuccess)

      book = JSON.parse(resp.body)["ISBN:#{isbn}"]
      return nil if book.nil? || book.empty?

      {
        title:     book["title"],
        author:    book.dig("authors", 0, "name"),
        cover_url: COVER_URL_TEMPLATE % isbn,
        year:      book["publish_date"]&.then { |d| d.scan(/\d{4}/).first&.to_i }
      }
    end
  rescue => e
    Rails.logger.error("Book.lookup_isbn error: #{e.message}")
    nil
  end
end
