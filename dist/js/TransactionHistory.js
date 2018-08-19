(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory();
	else if(typeof define === 'function' && define.amd)
		define([], factory);
	else {
		var a = factory();
		for(var i in a) (typeof exports === 'object' ? exports : root)[i] = a[i];
	}
})(typeof self !== 'undefined' ? self : this, function() {
return /******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports) {

//@Dev ensure that we only fillup the Blockchain table only after the Dom elements have been loaded 
document.addEventListener('DOMContentLoaded', function () {

  //@Dev responsible for getting the current pages name
  var segments = window.location.pathname.split('/');
  var toDelete = [];
  for (var i = 0; i < segments.length; i++) {
    if (segments[i].length < 1) {
      toDelete.push(i);
    }
  }
  for (var i = 0; i < toDelete.length; i++) {
    segments.splice(i, 1);
  }
  var filename = segments[segments.length - 1];
  //@Dev Operation End

  //@Dev we only populate the table only if we in any of the Blockchain pages
  if (filename.includes("Blockchain")) {
    PrintBlockchainHistory();
  }

  //@Dev Populates the Blockchain table with transaction history
  function PrintBlockchainHistory() {
    var table = document.getElementById("BlockchainSummary");
    var transactionsList = JSON.parse(localStorage.getItem("TransactionsList"));
    if (transactionsList != null) {
      var count = transactionsList.length - 1;
      for (var i = 1; i < 10; i++, count--) //place the last 10 transactions
      {
        var row = table.insertRow(table.length);
        var cell1 = row.insertCell(0);
        var cell2 = row.insertCell(1);
        var cell3 = row.insertCell(2);
        var currentTransaction = transactionsList[count];
        cell1.innerHTML = currentTransaction.TransactionHash.toString();
        cell2.innerHTML = currentTransaction.BlockNumber.toString();
        cell3.innerHTML = currentTransaction.GasUsed != null ? currentTransaction.GasUsed.toString() : "NaN";
      }
    }
  }
}, false);

/***/ })
/******/ ]);
});