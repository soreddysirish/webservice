class AddColumnsToRecord < ActiveRecord::Migration[5.1]
  def change
    add_column :records, :dateOfBirth, :date
    add_column :records, :fullname, :string
    add_column :records, :phonenumber, :string
    add_column :records, :idnumber, :string
    add_column :records, :idNumberType, :string
  end
end
