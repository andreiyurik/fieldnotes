module ApplicationHelper
  NAV_LINK_BASE   = "relative text-muted font-medium text-[0.9375rem] px-3 py-2 rounded-lg " \
                    "transition hover:text-ink hover:bg-code-bg"
  NAV_LINK_ACTIVE = "text-ink after:absolute after:bottom-[3px] after:left-3 after:right-3 " \
                    "after:h-0.5 after:bg-accent after:rounded-sm after:content-['']"

  ADMIN_NAV_LINK_BASE   = "text-stone-400 text-sm px-2.5 py-1.5 rounded-md transition hover:text-white hover:bg-white/10 no-underline"
  ADMIN_NAV_LINK_ACTIVE = "text-white bg-white/10"

  def admin_nav_class(cn)
    active = controller_name == cn
    [ADMIN_NAV_LINK_BASE, active ? ADMIN_NAV_LINK_ACTIVE : nil].compact.join(" ")
  end

  def nav_link_class(controller_name_suffix)
    active = controller_path.end_with?(controller_name_suffix)
    [NAV_LINK_BASE, active ? NAV_LINK_ACTIVE : nil].compact.join(" ")
  end

  def meta_tags(title:, description:, image: nil, type: :website, published_at: nil)
    render "shared/meta_tags",
      title: title,
      description: description,
      image: image,
      type: type,
      published_at: published_at
  end

  # AVIF-only responsive picture tag.
  # Uses :medium (800w) and :full (1920w) named variants.
  def picture_tag(attachment, alt:, sizes: "(max-width: 768px) 100vw, 90vw", loading: "lazy")
    return "" unless attachment.attached?

    srcset = [
      "#{url_for(attachment.variant(:medium))} 800w",
      "#{url_for(attachment.variant(:full))}   1920w",
      "#{url_for(attachment.variant(:retina))} 2560w"
    ].join(", ")

    tag.picture do
      concat tag.source(type: "image/avif", srcset: srcset, sizes: sizes)
      concat image_tag(attachment.variant(:full), alt: alt, loading: loading)
    end
  end

  # Returns watermarked photo if available, otherwise original photo.
  def field_item_photo(item)
    item.watermarked_photo.attached? ? item.watermarked_photo : item.photo
  end

  BADGE_VARIANTS = {
    reading:   "bg-purple-bg text-purple-text",
    completed: "bg-green-bg text-green-text",
    abandoned: "bg-surface text-muted",
    published: "bg-green-bg text-green-text",
    draft:     "bg-amber-bg text-amber-text",
    active:    "bg-green-bg text-green-text",
    paused:    "bg-amber-bg text-amber-text",
    archived:  "bg-surface text-muted",
    photo:     "bg-blue-bg text-blue-text",
    video:     "bg-purple-bg text-purple-text",
    mixed:     "bg-amber-bg text-amber-text",
  }.freeze

  def badge(status)
    base = "inline-block px-2.5 py-0.5 rounded-full text-[0.6875rem] font-bold tracking-wider uppercase"
    variant = BADGE_VARIANTS.fetch(status.to_sym, "bg-surface text-muted")
    content_tag(:span, status.to_s.capitalize, class: "#{base} #{variant}")
  end
end
