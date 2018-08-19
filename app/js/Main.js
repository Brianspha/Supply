import Farmer from 'Embark/contracts/Farmer';
import $ from 'jquery';

EmbarkJS.onReady(() => {
    // here

$(document).ready(function () 
{
 //Farmer.setProvider(new web3.providers.HttpProvider('http://localhost:8545')); // 8080 for cpp/AZ, 8545 for go/mist
    
//@Dev invoked when the send  button is clicked under the creaet farmer profile page    
$("#sendProfile").click(function()
{
  var name = document.getElementById("name").value;
  var lname = document.getElementById("lname").value;
  var email = document.getElementById("email").value;
  var address = document.getElementById("location").value;
  var pass = document.getElementById("password").value;
  var pass2 = document.getElementById("password2").value;
  if(pass != pass2)
  {
      alert("Passwords dont match please try again!");
       return;
  }
  web3.eth.getAccounts().then(e=>
  {
    var acc= e[0];    
  var results =Farmer.methods.AddNewFarmer(name,lname,email,address,pass).send({from:acc.toString(),gas:6000000}).then(function(val,err){
  if(err)
  {
      alert("Something went wrong: "+ err);
  }
  else
  {
   alert("Value returned \n" + val);
   console.log(val);
  }
  }).catch(function(error){
      alert(error);
  })

})
})
//@Dev invoked when the send  button is clicked under the creaet farmer profile page    
$("#getProfile").click(function()
{
    window.location.href="EditFarmerProfile.html";

})
//@Dev handles rejections thrown by calling smartcontract objecs
window.addEventListener('unhandledrejection', function(event) {
    console.error('Unhandled rejection (promise: ', event.promise, ', reason: ', event.reason, ').');
});


//@Dev invoked when the farmer edits their  profile editFarmerProfile page    
$("#getProfile").click(function()
{
    window.location.href="EditFarmerProfile.html";

})

//@Dev handles rejections thrown by calling smartcontract objecs
window.addEventListener('unhandledrejection', function(event) {
    console.error('Unhandled rejection (promise: ', event.promise, ', reason: ', event.reason, ').');
});
//@Dev Gets ethereum account at specified index
function GetAccount(index)
{
    var acc;
    if(index <0)index=0;
    web3.eth.getAccounts().then(e=>{
        if(index>e.length) index=0;     
        acc= e[index];    
    })
    return acc;
}

//@Dev responsible for outputting the transaction recipt each time a contract call is made
function outputTransactionRecipt(value)
{
    var test = value.events;
    var latest = test.GeneralLogger[test.GeneralLogger.length-1];
    var returnedVal="";
    if(!latest)
    {
        returnedVal+=test.GeneralLogger.returnValues.message +"\n";
      var string="Address: "+test.GeneralLogger.address +"\n blockHash: "+ test.GeneralLogger.blockHash +"\n BlockNumber: "+ test.GeneralLogger.blockNumber +"\n event: "+ test.GeneralLogger.event +"\n Id: "+test.GeneralLogger.id + "\n Value/s returned: "+returnedVal;
      string+="\n Gasused: " +test.GeneralLogger.gasUsed + "\n TransactionHash :" +test.GeneralLogger.transactionHash +"\n Transactionstatus: " + test.GeneralLogger.type;
      console.log(string);
      var transactionsList = JSON.parse(localStorage.getItem("TransactionsList"));
      if(transactionsList == null)
      {
        transactionsList=[];
        transactionsList.push({Signiture: test.GeneralLogger.signature,Address:test.GeneralLogger.address,BlockHash:test.GeneralLogger.blockHash,BlockNumber:test.GeneralLogger.blockNumber,GasUsed:test.GeneralLogger.gasUsed,TransactionHash:test.GeneralLogger.transactionHash,TransactionStatus:test.GeneralLogger.type});
        localStorage.setItem("TransactionsList",JSON.stringify(transactionsList));
        return;
      }
      transactionsList.push({Signiture: test.GeneralLogger.signature,Address:test.GeneralLogger.address,BlockHash:test.GeneralLogger.blockHash,BlockNumber:test.GeneralLogger.blockNumber,GasUsed:test.GeneralLogger.gasUsed,TransactionHash:test.GeneralLogger.transactionHash,TransactionStatus:test.GeneralLogger.type});
      localStorage.setItem("TransactionsList",JSON.stringify(transactionsList));
     return;
    }
    returnedVal=latest.returnValues !=null?latest.returnValues.message:"couldnt determine returned value!";
    var string="Address: "+latest.address +"\n blockHash: "+ latest.blockHash +"\n BlockNumber: "+ latest.blockNumber +"\n event: "+ latest.event +"\n Id: "+latest.id + "\n Value returned: "+ latest.returnValues[0];
    string+="\n Gasused: " +latest.gasUsed + "\n TransactionHash :" +latest.transactionHash +"\n Transactionstatus: " + latest.type;
    console.log(string);
    var transactionsList = JSON.parse(localStorage.getItem("TransactionsList"));
    if(transactionsList == null)
    {
      transactionsList=[];
      transactionsList.push({Signiture:latest.signature,Address:latest.address,BlockHash:latest.blockHash,BlockNumber:latest.blockNumber,GasUsed:latest.gasUsed,TransactionHash:latest.transactionHash,TransactionStatus:latest.type});
      localStorage.setItem("TransactionsList",JSON.stringify(transactionsList));
      return;
    }
    transactionsList.push({Signiture:latest.signature,Address:latest.address,BlockHash:latest.blockHash,BlockNumber:latest.blockNumber,GasUsed:latest.gasUsed,TransactionHash:latest.transactionHash,TransactionStatus:latest.type});
    localStorage.setItem("TransactionsList",JSON.stringify(transactionsList));
   
  }
  //@Dev function start   
})

//@Dev responsible for outputting the transaction recipt each time a contract call is made to be used on windowOnLoadforeach profile
function outputTransactionRecipt(value)
{
    var test = value.events;
    var latest = test.GeneralLogger[test.GeneralLogger.length-1];
    var returnedVal="";
    if(!latest)
    {
        returnedVal+=test.GeneralLogger.returnValues.message +"\n";
      var string="Address: "+test.GeneralLogger.address +"\n blockHash: "+ test.GeneralLogger.blockHash +"\n BlockNumber: "+ test.GeneralLogger.blockNumber +"\n event: "+ test.GeneralLogger.event +"\n Id: "+test.GeneralLogger.id + "\n Value/s returned: "+returnedVal;
      string+="\n Gasused: " +test.GeneralLogger.gasUsed + "\n TransactionHash :" +test.GeneralLogger.transactionHash +"\n Transactionstatus: " + test.GeneralLogger.type;
      console.log(string);
      var transactionsList = JSON.parse(localStorage.getItem("TransactionsList"));
      if(transactionsList == null)
      {
        transactionsList=[];
        transactionsList.push({Signiture: test.GeneralLogger.signature,Address:test.GeneralLogger.address,BlockHash:test.GeneralLogger.blockHash,BlockNumber:test.GeneralLogger.blockNumber,GasUsed:test.GeneralLogger.gasUsed,TransactionHash:test.GeneralLogger.transactionHash,TransactionStatus:test.GeneralLogger.type});
        localStorage.setItem("TransactionsList",JSON.stringify(transactionsList));
        return;
      }
      transactionsList.push({Signiture: test.GeneralLogger.signature,Address:test.GeneralLogger.address,BlockHash:test.GeneralLogger.blockHash,BlockNumber:test.GeneralLogger.blockNumber,GasUsed:test.GeneralLogger.gasUsed,TransactionHash:test.GeneralLogger.transactionHash,TransactionStatus:test.GeneralLogger.type});
      localStorage.setItem("TransactionsList",JSON.stringify(transactionsList));
     return;
    }
    returnedVal=latest.returnValues !=null?latest.returnValues.message:"couldnt determine returned value!";
    var string="Address: "+latest.address +"\n blockHash: "+ latest.blockHash +"\n BlockNumber: "+ latest.blockNumber +"\n event: "+ latest.event +"\n Id: "+latest.id + "\n Value returned: "+ latest.returnValues[0];
    string+="\n Gasused: " +latest.gasUsed + "\n TransactionHash :" +latest.transactionHash +"\n Transactionstatus: " + latest.type;
    console.log(string);
    var transactionsList = JSON.parse(localStorage.getItem("TransactionsList"));
    if(transactionsList == null)
    {
      transactionsList=[];
      transactionsList.push({Signiture:latest.signature,Address:latest.address,BlockHash:latest.blockHash,BlockNumber:latest.blockNumber,GasUsed:latest.gasUsed,TransactionHash:latest.transactionHash,TransactionStatus:latest.type});
      localStorage.setItem("TransactionsList",JSON.stringify(transactionsList));
      return;
    }
    transactionsList.push({Signiture:latest.signature,Address:latest.address,BlockHash:latest.blockHash,BlockNumber:latest.blockNumber,GasUsed:latest.gasUsed,TransactionHash:latest.transactionHash,TransactionStatus:latest.type});
    localStorage.setItem("TransactionsList",JSON.stringify(transactionsList));
   
  }   
//@Dev function end


window.onload = function() {
    var segments = window.location.pathname.split('/');
    var toDelete = [];
for (var i = 0; i < segments.length; i++) {
    if (segments[i].length < 1)
    {
      toDelete.push(i);
    }
}
for (var i = 0; i < toDelete.length; i++) {
    segments.splice(i, 1);
}
var filename = segments[segments.length - 1];
alert(filename);
//@Dev if statement start
if(filename.includes("FarmerProfile"))
 {
    var name = document.getElementById("name");
    var email = document.getElementById("email");
    var address = document.getElementById("location");
    web3.eth.getAccounts().then(e=>{
    var acc= e[0];    
    var results =Farmer.methods.GetFarmerDetails(acc.toString()).send({from:acc.toString(),gas:4000000}).then(function(val,err){
    if(err)
    {
        alert("Something went wrong: "+ err);
    }
    else
    {
     alert(val);
     Name,sname,Email,location,pass,error=val;
     if(error=="Invalid Farmer Address"||"Farmer not registered" )
     {
         alert("Farmer not registered or Invalid Farmer Address");
         outputTransactionRecipt(val);
         return;
     }
     name.value=Name + " " +sname;
     email.value=email;
     location.value = location;
     outputTransactionRecipt(val);
    }
    }).catch(function(error){
        alert(error);
    })

   }).catch(function(error){
      alert(error);
  })
    return;
  }
//@Dev if statement end
 //@Dev if statement start
  if(filename.includes("EditFarmerProfile"))
  {
    var name = document.getElementById("name");
    var email = document.getElementById("email");
    var address = document.getElementById("location");
    var lname = document.getElementById("lname");
    var email = document.getElementById("email");
    var address = document.getElementById("location");
    web3.eth.getAccounts().then(e=>
    { 
     var acc= e[0];     
    var results =Farmer.methods.GetFarmerDetails(web3.eth.defaultAccount.toString()).send({from:acc.toString(),gas:4000000}).then(function(val,err){
    if(err)
    {
        alert("Something went wrong: "+ err);
    }
    else
    {
     alert(val);
     outputTransactionRecipt(val);
     Name,sname,Email,location,pass,error=val;
     if(error=="Invalid Farmer Address"||"Farmer not registered" )
     {
         alert("Farmer not registered or Invalid Farmer Address");
         return;
     }
     name.value=Name + " " +sname;
     email.value=email;
     location.value = location;
    }
    }).catch(function(error){
        alert(error);
    })
    
  }).catch(function(error){
    alert(error);
})
  return;
}
//@Dev if statement end
};

});