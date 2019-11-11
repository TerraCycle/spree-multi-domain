module Spree::TaxonDecorator
  def self.prepended(base)
    base.scope :by_store, -> (store) { joins(:taxonomy).merge(Spree::Taxonomy.by_store(store)) }
  end

  def self.find_by_store_id_and_permalink!(store_id, permalink)
    by_store(store_id).where(permalink: permalink).first!
  end
end

::Spree::Taxon.prepend(Spree::TaxonDecorator)
