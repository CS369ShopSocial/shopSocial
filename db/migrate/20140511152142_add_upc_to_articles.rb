class AddUpcToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :upc, :integer
  end
end
