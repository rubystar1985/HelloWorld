class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.boolean :positive
      t.integer :voteable_id
      t.string :voteable_type
      t.timestamps null: false
    end

    add_index :votes, [:voteable_id, :voteable_type]
  end
end
