class AddProgressToDatasetsTasks < ActiveRecord::Migration[4.2]
  def change
    remove_column :datasets_tasks, :resque_key, :string
    remove_column :datasets_tasks, :params, :text
    add_column :datasets_tasks, :progress, :float
    add_column :datasets_tasks, :progress_message, :string
  end
end
