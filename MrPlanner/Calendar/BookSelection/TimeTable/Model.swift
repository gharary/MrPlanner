import SwiftyJSON

extension JSON {
	
	var intFromIntOrString: Int? {
		if	let v = self.int {
			return v
		}
		if	let s = self.string,
			let v = Int(s) {
			return v
		}
		return nil
	}
	
}

class Model {
	var userID	: Int
	var lessons	: [Lesson]
	var weeks	: [Week]
	
	var asJSON	: JSON {
		var jsonObject = JSON()
		jsonObject["user_id"].int			= userID
		jsonObject["lessons"].arrayObject	= lessons.map { $0.asJSON }
		jsonObject["weeks"].arrayObject		= weeks.map { $0.asJSON }
		return jsonObject
	}
	
	init?(fromJSON json: JSON) {
		guard
			let _userID = json["user_id"].int,
			let _lessons = json["lessons"].array?.compactMap(Lesson.init),
			let _weeks = json["weeks"].array?.compactMap(Week.init)
			else { return nil }
		
		userID	= _userID
		lessons	= _lessons
		weeks	= _weeks
	}
	
}

extension Model {
	
	class Lesson {
		var id			: String
		var chapters	: [Chapter]
		
		var asJSON		: JSON {
			var jsonObject = JSON()
			jsonObject["id"].string	= id
			jsonObject["chapters"].arrayObject = chapters.map { $0.asJSON }
			return jsonObject
		}
		
		init?(fromJSON json: JSON) {
			guard
				let _id = json["id"].string,
				let _chapters = json["chapters"].array?.compactMap(Chapter.init)
				else { return nil }
			
			id			= _id
			chapters	= _chapters
		}
		
	}
	
	class Chapter {
		var chapter	: String?
		var pages	: String
		
		var asJSON	: JSON {
			var jsonObject = JSON()
			jsonObject["chapter"].string = chapter
			jsonObject["pages"].string = pages
			return jsonObject
		}
		
		init?(fromJSON json: JSON) {
			guard
				let _pages = json["pages"].string
				else { return nil }
			
			chapter	= json["chapter"].string
			pages	= _pages
		}
		
	}
	
	class Week {
		var week	: Int
		var days	: [Day]
		
		var asJSON	: JSON {
			var jsonObject = JSON()
			jsonObject["week"].int	= week
			jsonObject["days"].arrayObject = days.map { $0.asJSON }
			return jsonObject
		}
		
		init?(fromJSON json: JSON) {
			guard
				let _week = json["week"].intFromIntOrString,
				let _days = json["days"].array?.compactMap(Day.init)
				else { return nil }
			
			week	= _week
			days	= _days
		}
	}
	
	class Day {
		var day		: Int
		var date	: Date?
		var hours	: [Int]
		
		var asJSON	: JSON {
			var jsonObject = JSON()
			jsonObject["day"].int		= day
			
			let dateFormatter = DateFormatter()
			dateFormatter.calendar = Calendar(identifier: .gregorian)
			dateFormatter.locale = Locale(identifier: "en-us")
			dateFormatter.dateFormat = "M-d-yyyy"
			jsonObject["date"].string	= date != nil ? dateFormatter.string(from: date!) : nil
			
			jsonObject["hours"].arrayObject = hours.map {
				var json = JSON()
				json["hour"].int = $0
				return json
			}
			
			return jsonObject
		}
		
		init?(fromJSON json: JSON) {
			guard
				let _day = json["day"].intFromIntOrString,
				let _hours = json["hours"].array?.compactMap({ $0["hour"].intFromIntOrString })
				else { return nil }
			
			day		= _day
			hours	= _hours
			
			let dateFormatter = DateFormatter()
			dateFormatter.calendar = Calendar(identifier: .gregorian)
			dateFormatter.locale = Locale(identifier: "en-us")
			dateFormatter.dateFormat = "M-d-yyyy"
			if	let dateString = json["date"].string,
				let _date = dateFormatter.date(from: dateString) {
				date	= _date
			}
			
		}
	}
}


func checkJSONFile() {
	let filePath	= Bundle.main.path(forResource: "request", ofType: "json")!
	let fileURL		= URL(fileURLWithPath: filePath)
	let fileData	= try! Data(contentsOf: fileURL)
	let jsonObject	= JSON(fileData)
	
	guard let model = Model(fromJSON: jsonObject) else { return }
	
	let modelAsJSON = model.asJSON
	print(modelAsJSON)
}

