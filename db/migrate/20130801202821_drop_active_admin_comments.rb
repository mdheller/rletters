class DropActiveAdminComments < ActiveRecord::Migration[4.2]
  def up
    drop_table :active_admin_comments
  end

  def down
    create_table :active_admin_comments do |t|
      t.string :namespace
      t.text :body
      t.string :resource_id,   null: false
      t.string :resource_type, null: false
      t.references :author, polymorphic: true
      t.timestamps null: true
    end
    add_index :active_admin_comments, [:namespace]
    add_index :active_admin_comments, [:author_type, :author_id]
    add_index :active_admin_comments, [:resource_type, :resource_id]
  end
end
