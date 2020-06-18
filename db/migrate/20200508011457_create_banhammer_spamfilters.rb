class CreateBanhammerSpamfilters < ActiveRecord::Migration[6.0]
  def change
    create_table :banhammer_spamfilters do |t|
      t.text :kw
      t.string :name
      t.integer :link_limit
      t.integer :points
      t.integer :type

      t.timestamps
    end
  end
end
