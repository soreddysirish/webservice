class CreateRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :records do |t|
      t.date :date
      t.string :grade
      t.string :probability_of_default
      t.string :reason_code
      t.string :reason_description
      t.string :score
      t.string :trend

      t.timestamps
    end
  end
end
