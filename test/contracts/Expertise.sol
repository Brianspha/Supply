pragma solidity 0.4.24;
import "./Ownable.sol";
import "./HelperFunctions.sol";
//@Dev to ask
contract Expertise is Ownable,HelperFunctions
{
    //@Dev represents lab results
    struct LabResults
    {
        string Name;
        string LabAddress;
        string Manufacturer;
        string Harvest;
        string LabConclusion;
        uint256 index;
    }
    //@Dev represents an ExpertiseObject
    struct ExpertiseObject
    {
      address LabAddress;
      uint256 DataAccessIndex;//@Dev keeps track of the amount of data that has been requested by user N.B. have to fix this in the other contracts to match this comment
      uint256 dataIndex;//@Dev Keeps track of the amount of data we have stored in the Data Mapping
      bool Activated;//@Dev Indicates whether the RawMaterial is active or not
      mapping(uint256 => LabResults) StoredData; //@Dev represents all the data related to a Lab
  
    }

    //@Dev stores data at the specified byte32 index
    mapping(address => ExpertiseObject)  ExpertiseData;
    

    constructor() public
    {
        
    }

    // @Dev stores data using the given paramters to the data mapping
    //To revise
    //check whether the string being added is not null or empty
    function storeValue(address labAddress, string name,string labaddress,string manufacturer,string harvest,string conclusion) public onlyOwner returns (string message)
    {
        if(isStringNullorEmpty(name)||isStringNullorEmpty(labaddress)||isStringNullorEmpty(manufacturer)||isStringNullorEmpty(harvest)||isStringNullorEmpty(conclusion))
        {
            message="Invalid Data";
            emit GeneralLogger(message);
            return message;
        }
        if(labAddress ==address(0))
        {
            message="Invalid lab address";
            emit GeneralLogger(message);
            return message;
        }
         if(ExpertiseData[labAddress].Activated)
        {
            ExpertiseData[labAddress].StoredData[ExpertiseData[labAddress].dataIndex]=LabResults(name,labaddress,manufacturer,harvest,conclusion,ExpertiseData[labAddress].dataIndex);
            ExpertiseData[labAddress].dataIndex++;
        }
        else
        {
            ExpertiseData[labAddress]=ExpertiseObject(labAddress,0,0,true);
            ExpertiseData[labAddress].StoredData[ExpertiseData[labAddress].dataIndex]=LabResults(name,labaddress,manufacturer,harvest,conclusion,ExpertiseData[labAddress].dataIndex);
            ExpertiseData[labAddress].dataIndex++;
        }
        message="Successfully stored Expertise data";
        emit GeneralLogger(message);
        return message;
    }

    //@Dev Gets Lab data 
    function GetLabData () view returns (bytes32 name,bytes32 labaddress,bytes32 manufacturer,bytes32 harvest,bytes32 conclusion,bool found)
    {
      if(msg.sender == address(0))
      {
          emit GeneralLogger("Invalid sender address");
          return (name,labaddress,manufacturer,harvest,conclusion,false);
      }
      if(!ExpertiseData[msg.sender].Activated)
      {
       emit GeneralLogger("No Lab data for specified user");
       return (name,labaddress,manufacturer,harvest,conclusion,false);
      }
      name = stringToBytes32(ExpertiseData[msg.sender].StoredData[ExpertiseData[msg.sender].DataAccessIndex].Name);
      labaddress = stringToBytes32(ExpertiseData[msg.sender].StoredData[ExpertiseData[msg.sender].DataAccessIndex].LabAddress);
      manufacturer = stringToBytes32(ExpertiseData[msg.sender].StoredData[ExpertiseData[msg.sender].DataAccessIndex].Manufacturer);
      harvest = stringToBytes32(ExpertiseData[msg.sender].StoredData[ExpertiseData[msg.sender].DataAccessIndex].Harvest);
      conclusion = stringToBytes32(ExpertiseData[msg.sender].StoredData[ExpertiseData[msg.sender].DataAccessIndex++].LabConclusion); 
      found=true;
      return (name,labaddress,manufacturer,harvest,conclusion,true);
    }
}
