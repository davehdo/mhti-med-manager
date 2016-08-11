# =============================  models module  ===============================
models = angular.module("models")

# defaults methods are get({id: 1}), save, query, remove, delete
models.factory('Comment', ["$resource", "Model", ($resource, Model) ->
	$.extend($resource('/comments/:id', # url
		{format: "json"}, # param defaults
		{ # custom actions here 
			query: {method: "GET", url: "/comments/", isArray: true}, 
			update: {method: "PATCH", params: {id: '@_id'}}
		}
	), Model)
])