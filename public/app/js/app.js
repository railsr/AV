'use strict';
var avApp = angular.module('avApp', ['ngRoute','avControllers']);

avApp.config(['$routeProvider', '$locationProvider',
   function($routeProvider, $locationProvider) {
       $routeProvider.
           when('/', {
               templateUrl: 'partials/main.html',
               controller: 'MainCtrl'
           }).when('/about',{
               templateUrl: 'partials/about.html',
               controller: 'AboutCtrl'
           }).when('/apts_tgn', {
               templateUrl: 'partials/apts_tgn.html',
               controller: 'AptTgnCtrl'
           }).when('/macs',{
               templateUrl: 'partials/macs.html',
               controller: 'MacCtrl'                   
           }).otherwise({
               redirectTo: '/'
           });
       $locationProvider.html5Mode(false).hashPrefix('!');
   }]);