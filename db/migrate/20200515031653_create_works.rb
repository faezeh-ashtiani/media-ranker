class CreateWorks < ActiveRecord::Migration[6.0]
  def change
    create_table :works do |t|
      t.string :catagory
      t.string :title
      t.string :creator
      t.integer :year
      t.string :description

      t.timestamps
    end
  end
end
