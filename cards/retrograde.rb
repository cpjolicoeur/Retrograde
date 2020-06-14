#require 'squib'
require_relative 'asset'
require_relative 'spacecraft'
require_relative 'upgrade'
require_relative 'import'
require_relative 'print'
require_relative 'deck'

class Retrograde
  @@print_mode = "print"
  @@import_mode = "import"

  def self.print_mode
    @@print_mode
  end

  def self.import_mode
    @@import_mode
  end

  def initialize(asset_data_file, upgrade_data_file, spacecraft_data_file, decks)
    assets = Asset.new(asset_data_file)
    upgrades = Upgrade.new(upgrade_data_file)
    spacecraft = Spacecraft.new(spacecraft_data_file)
    @decks = decks.map { |d| Deck.new(File.basename(d, '.csv'), d, assets, upgrades, spacecraft) }
  end

  def render(mode)
    @decks.map do |deck|
      if mode == @@print_mode then
        Print.new pre_layouts, base_layouts, deck, dpi: 300 do
          background color: 'white'
          rect layout: 'safe'

          deck.render self, @data, @layouts

          output
        end
      elsif mode == @@import_mode then
        Import.new pre_layouts, base_layouts, deck, dpi: 300 do
          background color: 'white'
          rect layout: 'safe'

          deck.render self, @data, @layouts

          output
        end
      else
        puts "ERROR: Unknown mode #{mode}! Mode should be one of: #{@@import_mode}, #{@@print_mode}."
        exit 1
      end
  end
  end

  private

  # Layouts that are required before any other layout can be loaded. This is
  # because other layouts reference these. They cannot extend any layout that
  # isn't defined in itself.
  def pre_layouts
    ['layouts/borders.yml', 'layouts/debug.yml']
  end

  # Layouts added after print and import specific layouts are included.
  def base_layouts
    ['layouts/constants.yml']
  end
end

#[Asset.new, Spacecraft.new, Upgrade.new].each do |deck|
#  Import.new pre_layouts, base_layouts, deck, dpi: 300 do
#    background color: 'white'
#    rect layout: 'safe'
#
#    deck.render self, @data
#
#    output
#  end
#  Print.new pre_layouts, base_layouts, deck, dpi: 300 do
#    background color: 'white'
#    rect layout: 'safe'
#
#    deck.render self, @data
#
#    output
#  end
#end
#
#decks = Dir["decks/*"]
#decks.map do |deck_file|
#  deck = Deck.new(File.basename(deck_file, ".csv"), deck_file, Asset.new, Upgrade.new, Spacecraft.new)
#
#  Import.new pre_layouts, base_layouts, deck, dpi: 300 do
#    background color: 'white'
#    rect layout: 'safe'
#
#    deck.render self, @data, @layouts
#
#    output(save_png: false)
#  end
#  Print.new pre_layouts, base_layouts, deck, dpi: 300 do
#    background color: 'white'
#    rect layout: 'safe'
#
#    deck.render self, @data, @layouts
#
#    output(save_png: false)
#  end
#end
