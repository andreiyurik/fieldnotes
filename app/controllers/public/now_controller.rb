class Public::NowController < Public::BaseController
  def show
    @current  = NowEntry.latest
    @previous = NowEntry.previous.limit(20)
    fresh_when @current
  end
end
