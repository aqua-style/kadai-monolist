class RankingsController < ApplicationController
  def want
    @ranking_counts = Want.ranking
    @items = Item.find(@ranking_counts.keys)
  end
  
  def have
    @have_ranking_counts = Have.ranking
    @have_items = Item.find(@have_ranking_counts.keys)
  end
  
end