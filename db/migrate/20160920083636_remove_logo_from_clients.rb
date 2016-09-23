class RemoveLogoFromClients < ActiveRecord::Migration
  def change
    remove_column :clients, :logo_file_name
    remove_column :clients, :logo_content_type
    remove_column :clients, :logo_file_size
    remove_column :clients, :logo_updated_at
  end
end