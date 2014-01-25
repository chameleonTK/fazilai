class CreateProjs < ActiveRecord::Migration
  def change
    create_table :projs, :primary_key => "pid" do |t|
      t.string :name
      t.string :path
      t.text :detail
		t.belongs_to :server

      t.timestamps
    end
  end
end
