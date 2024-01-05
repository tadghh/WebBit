class CreateSubmissions < ActiveRecord::Migration[7.1]
  def change
    create_table :submissions do |t|
      t.string :title
      t.string :body
      t.string :url
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
