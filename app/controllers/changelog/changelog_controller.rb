class Changelog::ChangelogController < ApplicationController
  def index
    @entries = current_company.changelog_entries.reverse_chronologically
  end
end
