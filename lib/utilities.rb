class String

	def valid_datestr?
		# format "MM-DD-YYYY"
		if self =~ /^\d{2}-\d{2}-\d{4}/
			date = self.split '-'
			return true if Date.valid_date?(date[2].to_i, date[0].to_i, date[1].to_i)
		end
		return false
	end

	def datestr_to_datetime
		# format "MM-DD-YYYY"
		date = self.split '-'
		return DateTime.new(date[2].to_i, date[0].to_i, date[1].to_i, 23, 59, 59)
	end

end
