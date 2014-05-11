class AddUpcToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :upc => false do |t|
      t.integer :upc, :limit => 8
    end
  end
end
