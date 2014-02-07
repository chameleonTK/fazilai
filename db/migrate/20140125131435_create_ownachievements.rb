class CreateOwnachievements < ActiveRecord::Migration
  def change
    create_table :ownachievements ,:id => false do |t|
		t.belongs_to :user
		t.belongs_to :achievement		
    end

  end
end
