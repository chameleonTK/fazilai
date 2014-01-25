class CreateOwnachieves < ActiveRecord::Migration
  def change
    create_table :ownachieves ,:id => false do |t|
		t.belongs_to :user
		t.belongs_to :achievement		
    end

  end
end
