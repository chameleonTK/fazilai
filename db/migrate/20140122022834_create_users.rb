class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users , :primary_key =>'uid'  do |t|
      t.string :email
      t.string :pass
      t.timestamps
    end
  end
end
