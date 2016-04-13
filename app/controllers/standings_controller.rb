class StandingsController < ApplicationController
  def index
    urls = ["http://www.nba.com/standings/2014/team_record_comparison/conferenceNew_Std_Div.html?ls=iref:nba:gnav", "http://www.nba.com/standings/2013/team_record_comparison/conferenceNew_Std_Div.html?ls=iref:nba:gnav", "http://www.nba.com/standings/2012/team_record_comparison/conferenceNew_Std_Div.html?ls=iref:nba:gnav"]
    urls.each do |url|
      Standing.importFromURL(url)
    end
    @standings = Standing.includes(:season).includes(:team).includes(:division).includes(:conference).group_by(&:season_id)
  end
end