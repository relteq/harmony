class RenameColorPalleteToColorPalette < ActiveRecord::Migration
  def self.up
     rename_table :color_palletes, :color_palettes
  end

  def self.down
    rename_table :color_palettes, :color_palletes
  end
end
