class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
		t.belongs_to :user
		t.belongs_to :server
      t.timestamps
    end
  end
end
