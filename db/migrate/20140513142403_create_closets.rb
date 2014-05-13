class CreateClosets < ActiveRecord::Migration
  def change
    create_table :closets do |t|
      t.integer :user_id
      t.integer :article_id

      t.timestamps
    end
  end
end
