class Standing < ActiveRecord::Base
	belongs_to :season
	belongs_to :team
	has_one :division, :through => :team
	has_one :conference, :through => :division

	require 'open-uri'

	# scraping page of given url
	def self.importFromURL(url)
		
		parsedData = Standing.parsePage(url)
		if Standing.dataValidate(parsedData)
			self.importData(parsedData)
			return {status: true, message: ""}
		else
			return {status: false, message: "Invalid data"}
		end
	end

	# validate the parsed hash
	def self.dataValidate(parsedData)
		if parsedData.nil? or parsedData[:season].nil? or parsedData[:teamInfo].nil?
			return false
		end
		valid = true
		# validate season
		valid = valid and (parsedData[:season][:start_year].is_a? Integer) and (parsedData[:season][:end_year].is_a? Integer) and parsedData[:season][:start_year] + 1 == parsedData[:season][:end_year]
		# validate data details of each team
		parsedData[:teamInfo].each do |team|
			valid = valid and !team[:name].empty?
			valid = valid and !!/\A\d+\z/.match(team[:l])
			valid = valid and !!/\A\d+\z/.match(team[:w])
			valid = valid and !!/\A\d+\z/.match(team[:conf_win])
			valid = valid and !!/\A\d+\z/.match(team[:conf_lost])
			valid = valid and !!/\A\d+\z/.match(team[:div_win])
			valid = valid and !!/\A\d+\z/.match(team[:div_lost])
			valid = valid and !!/\A\d+\z/.match(team[:home_win])
			valid = valid and !!/\A\d+\z/.match(team[:home_lost])
			valid = valid and !!/\A\d+\z/.match(team[:road_win])
			valid = valid and !!/\A\d+\z/.match(team[:road_lost])
			valid = valid and !!/\A\d+\z/.match(team[:last_ten_win])
			valid = valid and !!/\A\d+\z/.match(team[:last_ten_lost])
			valid = valid and !!/\A\d+\z/.match(team[:streak_number])
			valid = valid and (team[:streak_as_win] == true or team[:streak_as_win] == false)
			valid = valid and team[:div_rank] > 0
			valid = valid and team[:conf_rank] >= 0
			valid = valid and (Float(team[:pct]) != nil rescue false)
			valid = valid and (Float(team[:gb]) != nil rescue false)
		end
		return valid
	end

	# import the parsed data in html page to database
	def self.importData(parsedData)
		season = Season.find_or_initialize_by(start_year: parsedData[:season][:start_year], end_year: parsedData[:season][:end_year])
		season.save

		parsedData[:teamInfo].each do |team|
			conference = Conference.find_or_initialize_by(conf_name: team[:conf_name])
			conference.save
			division = Division.find_or_initialize_by(div_name: team[:div_name], conf_id: conference.id)
			division.save
			destTeam = Team.find_or_initialize_by(team_name: team[:name], div_id: division.id)
			destTeam.save
			standing = Standing.find_or_initialize_by(team_id: destTeam.id, season_id: season.id)
			standing.lost = team[:l].to_i
		    standing.win = team[:w].to_i
		    standing.pct = team[:pct].to_f
		    standing.gb = team[:gb].to_f

		    standing.conf_win = team[:conf_win].to_i
		    standing.conf_lost = team[:conf_lost].to_i

		    standing.div_win = team[:div_win].to_i
		    standing.div_lost = team[:div_lost].to_i

		    standing.home_win = team[:home_win].to_i
		    standing.home_lost = team[:home_lost].to_i

		    standing.road_win = team[:road_win].to_i
		    standing.road_lost = team[:road_lost].to_i

		    standing.last_ten_win = team[:last_ten_win].to_i
		    standing.last_ten_lost = team[:last_ten_lost].to_i
		    standing.streak_as_win = team[:streak_as_win]
		    standing.streak_number = team[:streak_number].to_i
		    standing.div_rank = team[:div_rank].to_i
		    standing.conf_rank = team[:conf_rank].to_i

		    standing.save
		end

	end

	# Collect useful information in the page and return a hash of the result
	def self.parsePage(url)
		page = Nokogiri::HTML(open(url)) 
		result = {
			teamInfo: []
		}
		trs = page.css('div#nbaFullContent tr') 
		currentConf = ''
		currentDiv  = ''
		currentDivRank  = 1
		colNames = []
		trs.each do |tr|
			conf = tr.css('td.confTitle').text
			div = tr.css('td.name').text

			# Header
			if tr.to_s.include?('class="header"')
				season = getHeader(tr)
				if !season.nil?
					result[:season] = season
				end

			# get conf
			elsif !conf.empty?
				currentConf = conf

			# get div
			elsif !div.empty?
				if div != currentDiv
					currentDiv = div
					colNames = getColName(tr)
					currentDivRank = 1
				end

			# get team info details
			else
				teamInfo = getTeamDetails(tr, colNames, currentConf, currentDiv, currentDivRank)
				if !teamInfo.nil?
					result[:teamInfo] <<  teamInfo
				end
				currentDivRank += 1
			end
		end

		return result
	end

	# get all teams informations
	def self.getTeamDetails(tr, colNames, currentConf, currentDiv, currentDivRank)
		teamName = tr.css('td.team a').text
		confRank = tr.css('td.team sup').text
		team = {
			name: teamName, 
			conf_name: currentConf,
			conf_rank: confRank.to_i,
			div_name: currentDiv,
			div_rank: currentDivRank
		}
		tds = tr.css('td:not(.team)')

		i = 0
		tds.each do |td|
			if colNames[i].to_s == 'conf'
				wl_pair = td.text.split("-")
				team[:conf_win] = wl_pair[0]
				team[:conf_lost] = wl_pair[1]
			elsif colNames[i].to_s == 'div'
				wl_pair = td.text.split("-")
				team[:div_win] = wl_pair[0]
				team[:div_lost] = wl_pair[1]
			elsif colNames[i].to_s == 'home'
				wl_pair = td.text.split("-")
				team[:home_win] = wl_pair[0]
				team[:home_lost] = wl_pair[1]
			elsif colNames[i].to_s == 'road'
				wl_pair = td.text.split("-")
				team[:road_win] = wl_pair[0]
				team[:road_lost] = wl_pair[1]
			elsif colNames[i].to_s == 'l_10'
				wl_pair = td.text.split("-")
				team[:last_ten_win] = wl_pair[0]
				team[:last_ten_lost] = wl_pair[1]
			elsif colNames[i].to_s == 'streak'
				streak_pair = td.text.split(" ")
				team[:streak_as_win] = (streak_pair[0].upcase == "W")
				team[:streak_number] = streak_pair[1]

			else 
				team[colNames[i]] = td.text
			end
			i += 1
		end

		return team
	end

	# get the columns names of the main table
	def self.getColName(tr)
		tds = tr.css('td:not(.name)')
		colNames = []
		tds.each do |td|
			colNames << td.text.gsub(/\s+/, "_").downcase.to_sym
		end

		return colNames
	end

	# get the season info in tr header
	def self.getHeader(tr)
		range = tr.css('td').text.split(" Division Standings").first.split("\n").last.gsub(/\s+/, "")
		rangeArray = range.split("-")
		if rangeArray.count == 2 && rangeArray[0].to_i > 0 && rangeArray[1].to_i > 0
			startYear = rangeArray[0] 
			endYear = rangeArray[1] 
			season = {
				start_year: rangeArray[0].to_i, 
				end_year: rangeArray[1].to_i
			}
			return season
		end
		return nil
	end

end
