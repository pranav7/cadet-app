class ChangelogEntriesController < ApplicationController
  def index
    @top_nav_selected = :changelog
    @entries = current_company.changelog_entries.reverse_chronologically
  end
end