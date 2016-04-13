require 'rubygems'
require 'nokogiri'
require 'open-uri'

def scrapingHTML(url)
	page = Nokogiri::HTML(open(url)) 
	# puts page.css('div#nbaFullContent td.header') 

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

		# get team
		else
			teamInfo = getTeamDetails(tr, colNames, currentConf, currentDiv, currentDivRank)
			if !teamInfo.nil?
				result[:teamInfo] <<  teamInfo
			end
			currentDivRank += 1
		end
	end
	importData(result)
end

def importData(parsedData)
	array = []
	parsedData[:teamInfo].each do |team|
		# conference = Conference.find_or_initialize_by(conf_name: team[:conf_name])
		# conference.save
		# division = Division.find_or_initialize_by(div_name: team[:div_name], conf_id: conference.id)
		# division.save
		# team = Team.find_or_initialize_by(team_name: team[:team_name], div_id: division.id)
		# team.save
		standing = Hash.new
		standing[:lost] = team[:l].to_i
	    standing[:win] = team[:w].to_i
	    standing[:pct] = team[:pct].to_f
	    standing[:gb] = team[:gb].to_f
	    standing[:lost] = team[:l].to_i
	    standing[:win] = team[:w].to_i
	    standing[:pct] = team[:pct].to_f
	    standing[:gb] = team[:gb].to_f

	    standing[:conf_win] = team[:conf_win].to_i
	    standing[:conf_lost] = team[:conf_lost].to_i

	    standing[:div_win] = team[:div_win].to_i
	    standing[:div_lost] = team[:div_lost].to_i

	    standing[:home_win] = team[:home_win].to_i
	    standing[:home_lost] = team[:home_lost].to_i

	    standing[:road_win] = team[:road_win].to_i
	    standing[:road_lost] = team[:road_lost].to_i

	    standing[:last_ten_win] = team[:last_ten_win].to_i
	    standing[:last_ten_lost] = team[:last_ten_lost].to_i
	    standing[:streak_as_win] = team[:streak_as_win]
	    standing[:streak_number] = team[:streak_number].to_i
	    standing[:div_rank] = team[:div_rank].to_i
	    standing[:conf_rank] = team[:conf_rank].to_i
	    array << standing
	end
	puts array
end


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


def getColName(tr)
	tds = tr.css('td:not(.name)')
	colNames = []
	tds.each do |td|
		colNames << td.text.gsub(/\s+/, "_").downcase.to_sym
	end

	return colNames
end


def getHeader(tr)
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



scrapingHTML("http://www.nba.com/standings/2014/team_record_comparison/conferenceNew_Std_Div.html?ls=iref:nba:gnav")



# puts checkSum([1, 2, 3, 4, 5], 4)
 # A = [4,3,-1,4,5,3,5,10] and sum = 11
 # 
 # return true if there are 2 int in the array A can add up to sum; otherwise return false

# time complexity ~ n*log(n)
# space complexity ~ heap memory (n)

def checkSum(array, sum)
    if array.nil?  or array.empty?
        return false
    else
        sortedArray = []
        sortedArray = array.sort # n*log(n)
        length = sortedArray.count
        rightPointer = length - 1
        leftPointer = 0
        result = false

        while leftPointer < rightPointer
            if sortedArray[leftPointer] == rightPointer
                result = false;
                break;
            elsif sortedArray[leftPointer] + sortedArray[rightPointer] > sum
                rightPointer -= 1
            elsif sortedArray[leftPointer] + sortedArray[rightPointer] < sum
                leftPointer += 1
            else
                result = true
                break;
            end
        end 
        return result;

       # return checkHeadAndRear(sortedArray, sum, length) # n
    end

end


def checkHeadAndRear(array, sum, length)
    if array.count == 1
        return false
    elsif array[0] + array[length-1] < sum
        checkHeadAndRear(array[1..(length-1)], sum, length - 1)
    elsif array[0] + array[length-1] > sum
        checkHeadAndRear(array[0..(length - 2)], sum, length - 1)
    else
        return true
    end
end