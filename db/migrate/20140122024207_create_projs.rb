class CreateProjs < ActiveRecord::Migration
  def change
    create_table :projs do |t|
		t.belongs_to :server
      t.string :projName
      t.string :dir

      t.timestamps
    end
  end
end
