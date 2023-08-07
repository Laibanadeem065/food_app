class Updateforeignkeyaddondeleteconstraint < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :cart_items, :items
    add_foreign_key :cart_items, :items, on_delete: :cascade
  end
end
