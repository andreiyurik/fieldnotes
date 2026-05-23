module AdminHelper
  def admin_label_class
    "block text-xs font-semibold uppercase tracking-[0.05em] text-[#57534E] mb-1.5"
  end

  def admin_input_class
    "w-full px-3 py-2 border border-[#D6D3D1] rounded-md text-sm text-[#1C1917] " \
    "bg-white focus:outline-none focus:border-accent focus:ring-2 focus:ring-accent/15 transition"
  end

  def admin_hint_class
    "mt-1 text-xs text-[#78716C]"
  end

  def btn_primary_class
    "inline-block px-4 py-2 bg-accent text-white rounded-md text-sm font-medium " \
    "cursor-pointer border-none hover:bg-[#D4631E] transition no-underline"
  end

  def btn_secondary_class
    "inline-block px-4 py-2 bg-[#E8E3DC] text-[#1C1917] rounded-md text-sm font-medium " \
    "cursor-pointer border-none hover:bg-[#DDD8D0] transition no-underline"
  end

  def btn_danger_class
    "inline-block px-3 py-1.5 bg-[#FEE2E2] text-[#991B1B] rounded-md text-xs font-medium " \
    "cursor-pointer border-none hover:bg-[#FECACA] transition no-underline"
  end

  def admin_table_th_class
    "text-left text-[0.6875rem] font-semibold uppercase tracking-[0.07em] " \
    "text-[#78716C] px-4 py-2.5 border-b border-[#E8E3DC] bg-[#FAFAF9]"
  end

  def admin_table_td_class
    "px-4 py-3 border-b border-[#F0EDE8] align-middle text-[#1C1917] text-sm"
  end

  def admin_card(title: nil, &block)
    content_tag(:div, class: "bg-white rounded-xl shadow-sm p-6 mb-5") do
      safe_join([
        title ? content_tag(:h2, title, class: "text-[1.0625rem] font-semibold mb-4 text-[#1C1917]") : nil,
        capture(&block)
      ].compact)
    end
  end

  def admin_toolbar(title:, &block)
    content_tag(:div, class: "flex items-center gap-4 mb-6") do
      safe_join([
        content_tag(:h1, title, class: "text-[1.375rem] font-bold text-[#1C1917] m-0"),
        block ? capture(&block) : nil
      ].compact)
    end
  end

  def admin_error_list(record)
    return unless record.errors.any?
    content_tag(:div, class: "bg-[#FEF2F2] text-[#991B1B] border border-[#FECACA] rounded-lg px-4 py-3 mb-5 text-sm") do
      safe_join(record.errors.map { |e| content_tag(:p, e.full_message) })
    end
  end
end
