class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string  :name,     limit: 32
      t.string  :email,    limit: 255
      t.integer :zipcode
      t.string  :city,     limit: 64
      t.string  :address
      t.float   :latitude
      t.float   :longitude

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
