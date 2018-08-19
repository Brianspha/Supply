pragma solidity 0.4.24;
import "./HelperFunctions.sol";
//@Dev Keeps all data related to farmers

contract Farmer is HelperFunctions
{


    //@Dev represents a farm
    struct Farm
    {
      string Address;
      uint256 Index;
    }
    //@Dev Represents a famers details
    struct FarmerDetails
    {
        address ID;
        string name;
        string lastname;
        string email;
        string Address;
        string password;
        bool Active;
    }
    mapping(address => FarmerDetails) Farmers;
    constructor() public
    {

    }
    //@Dev Adds new farmer details
function AddNewFarmer(string name ,string lname,string email,string location,string pass) returns (string message)
{
    if(isStringNullorEmpty(name) ||isStringNullorEmpty(lname)||isStringNullorEmpty(email)||isStringNullorEmpty(pass)||isStringNullorEmpty(location))
    {
        message="Please check if all data entered is correct";
        emit GeneralLogger(message);
        return message;
    }
    if(msg.sender == address(0))
    {
        message="Invalid sender address";
        emit GeneralLogger(message);
        return message;
    }
    if(Farmers[msg.sender].Active)
    {
        message="Farmer already registered!";
        emit GeneralLogger(message);
        return message;
    }
    Farmers[msg.sender]=FarmerDetails(msg.sender,name,lname,email,location,pass,true);
}
//@Dev Gets specified famers details
function GetFarmerDetails (address ID) view returns (string name,string lname,string email,string location,string error)
{
    if(ID ==address(0))
    {
     emit GeneralLogger("Invalid Farmer Address");
     return ("","","","","Invalid Farmer Address");
    }
    if(!Farmers[ID].Active)
    {
      emit GeneralLogger("Famer not registered");
      return ("","","","","Farmer not registered");
    }
    name=Farmers[ID].name;
    lname=Farmers[ID].lastname;
    email=Farmers[ID].email;
    location=Farmers[ID].Address;
    error="";
    return (name,lname,email,location,error);
}
//@Dev updates specified famers details
function UpdateFarmerDetails (address ID,string name,string sname,string location,string email,string password) view returns (string message)
{
    if(ID ==address(0))
    {
     message="Invalid Farmer Address";
     emit GeneralLogger(message);
     return (message);
    }
    if(isStringNullorEmpty(name) ||isStringNullorEmpty(sname)|| isStringNullorEmpty(email) || isStringNullorEmpty(location)||isStringNullorEmpty(password))
    {
        message="Provided input cannot be empty please try again";
        emit GeneralLogger(message);
        return message;
    }
    if(!Farmers[ID].Active)
    {
      message ="Famer not registered";  
      emit GeneralLogger(message);
      return message;
    }
    Farmers[ID].name=name;
    Farmers[ID].lastname=sname;
    Farmers[ID].email=email;
    Farmers[ID].Address=location;
    message="Succesfuly updated farmer details";
    return message;
}

}