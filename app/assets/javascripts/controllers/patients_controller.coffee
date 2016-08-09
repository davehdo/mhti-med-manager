# ============================  controllers module  ===========================
controllers = angular.module("controllers")


controllers.controller("PatientsIndexController", ["$scope", "Patient", "flash", ($scope, Patient, flash) -> 
	# in case there is a flash message, pull it into scope so the view has access to it
	$scope.flash = flash

	# while this looks synchronous, what is returned is a "future", an object
	# that will be filled with data when the XHR response returns
	$scope.patients = Patient.query()
])


controllers.controller("PatientsMedicationsController", ["$scope", "$routeParams", "$location", "Patient", "Medication", "flash", ($scope, $routeParams, $location, Patient, Medication, flash) -> 
# in case there is a flash message, pull it into scope so the view has access to it
	$scope.flash = flash

	# $scope.patient = Patient.get({ id: $routeParams.id})
	
	$scope.medications = Medication.query()
	
	$scope.newMedication = new Medication
	
	$scope.submitForm = ->
		$scope.newMedication.$save(null, () ->
			flash.currentMessage "Added"
			$scope.newMedication = new Medication
			$scope.medications = Medication.query()
		)
		
])


controllers.controller("PatientsPerformanceController", ["$scope", "$routeParams", "$location", "Patient", "Medication", "flash", ($scope, $routeParams, $location, Patient, Medication, flash) -> 
# in case there is a flash message, pull it into scope so the view has access to it
	$scope.flash = flash

	# $scope.patient = Patient.get({ id: $routeParams.id})
	
	$scope.chartData = [
        ['Nitrogen', 0.78],
        ['Oxygen', 0.21],
        ['Other', 0.01]
      ]
	
		
])



controllers.directive('barChart', () ->
	restrict: 'ACE'
	scope: 
		chartData: "="
	link: (scope, element, attrs, controllers) ->

		google.charts.load('current', {packages: ['corechart']})
				
		drawChart = () ->

			# Define the chart to be drawn.
			data = new google.visualization.DataTable()
			data.addColumn('string', 'Element')
			data.addColumn('number', 'Percentage')
			data.addRows([
				['Nitrogen', 0.78],
				['Oxygen', 0.21],
				['Other', 0.01]
			]);

			# Instantiate and draw the chart.

			chart = new google.visualization.PieChart( element[0] )
			chart.draw(data, null)
		
		
		scope.$watch("chartData", ->
			google.charts.setOnLoadCallback(drawChart)
		)
	

)


controllers.controller("PatientsShowController", ["$scope", "$routeParams", "$location", "Patient", "flash", ($scope, $routeParams, $location, Patient, flash) -> 
# in case there is a flash message, pull it into scope so the view has access to it
	$scope.flash = flash

	# $scope.patient = Patient.get({ id: $routeParams.id})
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
