class AddDealPhotoFields < ActiveRecord::Migration
  def self.up
    add_column :deals, :deal_photo_file_name, :string # Original filename
    add_column :deals, :deal_photo_content_type, :string # Mime type
    add_column :deals, :deal_photo_file_size, :integer # File size in bytes
    rename_column :deals, :save, :save_amount
  end

  def self.down
    remove_column :deals, :deal_photo_file_name
    remove_column :deals, :deal_photo_content_type
    remove_column :deals, :deal_photo_file_size
   rename_column :deals, :save_amount, :save
  end
end
