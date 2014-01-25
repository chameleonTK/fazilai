class CreateAchievements < ActiveRecord::Migration
  def change
    create_table :achievements , :primary_key => "aid" do |t|
      t.string :name
      t.text :detail
      t.text :img

      t.timestamps
    end
  end
end
