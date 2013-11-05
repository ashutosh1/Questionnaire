module CategoriesHelper

  def fetch_categories
    Category.all.collect { |cat| ["#{cat.name}", cat.id] }
  end

end