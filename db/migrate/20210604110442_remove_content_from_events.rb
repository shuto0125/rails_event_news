class RemoveContentFromEvents < ActiveRecord::Migration[6.0]
  def change
    remove_column :events, :content, :text
  end
end
