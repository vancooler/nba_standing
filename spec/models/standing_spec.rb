require 'spec_helper'
describe Standing do

	describe "Invalid data" do
		url = "https://www.google.ca"
		result = Standing.importFromURL(url)
		it "Import Google" do 
			expect(result[:status]).to eql false
			expect(result[:message]).to eql "Invalid data"

		end

	end


	describe "parse" do 
		url = "http://www.nba.com/standings/2014/team_record_comparison/conferenceNew_Std_Div.html?ls=iref:nba:gnav"

		result = Standing.parsePage(url)
		it "Season" do
			expect(result[:season][:start_year]).to eql 2014
			expect(result[:teamInfo][0][:l].to_i).to eql 33
		end
	end



	describe "2014-2015 season" do
		url = "http://www.nba.com/standings/2014/team_record_comparison/conferenceNew_Std_Div.html?ls=iref:nba:gnav"
		result = Standing.importFromURL(url)

		it "Import without problems" do 
			expect(result[:status]).to eql true

		end

		it "Season" do
			expect(Season.count).to eql 1
			expect(Season.first.start_year).to eql 2014
			expect(Season.first.end_year).to eql 2015
		end

		it "Conference" do
			expect(Conference.count).to eql 2
			expect(Conference.first.conf_name).to eql "Eastern Conference"
			expect(Conference.last.conf_name).to eql "Western Conference"
		end

		it "Division" do
			expect(Division.count).to eql 6
			expect(Division.first.conf_id).to eql Conference.first.id

		end

		it "Team" do
			expect(Team.count).to eql 30
			expect(Team.first.div_id).to eql Division.first.id

		end


		it "Standing" do
			expect(Standing.count).to eql 30
			standing = Standing.first
			expect(standing.team_id).to eql Team.first.id
			expect(standing.season_id).to eql Season.first.id

			expect(standing.win).to eql 49
		    expect(standing.lost).to eql 33
		    expect(standing.pct).to eql 0.598
		    expect(standing.gb).to eql 0.0

		    expect(standing.conf_win).to eql 33 
		    expect(standing.conf_lost).to eql 19

		    expect(standing.div_win).to eql 11
		    expect(standing.div_lost).to eql 5

		    expect(standing.home_win).to eql 27
		    expect(standing.home_lost).to eql 14

		    expect(standing.road_win).to eql 22
		    expect(standing.road_lost).to eql 19

		    expect(standing.last_ten_win).to eql 7 
		    expect(standing.last_ten_lost).to eql 3

		    expect(standing.streak_as_win).to eql true
		    expect(standing.streak_number).to eql 1
		    expect(standing.div_rank).to eql 1
		    expect(standing.conf_rank).to eql 4
		end


	end




end
# Standing.delete_all
# Team.delete_all
# Division.delete_all
# Conference.delete_all
# Season.first.destroy
