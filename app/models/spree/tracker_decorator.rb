module Spree::TrackerDecorator
  def self.perepended
    base.belongs_to :store
  end

  def self.current(engine = Spree::Tracker::TRACKING_ENGINES, domain)
    Spree::Tracker.where(engine: engine).active.joins(:store).where("spree_stores.url LIKE ?", "%#{domain}%").first
  end
end

::Spree::Tracker.prepend(Spree::TrackerDecorator)
