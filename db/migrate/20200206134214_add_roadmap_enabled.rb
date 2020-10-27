class AddRoadmapEnabled < ActiveRecord::Migration[5.2]
  def change
    add_column :boards, :roadmap_enabled, :boolean, default: true
  end
end
