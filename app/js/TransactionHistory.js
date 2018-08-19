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