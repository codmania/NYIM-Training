class CreateCreditCards < ActiveRecord::Migration

  def change
    create_table :credit_cards, :force => true do |t|
      t.string :store_key, :limit => 40
      t.string :name, :limit => 40
      t.belongs_to :student, :address
      t.timestamps
    end
    add_index :credit_cards, :student_id
  end

end
