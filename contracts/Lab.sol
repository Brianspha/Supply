pragma solidity 0.4 .24;
import "./Ownable.sol";
import "./HelperFunctions.sol";

//@Dev contract that represents a lab
contract Lab is Ownable, HelperFunctions {


    //@Dev represents a Lab object
    struct LabDetails {
        address ID;
        string Name;
        string Location;
        uint256 dataIndex; //@Dev Keeps track of the amount of data we have stored in the Data Mapping
        uint256 DataAccessIndex; //@Dev used for keeping track of the data at this index that needs to be returned
        bool Activated; //@Dev Indicates whether the Lab is active or not
        mapping(uint256 => Data) StoredData; //@Dev represents all the data related to a Lab

    }

    //@Dev stores all lab related data
    mapping(address => LabDetails) LabData;

    //@Dev called when Lab data is requested and found
    event LabDataLogger(string name, string Location);

    //@Dev Constructor
    constructor() public {}

    //@Dev responsible for storing the specified data at the specified dataIndex
    //to be revised
    //Checking if the given data is not null or empty
    function StoreLabDetails(string name, string Location) public onlyOwner returns(string message) {
        if (msg.sender == address(0)) {
            message = "Invalid Address";
            emit GeneralLogger(message);
            return message;
        }
        if (isStringNullorEmpty(name) || isStringNullorEmpty(Location)) {
            message = "Name or Location of Farm cannot be empty";
            emit GeneralLogger(message);
            return message;
        }
        if (LabData[msg.sender].Activated) {
            message = "Lab Already Exist";
            emit GeneralLogger(message);
            return message;
        } else {
            LabData[msg.sender] = LabDetails(msg.sender, name, Location, 0, 0, true);
            LabData[msg.sender].dataIndex++;
        }
        message = "Succesfully stored Lab data";
        emit GeneralLogger(message);
        return message;
    }
    //@Dev Function for getting specific Lab Details 
    function GetLabDetails() public returns(string name, string Location) {
        if (msg.sender == address(0)) {
            emit GeneralLogger("Invalid Lab address");
            return ("Invalid Lab address", "");
        }
        if (!LabData[msg.sender].Activated) {
            emit GeneralLogger("Lab not registered");
            return ("Lab not registered", "");
        }
        emit GeneralLogger("Lab dadta Found");
        emit LabDataLogger(name, Location);
        name = LabData[msg.sender].Name;
        Location = LabData[msg.sender].Location;
        return (name, Location);
    }

    //@Dev Resets the DataIndexAccess value
    function ResetDataIndex() public returns(string message) {
        if (msg.sender == address(0)) {
            message = "Invalid address";
            emit GeneralLogger(message);
            return message;
        }
        if (!LabData[msg.sender].Activated) {
            message = "Lab not registered";
            emit GeneralLogger(message);
            return message;
        }
        LabData[msg.sender].DataAccessIndex = 0;
        message = "Succesfully reset Data access index";
        return message;
    }
}