# =============================  models module  ===============================
models = angular.module("models")

# defaults methods are get({id: 1}), save, query, remove, delete
models.factory('Medication', ["$resource", "Model", ($resource, Model) ->
	Medication = $.extend($resource('/medications/:id', # url
		{format: "json"}, # param defaults
		{ # custom actions here 
			query: {method: "GET", url: "/medications/", isArray: true}, 
			update: {method: "PATCH", params: {id: '@_id'}}
		}
	), Model)
	
	Medication.prototype.frequencyInWords = () ->
		dosages = _.compact([@take_am, @take_noon, @take_pm])
		if dosages.length == 0
			"daily"
		else if dosages.length == 1
			"daily"
		else if dosages.length == 2
			"twice daily"
		else if dosages.length == 3
			"three times daily"
		
	Medication
])