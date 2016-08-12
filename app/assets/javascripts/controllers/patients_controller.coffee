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
	
	$scope.urls = ["/pills/00002-3228-30_391E1C80.jpg", 
		"/pills/00002-3229-30_3E1E1F50.jpg",
		"/pills/00002-3235-60_1B158D9C.jpg",
		"/pills/00002-3238-30_361E1B30.jpg",
		"/pills/00002-3239-30_3F1E1F80.jpg",
		"/pills/00002-3250-30_431E21C1.jpg",
		"/pills/00002-3251-30_451E2281.jpg",
		"/pills/00002-3270-30_A91354EA.jpg",
		"/pills/00002-4462-30_B215591A.jpg",
		"/pills/00002-4463-30_B5155ACA.jpg",
		"/pills/00002-4464-30_B8155C1A.jpg",
		"/pills/00002-4770-90_9516CAA6.jpg",
		"/pills/00002-4771-90_8F16C7A6.jpg",
		"/pills/00002-4772-90_8C16C656.jpg",
		"/pills/00003-4214-21_1A1B8D0C.jpg",
		"/pills/00003-4222-16_F215F93F.jpg",
		"/pills/00004-0259-01_B8135C6A.jpg",
		"/pills/00004-0260-01_5E132F39.jpg",
		"/pills/00004-0800-85_491E24C1.jpg",
		"/pills/00006-0032-20_DF16EFC7.jpg",
		"/pills/00006-0112-54_131609E0.jpg",
		"/pills/02c91fba-9c47-43ef-ac78-e82369798834_50419-409_1_50419-0409-01_SPLIMAGE30_A619530A.jpg",
		"/pills/02c91fba-9c47-43ef-ac78-e82369798834_50419-409_2_50419-0409-01_SPLIMAGE30_A91954BA.jpg",
		"/pills/02c91fba-9c47-43ef-ac78-e82369798834_50419-409_3_50419-0409-01_SPLIMAGE30_AC19560A.jpg",
		"/pills/02c91fba-9c47-43ef-ac78-e82369798834_50419-409_4_50419-0409-01_SPLIMAGE30_AF1957BA.jpg",
		"/pills/02c91fba-9c47-43ef-ac78-e82369798834_50419-409_5_50419-0409-01_SPLIMAGE30_B219590A.jpg",
		"/pills/0e5139d8-bf61-4f21-a36b-81b96b9b07d1_0173-0822_0_00173-0822-04_SPLIMAGE30_2A19950C.jpg",
		"/pills/3bf1718a-fedc-4834-831e-b3b044f80ee6_66116-821_0_00093-3109-53_Amoxicillin_500mg_Caps.jpg",
		"/pills/4c0f348a-a65d-409c-8668-207c82a5e3cb_0093-2267_0_00093-2267-01.jpg",
		"/pills/4c0f348a-a65d-409c-8668-207c82a5e3cb_0093-2268_0_00093-2268-01.jpg",
		"/pills/4c0f348a-a65d-409c-8668-207c82a5e3cb_0093-3107_0_00093-3107-01.jpg",
		"/pills/4c0f348a-a65d-409c-8668-207c82a5e3cb_0093-3109_0_00093-3109-53.jpg",
		"/pills/4c6f4f9e-f3f5-4ecf-9f40-887e037e8847_0172-5728_0_00172-5728-60.jpg",
		"/pills/4c6f4f9e-f3f5-4ecf-9f40-887e037e8847_0172-5729_0_00172-5729-60.jpg",
		"/pills/5bc62cef-1c78-4ddb-bdde-0574e5218f63_0023-9350_0_capsules.jpg"
	]
	
	$scope.pillCount = 0
	$scope.randomPillImageUrl = () ->
		$scope.pillCount += 1
		$scope.urls[$scope.pillCount]

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
	
	carouselDelay = 2000
	updateDelay = 5000
	
	
	$scope.comments = Comment.query( (comments) ->
		$scope.comment = comments[0]
		$scope.timeoutCode = setTimeout( () ->
			$scope.nextComment()
			$scope.$apply() # if its not a click, needs an apply call to re-render
		, carouselDelay )
		$scope.timeoutCode2 = setTimeout( $scope.reloadComments, updateDelay )
	)
	
	
	$scope.reloadComments = () ->
		$scope.comments = Comment.query( () ->
			clearTimeout( $scope.timeoutCode2 ) if $scope.timeoutCode2
			$scope.timeoutCode2 = setTimeout( $scope.reloadComments, updateDelay )
		)
	
	# we use an ID matcher because the comments array is frequently queried from the server
	$scope.commentMatches = (a, b) ->
		a and b and a.id == b.id


	$scope.commentIndex = (arrays, b) ->
		item = _.filter(arrays, (a)->
			$scope.commentMatches(a,b)
		)[0] || "xyz"
		arrays.indexOf(item)
	
		
	$scope.nextComment = () ->
		if $scope.comments
			# if comment is nonexistent then nextIndex should be zero
			nextIndex = $scope.commentIndex($scope.comments, $scope.comment || "xyz") + 1
			if nextIndex >= $scope.comments.length
				nextIndex = 0
			$scope.comment = $scope.comments[ nextIndex ]
			
			clearTimeout( $scope.timeoutCode ) if $scope.timeoutCode
			$scope.timeoutCode = setTimeout( () ->
				$scope.nextComment()
				$scope.$apply() # if its not a click, needs an apply call to re-render
			, carouselDelay )

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
