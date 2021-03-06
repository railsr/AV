'use strict';
var avControllers = angular.module('avControllers',[]);

avControllers.controller("MainCtrl",['$scope',
    function MainCtrl($scope)  {
        $scope.message = "Hello";
    }]);

avControllers.controller("AboutCtrl",['$scope',
    function AboutCtrl($scope)  {

    }]);

 avControllers.controller("AptTgnCtrl", function($scope, $http) {
     $scope.appartments= [];
     $http.get('/apts_tgn').success(function(data) {
         $scope.appartments = data;
     });
 });

avControllers.controller("MacCtrl", function($scope, $http){
    $scope.macs = [];
    $http.get('/macs').success(function(data){
        $scope.macs = data;
    });
});

avControllers.controller("Rx8Ctrl", function($scope, $http){
    $scope.rxs = [];
    $http.get('/rx8').success(function(data){
			console.log(data);
        $scope.rxs = data;
    });
});

