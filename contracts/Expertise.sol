pragma solidity 0.4 .24;
import "./Ownable.sol";
import "./HelperFunctions.sol";
import "./Farmer.sol";
//@Dev to ask
contract Expertise is Ownable, HelperFunctions {
    //@Dev represents lab results
    struct LabResults {
        string Name;
        string location;
        string Manufacturer;
        string Harvest;
        string LabConclusion;
        uint256 index;
    }
    //@Dev represents an ExpertiseObject
    struct ExpertiseObject {
        address labaddress;
        uint256 DataAccessIndex; //@Dev keeps track of the amount of data that has been requested by user N.B. have to fix this in the other contracts to match this comment
        uint256 dataIndex; //@Dev Keeps track of the amount of data we have stored in the Data Mapping
        bool Activated; //@Dev Indicates whether the RawMaterial is active or not
        mapping(uint256 => LabResults) StoredData; //@Dev represents all the data related to a Lab

    }

    //@Dev stores data at the specified byte32 index
    mapping(address => ExpertiseObject) ExpertiseData;

    //@Dev called when Expertise data is requested
    event FarmerData(string name, string labaddress, string manufacturer, string harvest, string conclusion, bool found);
    //@Dev called when the GetExpertise method is called and passes all prerequisites
    event GetExpertiseDataLogger(string HarvestName, string FarmerName, string FarmerLocation, string message);
    //@Dev represents the Farmer contract
    Farmer InternalFarmer;

    constructor(address internalFarmerAddress) public {
        require(internalFarmerAddress != address(0));
        InternalFarmer = Farmer(internalFarmerAddress);
    }

    // @Dev stores data using the given paramters to the data mapping
    //To revise
    //check whether the string being added is not null or empty
    function StoreExpertiseData(string name, string labaddress, string manufacturer, string harvest, string conclusion) public onlyOwner returns(string message) {
        if (isStringNullorEmpty(name) || isStringNullorEmpty(labaddress) || isStringNullorEmpty(manufacturer) || isStringNullorEmpty(harvest) || isStringNullorEmpty(conclusion)) {
            message = "Invalid Data";
            emit GeneralLogger(message);
            return message;
        }
        if (msg.sender == address(0)) {
            message = "Invalid lab address";
            emit GeneralLogger(message);
            return message;
        }
        if (ExpertiseData[msg.sender].Activated) {
            ExpertiseData[msg.sender].StoredData[ExpertiseData[msg.sender].dataIndex] = LabResults(name, labaddress, manufacturer, harvest, conclusion, ExpertiseData[msg.sender].dataIndex);
            ExpertiseData[msg.sender].dataIndex++;
        } else {
            ExpertiseData[msg.sender] = ExpertiseObject(msg.sender, 0, 0, true);
            ExpertiseData[msg.sender].StoredData[ExpertiseData[msg.sender].dataIndex] = LabResults(name, labaddress, manufacturer, harvest, conclusion, ExpertiseData[msg.sender].dataIndex);
            ExpertiseData[msg.sender].dataIndex++;
        }
        message = "Successfully stored Expertise data";
        emit GeneralLogger(message);
        return message;
    }

    //@Dev Gets Lab data 
    function GetLabData() public returns(string name, string labaddress, string manufacturer, string harvest, string conclusion, bool found) {
        if (msg.sender == address(0)) {
            emit GeneralLogger("Invalid sender address");
            return (name, labaddress, manufacturer, harvest, conclusion, false);
        }
        if (!ExpertiseData[msg.sender].Activated) {
            emit GeneralLogger("No Lab data for specified user");
            return (name, labaddress, manufacturer, harvest, conclusion, false);
        }
        name = ExpertiseData[msg.sender].StoredData[ExpertiseData[msg.sender].DataAccessIndex].Name;
        labaddress = ExpertiseData[msg.sender].StoredData[ExpertiseData[msg.sender].DataAccessIndex].location;
        manufacturer = ExpertiseData[msg.sender].StoredData[ExpertiseData[msg.sender].DataAccessIndex].Manufacturer;
        harvest = ExpertiseData[msg.sender].StoredData[ExpertiseData[msg.sender].DataAccessIndex].Harvest;
        conclusion = ExpertiseData[msg.sender].StoredData[ExpertiseData[msg.sender].DataAccessIndex++].LabConclusion;
        found = true;
        emit GeneralLogger("Lab data Found");
        emit FarmerData(name, labaddress, manufacturer, harvest, conclusion, true);
        return (name, labaddress, manufacturer, harvest, conclusion, true);
    }

    //@Dev variation of the GetLabdata function returns the name and harvest name and farm location only
    function GetExpertiseData() public returns(string HarvestName, string FarmerName, string FarmerLocation, string message) {
        if (msg.sender == address(0)) {
            message = "Invalid sender address";
            emit GeneralLogger(message);
            emit GetExpertiseDataLogger("", "", "", message);
            return ("", "", "", message);
        }
        bytes32 name = "";
        bytes32 location = "";
        bool found = false;
        (name, location, found) = InternalFarmer.GetDetails();
        if (!found || !ExpertiseData[msg.sender].Activated) {
            emit GeneralLogger("Farmer details not found or no data associated to give Ethereum address found");
            message = "Farmer details not found";
            return ("", "", "", message);
        }
        message="Farmer details Found";
        HarvestName=ExpertiseData[msg.sender].StoredData[ExpertiseData[msg.sender].DataAccessIndex].Name;
        FarmerName=bytes32ToString(name);
        FarmerLocation=bytes32ToString(location);
        emit GeneralLogger(message);
        emit GetExpertiseDataLogger(HarvestName,FarmerName,FarmerLocation,message);
        return (HarvestName,FarmerName,FarmerLocation,message);
    }
}