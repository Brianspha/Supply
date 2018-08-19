pragma solidity 0.4.24;
import "./Ownable.sol";
import "./HelperFunctions.sol";

//@Dev contract that represents a lab
contract Lab is Ownable,HelperFunctions 
{


    //@Dev represents a Lab object
    struct LabDetails
    {
      address ID;
      string Name;
      string Location;
      uint256 dataIndex;//@Dev Keeps track of the amount of data we have stored in the Data Mapping
      uint256 DataAccessIndex;//@Dev used for keeping track of the data at this index that needs to be returned
      bool Activated;//@Dev Indicates whether the Lab is active or not
      mapping(uint256 => Data) StoredData; //@Dev represents all the data related to a Lab
   
    }
        
    //@Dev stores all lab related data
    mapping(address => LabDetails) LabData;

   //@Dev called when the storeValue function is called
    event Log(address indexed Address, string data);

    //@Dev Constructor
    constructor() public
    {
    }

    //@Dev responsible for storing the specified data at the specified dataIndex
    //to be revised
    //Checking if the given data is not null or empty
    function storeValue(address Address, string name,string Location) public onlyOwner returns (string message) 
    {
        if(Address == address(0))
        {
         message="Invalid Address";
         emit GeneralLogger(message);
         return message;
        }
        if(isStringNullorEmpty(name) ||isStringNullorEmpty(Location))
        {
            message="Name or Location of Farm cannot be empty";
            emit GeneralLogger(message);
            return message;
        }
        if(LabData[Address].Activated)
        {
           message="Lab Already Exist";
           emit GeneralLogger(message);
           return message;     
        }
        else
        {
          LabData[Address] = LabDetails(Address,name,Location,0,0,true);    
          LabData[Address].dataIndex++;  
        }
        message="Succesfully stored Lab data";
        emit GeneralLogger(message);
        return message;
    }
    //@Dev Function for getting specific Lab Details without the data
    function GetLabDetails() view returns (string name,string Location)
    {
       if(msg.sender == address(0))
       {
           emit GeneralLogger("Invalid Lab address");
           return ("Invalid Lab address","");
       }
       if(!LabData[msg.sender].Activated)
       {
           emit GeneralLogger("Lab not registered");
           return ("Lab not registered","");
       }
       name=LabData[msg.sender].Name;
       Location=LabData[msg.sender].Location;
       return (name,Location);
    }

    //@Dev Resets the DataIndexAccess value
    function ResetDataIndex() returns (string message)
    {
      if(msg.sender ==address(0))
      {
          message="Invalid address";
          emit GeneralLogger(message);
          return message;
      }    
      if(!LabData[msg.sender].Activated)
      {
          message="Lab not registered";
          emit GeneralLogger(message);
          return message;
      }
    LabData[msg.sender].DataAccessIndex=0;
    message="Succesfully reset Data access index";
    return message;
    }
}
