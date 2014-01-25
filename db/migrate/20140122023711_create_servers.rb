class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers , :primary_key => 'sid'  do |t|
      t.string :name
      t.string :domain
      t.integer :port
      t.string :suser
      t.string :spass
		t.belongs_to :user , :foreign_key => "uid"

      t.timestamps
    end
  end
end
