class Updateforeignkey < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :carts, :users
    add_foreign_key :carts, :users, on_delete: :cascade
  end
end
