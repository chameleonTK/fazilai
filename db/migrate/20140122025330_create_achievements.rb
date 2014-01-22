class CreateAchievements < ActiveRecord::Migration
  def change
    create_table :achievements do |t|
      t.string :achieveName
      t.text :detail
      t.text :rule

      t.timestamps
    end
  end
end
