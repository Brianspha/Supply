pragma solidity 0.4 .24;
import "./HelperFunctions.sol";
//@Dev Keeps all data related to farmers

contract Farmer is HelperFunctions {


    //@Dev represents a farm
    struct Farm {
        string Address;
        uint256 Index;
    }
    //@Dev Represents a famers details
    struct FarmerDetails {
        address ID;
        string name;
        string lastname;
        string email;
        string Address;
        string password;
        bool Active;
    }
    mapping(address => FarmerDetails) Farmers;
    event Details(string name, string lname, string email, string location, string password, string error);
    constructor() public {

    }
    //@Dev Adds new farmer details
    function AddNewFarmer(string name, string lname, string email, string location, string pass) public returns(string message) {
        if (isStringNullorEmpty(name) || isStringNullorEmpty(lname) || isStringNullorEmpty(email) || isStringNullorEmpty(pass) || isStringNullorEmpty(location)) {
            message = "Please check if all data entered is correct";
            emit GeneralLogger(message);
            return message;
        }
        if (msg.sender == address(0)) {
            message = "Invalid sender address";
            emit GeneralLogger(message);
            return message;
        }
        if (Farmers[msg.sender].Active) {
            message = "Farmer already registered!";
            emit GeneralLogger(message);
            return message;
        }
        Farmers[msg.sender] = FarmerDetails(msg.sender, name, lname, email, location, pass, true);
    }
    //@Dev Gets specified famers details
    function GetFarmerDetails() public returns(string name, string lname, string email, string location, string password, string error) {
        if (msg.sender == address(0)) {
            emit GeneralLogger("Invalid Farmer Address");
            return ("", "", "", "", "", "Invalid Farmer Address");
        }
        if (!Farmers[msg.sender].Active) {
            emit GeneralLogger("Famer not registered");
            return ("", "", "", "", "", "Farmer not registered");
        }
        name = Farmers[msg.sender].name;
        lname = Farmers[msg.sender].lastname;
        email = Farmers[msg.sender].email;
        location = Farmers[msg.sender].Address;
        password = Farmers[msg.sender].password;
        error = "Farmer details found ";
        emit GeneralLogger(error);
        emit Details(name, lname, email, location, password, error);
        return (name, lname, email, location, password, error);
    }
    //@Dev Gets Farmer details required by Expertise Contract inter smart contract method calls 
    //only allow strings to be passed around if they are in bytes32 format
    function GetDetails() public returns(bytes32 name, bytes32 location, bool found) {
        if (msg.sender == address(0)) {
            emit GeneralLogger("Invalid sender address");
            return (stringToBytes32("null"), stringToBytes32("null"), false);
        }
        if (!Farmers[msg.sender].Active) {
            emit GeneralLogger("Farmer not Found");
            return (stringToBytes32("null"), stringToBytes32("null"), false);
        }
        emit GeneralLogger("Farmer Details Found");
        name = stringToBytes32(Farmers[msg.sender].name);
        location =stringToBytes32(Farmers[msg.sender].Address);
        found =true;
        return (name,location,found);
    }
    //@Dev updates specified famers details
    function UpdateFarmerDetails(string name, string sname, string location, string email, string password) public returns(string message) {
        if (msg.sender == address(0)) {
            message = "Invalid  Farmer Address";
            emit GeneralLogger(message);
            return (message);
        }
        if (isStringNullorEmpty(name) || isStringNullorEmpty(sname) || isStringNullorEmpty(email) || isStringNullorEmpty(location) || isStringNullorEmpty(password)) {
            message = "Provided input cannot be empty please try again";
            emit GeneralLogger(message);
            return message;
        }
        if (!Farmers[msg.sender].Active) {
            message = "Famer not registered";
            emit GeneralLogger(message);
            return message;
        }
        Farmers[msg.sender].name = name;
        Farmers[msg.sender].lastname = sname;
        Farmers[msg.sender].email = email;
        Farmers[msg.sender].Address = location;
        Farmers[msg.sender].password = password;
        message = "Succesfuly updated farmer details";
        emit GeneralLogger(message);
        return message;
    }

}