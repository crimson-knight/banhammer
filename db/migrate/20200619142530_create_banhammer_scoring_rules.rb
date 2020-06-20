class CreateBanhammerScoringRules < ActiveRecord::Migration[6.0]
  def change
    create_table :banhammer_scoring_rules do |t|
      t.string :name
      t.text :kw
      t.integer :link_limit
      t.integer :points
      t.integer :rule_type

      t.index :rule_type

      t.timestamps
    end
  end
end
