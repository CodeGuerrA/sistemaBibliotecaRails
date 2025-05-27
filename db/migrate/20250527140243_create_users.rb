class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :nome
      t.integer :matricula
      t.string :curso
      t.timestamps
    end
  end
end
