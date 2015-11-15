APPDOCS.angular_dependencies.push('todo');

angular.module('component_catalog').run(function(ComponentCatalog){
    ComponentCatalog.add_test_page({
        group: 'app',
        title: 'Example: A TODO',
        category: 'Example',
        folder: 'components/todo_example/docs/',
        example: 'todo_sample.html',
        src: ['todo_sample.js'], //optional
    });


    ComponentCatalog.add_test_page({
        group: 'app',
        title: 'MyTestpage',
        category: 'Example',
        folder: 'components/todo_example/docs/',
        example: 'mytestpage.html',
    });

});

angular.module('component_catalog').controller('TodoSampleCtrl', function($scope, TODOModel){
    $scope.add_laundry = function(){
        TODOModel.newtodo = 'Do the laundry';
        TODOModel.add();
    };
});