class Table
  constructor: (@element, @tableConfiguration, @configurationVariableNames) ->

  constructHeader: () ->
    tr = angular.element(document.createElement("tr"))
    for i in @tableConfiguration.columnConfigurations
      tr.append(i.renderHtml())
    return tr

  setupHeader: () ->
    thead = @element.find("thead")
    if thead
      header = @constructHeader()
      tr = angular.element(thead).find("tr")
      tr.remove()
      thead.append(header)

  getSetup: () ->
    if @tableConfiguration.paginated
      return new PaginatedSetup(@configurationVariableNames)
    else
      return new StandardSetup(@configurationVariableNames, @tableConfiguration.list)
    return

  compile: () ->
    @setupHeader()
    @setup = @getSetup()
    @setup.compile(@element)

  setupInitialSorting: ($scope) ->
    for bd in @tableConfiguration.columnConfigurations
      if bd.initialSorting
        throw "initial-sorting specified without attribute." if not bd.attribute
        $scope.predicate = bd.attribute
        $scope.descending = bd.initialSorting == "desc"

  post: ($scope, $element, $attributes, $filter) ->
    @setupInitialSorting($scope)

    # if not $scope.getSortIcon
    $scope.getSortIcon = (predicate, currentPredicate, descending) ->
      if predicate != $scope.predicate
        console.log('fas fa-minus')
        return "fas fa-minus"
      if descending
        console.log('fas fa-chevron-down')
        return "fas fa-chevron-down"
      console.log('fas fa-chevron-up')
      return "fas fa-chevron-up"

    @setup.link($scope, $element, $attributes, $filter)
