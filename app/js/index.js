import Farmer from 'Embark/contracts/Farmer';
import Grower from 'Embark/contracts/Grower';
import Lab from "Embark/contracts/Lab";
import Expertise from "Embark/contracts/Expertise";
import RawMaterial from "Embark/contracts/RawMaterial";
import $ from "jquery";
import EmbarkJS from "Embark/EmbarkJS";
import async from "async";
import JSAlert  from "js-alert"
EmbarkJS.onReady(() => {
  $(document).ready(() => {
    // @Dev invoked when the send  button is clicked under the creaet farmer profile page
    $("#sendProfile").click((e) => {
      e.preventDefault();
      const name = document.getElementById('name').value;
      const lname = document.getElementById('lname').value;
      const email = document.getElementById('email').value;
      const address = document.getElementById('location').value;
      const pass = document.getElementById('password').value;
      const pass2 = document.getElementById('password2').value;
      if (pass != pass2) {
        JSAlert.alert('Passwords dont match please try again!');
        return;
      }
      web3.eth.getAccounts().then((e) => {
      const acc = e[0];
      const results = Farmer.methods.AddNewFarmer(name, lname, email, address, pass).send({
        from: acc.toString(),
        gas: 4000000,
      }).then((val, err) => {
        if (err) {
          JSAlert.alert(`Something went wrong: ${err}`);
        } else {
          outputTransactionRecipt(val);
          JSAlert.alert("Successfully created Farmer Profile.", "Profile Created", "Close");
        }
      });
      return false;
      });
      return false;
    });

    // @Dev invoked when the send  button is clicked under the creaet farmer profile page
    $('#updateProfile').click((e) => {
      const name = document.getElementById('name').value;
      const lname = document.getElementById('sname').value;
      const email = document.getElementById('email').value;
      const address = document.getElementById('location').value;
      const pass = document.getElementById('password').value;
      const pass2 = document.getElementById('password1').value;
      if (pass != pass2) {
        JSAlert.alert('Passwords dont match please try again!');
        return;
      }
      web3.eth.getAccounts().then((e) => {
        const acc = e[0];
        const results = Farmer.methods.UpdateFarmerDetails(name, lname, email, address, pass).send({
          from: acc.toString(),
          gas: 4000000,
        }).then((val, err) => {
          if (err) {
            JSAlert.alert(`Something went wrong: ${err}`);
          } else {
            const ans = outputTransactionRecipt(val);
            JSAlert.alert("Successfully updatedd Farmer Profile.", "Updated Profile.", "Close");
          }
        });
        return false;
      });
      return false;
    });

    // @Dev invoked when the send  button is clicked under the creaet farmer profile page
    $('#sendHarvest').click((e) => {
      e.preventDefault();
      const StrainHarvest = document.getElementById('StrainHarvest').value;
      const PlantCount = document.getElementById('PlantCount').value;
      const weight = document.getElementById('weight').value;
      const wetPlant = document.getElementById('wetPlant').value;
      const wetTrim = document.getElementById('wetTrim').value;
      const wetFlower = document.getElementById('wetFlower').value;
      const dryTrim = document.getElementById('dryTrim').value;
      const dryFlower = document.getElementById('dryFlower').value;
      const seeds = document.getElementById('seeds').value;
      const TotalUsable = document.getElementById('TotalUsable').value;
      const TotalUnusable = document.getElementById('TotalUnusable').value;
      web3.eth.getAccounts().then((e) => {
        const acc = e[0];
        const results = Grower.methods.StoreGrowerInformation(StrainHarvest, PlantCount, weight, wetPlant, wetTrim, wetFlower, dryTrim, dryFlower, seeds, TotalUsable, TotalUnusable, new Date().toString()).send({
          from: acc.toString(),
          gas: 4000000,
        }).then((val, err) => {
          if (err) {
            JSAlert.alert(`Something went wrong ${err}`);
          } else {
           var ans= outputTransactionRecipt(val);
            JSAlert.alert("Successfully Created Harvest.", "Harvest Created.", "Close");

          }
        });
        return false;
      });
    });


    // @Dev triggered when View Farmer Profile is clicked
    $('#sendLab').click((e) => {
      e.preventDefault();
      const labName = document.getElementById('Labname').value;
      const location = document.getElementById('location').value;
      web3.eth.getAccounts().then((e) => {
        const acc = e[0];
        const results = Lab.methods.StoreLabDetails(labName, location).send({
          from: acc.toString(),
          gas: 4000000,
        }).then((val, err) => {
          if (err) {
            JSAlert.alert(`Something went wrong: ${err}`);
          } else {
          var ans=  outputTransactionRecipt(val);
          JSAlert.alert("Successfully created Lab data.", "Lab Created.", "Close");
          }
        });
      });
    });

    // @Dev triggered when View Farmer Profile is clicked
    $('#sendExpertise').click((e) => {
      e.preventDefault();
      const labName = document.getElementById('Expertname').value;
      const Address = document.getElementById('location').value;
      const Manufacturer = document.getElementById('Manufacturer').value;
      const Harvest = document.getElementById('Harvest').value;
      const Conclusion = document.getElementById('Conclusion').value;
      web3.eth.getAccounts().then((e) => {
        const acc = e[0];
        const results = Expertise.methods.StoreExpertiseData(labName, Address, Manufacturer, Harvest, Conclusion).send({
          from: acc.toString(),
          gas: 4000000,
        }).then((val, err) => {
          if (err) {
            JSAlert.alert(`Something went wrong: ${err}`);
          } else {
            var ans =outputTransactionRecipt(val);
            JSAlert.alert("Successfully created Expertise data.", "Expertise Created.", "Close");

          }
        });
      });
    });
    // @Dev invoked when the user clicks on the edit farmer profile on the ui
    $('#RefreshEdit').click((e) => {
      e.preventDefault();
      const name = document.getElementById('name');
      const lname = document.getElementById('sname');
      const email = document.getElementById('email');
      const address = document.getElementById('location');
      const pass = document.getElementById('password');
      const pass2 = document.getElementById('password1');
      web3.eth.getAccounts().then((e) => {
        const acc = e[0];
        // @Dev i used send instead of call cause i want to get the transaction recipt because
        // call returns the values without block details which include the recipt
        Farmer.methods.GetFarmerDetails().send({
          from: acc.toString(),
          gas: 4000000,
        }).then((val, err) => {
          if (err) {
            JSAlert.alert(`Something went wrong: ${err}`);
          } else {
          var ans=  outputTransactionRecipt(val);
            const dets = GetFarmerDetails(val);
            if (dets === null || dets.Error === 'Invalid Farmer Address' || dets.Error === 'Farmer not registered') {
              JSAlert.alert('Farmer not registered or Invalid Farmer Address');
              return false;
            }
            name.value = `${dets.Name.toString()} `;
            lname.value = dets.Surname.toString();
            email.value = dets.Email.toString();
            address.value = dets.Location.toString();
            pass.value = dets.Password;
            return false;
          }
        });
      });
    });

    // @Dev invoked when the user clicks on the view Farmer profile option on the ui
    $('#FarmerProfile').click((e) => {
      e.preventDefault();
      const name = document.getElementById('name');
      const email = document.getElementById('email');
      const location = document.getElementById('location');
      web3.eth.getAccounts().then((e) => {
        const acc = e[0];
        // @Dev i used send instead of call cause i want to get the transaction recipt because
        // call returns the values without block details which include the recipt
        Farmer.methods.GetFarmerDetails().send({
          from: acc.toString(),
          gas: 4000000,
        }).then((val, err) => {
          if (err) {
            JSAlert.alert(`Something went wrong: ${err}`);
          } else {
            outputTransactionRecipt(val);
            const dets = GetFarmerDetails(val);
            if (dets == null || dets.Error == 'Invalid Farmer Address' || dets.Error == 'Farmer not registered') {
              JSAlert.alert('Farmer not registered or Invalid Farmer Address');
              return false;
            }
            name.value = `${dets.Name.toString()} ${dets.Surname.toString()}`;
            email.value = dets.Email.toString();
            location.value = dets.Location.toString();
            return false;
          }
        });
      });
      // return false;
    });

    // @Dev invoked when the user clicks on the view harvest option on the ui
    $('#refreshHarvest').click((e) => {
      e.preventDefault();
      web3.eth.getAccounts().then((e) => {
        const acc = e[0];
        // @Dev i used send instead of call cause i want to get the transaction recipt because
        // call returns the values without block details which include the recipt
        const results = Grower.methods.GetGrowerDataDeclarationDate().send({
          from: acc.toString(),
          gas: 4000000,
        }).then((val, err) => {
          if (err) {
            JSAlert.alert(`Something went wrong! \n${err}`);
          } else {
            outputTransactionRecipt(val);
            const HarvestDets = GetGrowerDate(val);
            if (HarvestDets == null) {
              JSAlert.alert('Harvest details not found');
              return false;
            }
            const table = document.getElementById('HarvestDetails');
            const row = table.insertRow(table.length);
            const cell1 = row.insertCell(0);
            const cell2 = row.insertCell(1);
            cell1.innerHTML = HarvestDets.StrainHarvest;
            cell2.innerHTML = HarvestDets.Date.toString();
            return false;
          }
        });
      });
    });

    // @Dev invoked when the user clicks on the viewLab ui option
    $('#refreshLab').click((e) => {
      web3.eth.getAccounts().then((e) => {
        const acc = e[0];
        // @Dev i used send instead of call cause i want to get the transaction recipt because
        // call returns the values without block details which include the recipt
        const results = Lab.methods.GetLabDetails().send({
          from: acc.toString(),
          gas: 8000000,
        }).then((val, err) => {
          if (err) {
            JSAlert.alert(`Something went wrong! \n${err}`);
          } else {
            outputTransactionRecipt(val);
            const LabDets = GetLabDetails(val);
            if (LabDets == null) {
              JSAlert.alert('Lab details not found');
              return false;
            }
            const table = document.getElementById('ViewLabDetails');
           // table.deleteRow(table.length);
            const row = table.insertRow(table.length);
            const cell1 = row.insertCell(0);
            const cell2 = row.insertCell(1);
            const cell3 = row.insertCell(2);
            cell1.innerHTML = LabDets.Name;
            cell2.innerHTML = LabDets.Location;
            cell3.innerHTML = acc.toString();
            return false;
          }
        });
      });
    });
    // @Dev invoked when the user clicks on the view Exppertise ui  option
    $('#refreshExpertise').click((e) => {
      e.preventDefault();
      web3.eth.getAccounts().then((e) => {
        const acc = e[0];
        const results = Expertise.methods.GetExpertiseData().send({
          from: acc.toString(),
          gas: 4000000,
        }).then((val, err) => {
          if (err) {
            JSAlert.alert(`Something went wrong: ${err}`);
          } else {
            outputTransactionRecipt(val);
            const LabDets = GetExpertiseData(val);
            if (LabDets == null || !LabDets.Found) {
              JSAlert.alert('Farmer details not found');
              return false;
            }
            const table = document.getElementById('ViewExpertiseInfo');
            const row = table.insertRow(table.length);
            const cell1 = row.insertCell(0);
            const cell2 = row.insertCell(1);
            const cell3 = row.insertCell(2);
            cell1.innerHTML = LabDets.Name;
            cell2.innerHTML = LabDets.Location;
            cell3.innerHTML = acc.toString();
            return false;
          }
        });
      });
    });

    // @Dev Page Click Start
    $('#Blockchain').click((e) => {
      PrintBlockchainHistory();
    });

    // @Dev Populates the Blockchain table with transaction history
    function PrintBlockchainHistory() {
      const table = document.getElementById('BlockchainSummary');
      const transactionsList = JSON.parse(localStorage.getItem('TransactionsList'));
      if (transactionsList != null) {
        let count = transactionsList.length - 1;
        for (let i = 1; i < 10; i++, count--) // place the last 10 transactions
        {
          const row = table.insertRow(table.length);
          const cell1 = row.insertCell(0);
          const cell2 = row.insertCell(1);
          const cell3 = row.insertCell(2);
          const currentTransaction = transactionsList[count];
          cell1.innerHTML = currentTransaction.TransactionHash.toString();
          cell2.innerHTML = currentTransaction.BlockNumber.toString();
          cell3.innerHTML = currentTransaction.GasUsed != null ? currentTransaction.GasUsed.toString() : 'NaN';
        }
      }
    }

    // @Dev responsible for outputting the transaction recipt each time a contract call is made
    function outputTransactionRecipt(value) {
      const transactionEvents = value.events;
      const returnValues = transactionEvents.GeneralLogger.returnValues.toString();
      if (transactionEvents == null) return;
      // var returnedVal = transactionEvents.GeneralLogger.returnValues;
      let string = `Address: ${transactionEvents.GeneralLogger.address}\n blockHash: ${transactionEvents.GeneralLogger.blockHash}\n BlockNumber: ${transactionEvents.GeneralLogger.blockNumber}\n event: ${transactionEvents.GeneralLogger.event}\n Id: ${transactionEvents.GeneralLogger.id}\n Value returned: ${transactionEvents.GeneralLogger.returnValues[0]}`;
      string += `\n Gasused: ${transactionEvents.cumulativeGasUsed}\n TransactionHash :${transactionEvents.GeneralLogger.transactionHash}\n Transactionstatus: ${transactionEvents.GeneralLogger.type}`;
      console.log(string);
      let transactionsList = JSON.parse(localStorage.getItem('TransactionsList'));
      if (transactionsList == null) {
        transactionsList = [];
        transactionsList.push({
          Signiture: transactionEvents.GeneralLogger.signature,
          Address: transactionEvents.GeneralLogger.address,
          BlockHash: transactionEvents.GeneralLogger.blockHash,
          BlockNumber: transactionEvents.GeneralLogger.blockNumber,
          GasUsed: value.cumulativeGasUsed,
          TransactionHash: transactionEvents.GeneralLogger.transactionHash,
          TransactionStatus: transactionEvents.GeneralLogger.type,
        });
        localStorage.setItem('TransactionsList', JSON.stringify(transactionsList));
        return returnValues;
      }
      transactionsList.push({
        Signiture: transactionEvents.GeneralLogger.signature,
        Address: transactionEvents.GeneralLogger.address,
        BlockHash: transactionEvents.GeneralLogger.blockHash,
        BlockNumber: transactionEvents.GeneralLogger.blockNumber,
        GasUsed: value.cumulativeGasUsed,
        TransactionHash: transactionEvents.GeneralLogger.transactionHash,
        TransactionStatus: transactionEvents.GeneralLogger.type,
      });
      localStorage.setItem('TransactionsList', JSON.stringify(transactionsList));
      return returnValues;
    }

    // @Dev Gets the famer values returned by contract via the event
    function GetFarmerDetails(event) {
      const details = event.events.Details;
      if (details == null) return null;
      return {
        Name: details.returnValues.name,
        Surname: details.returnValues.lname,
        Location: details.returnValues.location,
        Email: details.returnValues.email,
        Error: details.returnValues.error,
        Password: details.returnValues.password,
      };

    }

    // @Dev Gets the date value returned by contract via the event
    function GetGrowerDate(val) {
      const Dets = val.events.DeclarationLogger;
      if (Dets == null) return null;
      return {
        Date: Dets.returnValues.date,
        StrainHarvest: Dets.returnValues.strainH,
      };
    }

    // @Dev Gets the Lab data returned by smart contract event
    function GetLabDetails(val) {
      const labdets = val.events.LabDataLogger;
      if (labdets == null) return null;
      return {
        Name: labdets.returnValues.name,
        Location: labdets.returnValues.Location,
      };
    }

    // @Dev Gets Expertise data value returned by the event
    function GetExpertiseData(val) {
      const dets = val.events.event.GetExpertiseDataLogger;
      if (dets == null) return null;
      const temp = {
        HarvestName: dets.returnValues.HarvestName,
        FarmerName: dets.returnValues.FarmerName,
        FarmerLocation: dets.returnValues.FarmerLocation,
        Found: dets.returnValues.message !== ('Invalid sender address' || 'Farmer details not found or no data associated to give Ethereum address found'),
      };
      return temp;
    }

  });

});