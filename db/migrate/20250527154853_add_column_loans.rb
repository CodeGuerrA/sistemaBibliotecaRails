class AddColumnLoans < ActiveRecord::Migration[6.0]
  def change
    # Exemplo de migration
    add_column :loans, :data_devolucao_real, :date
  end
end
