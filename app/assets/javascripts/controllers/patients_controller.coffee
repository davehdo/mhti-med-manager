# ============================  controllers module  ===========================
controllers = angular.module("controllers")


controllers.controller("PatientsIndexController", ["$scope", "Patient", "flash", ($scope, Patient, flash) -> 
	# in case there is a flash message, pull it into scope so the view has access to it
	$scope.flash = flash

	# while this looks synchronous, what is returned is a "future", an object
	# that will be filled with data when the XHR response returns
	$scope.patients = Patient.query()
])


controllers.controller("PatientsMedicationsController", ["$scope", "$routeParams", "$location", "$sce", "Patient", "Medication", "flash", ($scope, $routeParams, $location, $sce, Patient, Medication, flash) -> 
# in case there is a flash message, pull it into scope so the view has access to it
	$scope.flash = flash

	# $scope.patient = Patient.get({ id: $routeParams.id})
	
	$scope.$sce = $sce
	
	$scope.medications = Medication.query()
	
	$scope.newMedication = new Medication
	
	$scope.destroyMedication = (med) ->
		if confirm "Do you want to remove #{ med.name } from the medication list?"
			
			med.$delete({id: med.id}, ->
				flash.currentMessage "Removed"
				_.remove( $scope.medications, (m) -> m==med)
			)
			
	$scope.submitForm = ->
		$scope.loading = true
		$scope.newMedication.$save(null, () ->
			$scope.loading = false
			flash.currentMessage "Added"
			$scope.newMedication = new Medication
			$scope.medications = Medication.query()
		)
		
])


controllers.controller("PatientsPerformanceController", ["$scope", "$routeParams", "$location", "Patient", "Medication", "flash", ($scope, $routeParams, $location, Patient, Medication, flash) -> 
# in case there is a flash message, pull it into scope so the view has access to it
	$scope.flash = flash

	# $scope.patient = Patient.get({ id: $routeParams.id})
	
	threshold = 0.9
	$scope.chartData1 = _.concat( [['Week', 'Compliance', { role: 'style' }]], _.times(20, (n)->
		rate = _.random(0.80, 1.00)
		["#{n}", rate * 100 , if rate > threshold then "rgb(183, 183, 183)" else "rgb(217, 83, 79)"]
	))
	
	$scope.chartOptions1 =
		title: 'Medication adherence, by week'
		
	$scope.chartData2 = _.concat( [['Week', 'Compliance', { role: 'style' }]], _.times(20, (n)->
		rate = _.random(0.80, 1.00)
		["#{n}", rate * 100 , if rate > threshold then "rgb(183, 183, 183)" else "rgb(217, 83, 79)"]
	))
	
	$scope.chartOptions2 =
		title: 'Blood pressure control, by week'

	$scope.chartData3 = _.concat( [['Week', 'Compliance', { role: 'style' }]], _.times(20, (n)->
		rate = _.random(0.80, 1.00)
		["#{n}", rate * 100 , if rate > threshold then "rgb(183, 183, 183)" else "rgb(217, 83, 79)"]
	))
	
	$scope.chartOptions3 =
		title: 'Exercise adherence, by week'
	
])



controllers.directive('barChart', ["$window", ($window) ->
	restrict: 'ACE'
	scope: 
		barChart: "="
		chartOptions: "="
	link: (scope, element, attrs, controllers) ->

		if $window.googleChartsLoaded
			false
		else
			$window.googleChartsLoaded = true
			google.charts.load('current', {packages: ['corechart']})

				
		drawChart = () ->
			# Define the chart to be drawn.
			data = google.visualization.arrayToDataTable(scope.barChart)

			# Instantiate and draw the chart.

			defaultOptions = 
				title: 'Default title'
				legend: 
					position: 'none' 
				chart: 
					subtitle: 'Default subtitle' 
				axes:
					x:
						0:
							side: 'top'
							label: 'White to move'
				bar:
					groupWidth: "90%"
			

				
		
			chart = new google.visualization.ColumnChart( element[0] )
			chart.draw(data, _.merge(defaultOptions, scope.chartOptions))
		
		scope.$watch("barChart", ->
			google.charts.setOnLoadCallback(drawChart)
		)
	

])


controllers.controller("PatientsShowController", ["$scope", "$routeParams", "$location", "Comment", "flash", ($scope, $routeParams, $location, Comment, flash) -> 
# in case there is a flash message, pull it into scope so the view has access to it
	$scope.flash = flash

	# $scope.patient = Patient.get({ id: $routeParams.id})
	
	$scope.comments = Comment.query( (comments) ->
		$scope.comment = comments[0]
		$scope.timeoutCode = setTimeout( () ->
			$scope.nextComment()
			$scope.$apply() # if its not a click, needs an apply call to re-render
		, 2000 )
	)
	
	$scope.nextComment = () ->
		if $scope.comments
			# if comment is nonexistent then nextIndex should be zero
			nextIndex = $scope.comments.indexOf( $scope.comment || "xyz") + 1
			if nextIndex >= $scope.comments.length
				nextIndex = 0
			$scope.comment = $scope.comments[ nextIndex ]
			
			clearTimeout( $scope.timeoutCode ) if $scope.timeoutCode
			$scope.timeoutCode = setTimeout( () ->
				$scope.nextComment()
				$scope.$apply() # if its not a click, needs an apply call to re-render
			, 2000 )

])



controllers.controller("PatientsNewController", ["$scope", "$location", "Patient", "flash", ($scope, $location, Patient, flash) -> 
	# in case there is a flash message, pull it into scope so the view has access to it
	$scope.flash = flash

	$scope.patient = new Patient
	
	$scope.submitForm = () ->
		$scope.patient.$save(null, () -> # parameters, success, error
			flash.setMessage "Successfully created"
			$location.path( "/patients/#{ $scope.patient._id }" )
		) 
])


controllers.controller("PatientsEditController", ["$scope", "$routeParams", "$location", "Patient", "flash", ($scope, $routeParams, $location, Patient, flash) -> 
	# in case there is a flash message, pull it into scope so the view has access to it
	$scope.flash = flash

	$scope.patient = Patient.get({ id: $routeParams.id})
		
	$scope.submitForm = () ->
		$scope.patient.$update(null, () -> # parameters, success, error
			flash.setMessage "Successfully saved"
			$location.path( "/patients/#{ $scope.patient._id }" )
		)
		
	$scope.destroy = () ->
		if confirm("Are you sure you want to delete?")
			$scope.patient.$delete({id: $scope.patient._id}, () ->
				flash.setMessage "Deleted"
				$location.path( "/patients/")
			)
])
