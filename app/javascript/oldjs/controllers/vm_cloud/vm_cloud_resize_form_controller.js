ManageIQ.angular.app.controller('vmCloudResizeFormController', ['$http', '$scope', 'vmCloudResizeFormId', 'objectId', 'miqService', function($http, $scope, vmCloudResizeFormId, objectId, miqService) {
  var vm = this;

  var init = function() {
    vm.vmCloudModel = {
      flavor_id: null,
    };
    vm.flavors = [];
    vm.formId = vmCloudResizeFormId;
    vm.objectId = objectId;
    vm.saveable = miqService.saveable;

    ManageIQ.angular.scope = $scope;

    vm.newRecord = vm.formId === 'new';

    miqService.sparkleOn();
    $http.get('/vm_cloud/resize_form_fields/' + vm.formId + '?objectId=' + vm.objectId)
      .then(getResizeFormData)
      .catch(miqService.handleFailure);
  };

  vm.cancelClicked = $scope.cancelClicked = function() {
    miqService.sparkleOn();
    var url = '/vm_cloud/resize_vm/' + vm.formId + '?button=cancel';
    miqService.miqAjaxButton(url, {
      objectId: vm.objectId,
    });
  };

  vm.submitClicked = $scope.submitClicked = function() {
    miqService.sparkleOn();
    var url = '/vm_cloud/resize_vm/' + vm.formId + '?button=submit';
    miqService.miqAjaxButton(url, {
      objectId: vm.objectId,
      flavor_id: vm.vmCloudModel.flavor_id,
    });
  };

  function getResizeFormData(response) {
    var data = response.data;
    vm.flavors = data.flavors;
    vm.vmCloudModel.flavor_id = data.flavor_id;
    vm.modelCopy = angular.copy(vm.vmCloudModel);
    miqService.sparkleOff();
  }

  init();
}]);
