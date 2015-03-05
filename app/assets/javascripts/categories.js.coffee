app = angular.module("Category", ["ngResource"])

app.factory "Category", ["$resource", ($resource) ->
  $resource("/categories/:id.json", {id: "@id"})
]


app.controller 'CategoryCtrl', ['$scope', 'Category', ($scope, Category) ->
  $scope.categories = Category.query()

  $scope.addCategory = ->
    category = Category.save($scope.newCategory)
    $scope.categories.push(category)
    $scope.newCategory = {}

  $scope.removeCategory = (cat) ->
    cat.$remove()
    $scope.categories.splice($scope.categories.indexOf(cat), 1)
]