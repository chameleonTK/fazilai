class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs , :primary_key => "lid" do |t|
		t.belongs_to :user
		t.belongs_to :proj
		t.datetime :starttime
		t.datetime :lefttime
      #t.timestamps
    end
  end
end
