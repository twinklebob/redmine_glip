class AddGlipUrlToProject < ActiveRecord::Migration
  def change
    add_column :projects, :glip_url, :string, :default => "", :null => false
  end
end
