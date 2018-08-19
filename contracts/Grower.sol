pragma solidity 0.4.24;
import "./Ownable.sol";
import "./HelperFunctions.sol";
//@Dev Keeps track of each growers data
contract Grower is Ownable,HelperFunctions
{
    
    //@Dev couldnt use any other term to name name the struct as the term Grower is alread taken by Contract
    struct GrowerObject
    {
      address ID;
      uint256 dataIndex;//@Dev Keeps track of the amount of data we have stored in the Data Mapping
      uint256 dataAccessIndex;//@Dev indicates what index mapping can be accessed as well as past indexes
      string Date;//@Dev represents the date the farmer submitted the data on
      bool Activated;//@Dev Indicates whether the grower is active or not
      mapping(uint256 => HarvestDetails) StoredData; //@Dev represents all the data related to a grower
    }
    struct HarvestDetails
    {
      string strainHarvest;
      uint256 numberOfPlants;
      uint256 weightMeasurement;
      uint256 wetPlant;
      uint256 wetTrim;
      uint256 wetFlower;
      uint256 dryTrim;
      uint256 dryFlower;
      uint256 seeds;
      uint256 TotalUsable;
      uint256 TotalUnsable;
      uint256 Index;
    }

    //@Dev Keeps track of data for each Grower using the specified address 
    mapping(address => GrowerObject)  Growers;

    //@Dev called when new data is stored in the data mapping  
    event GrowerInfo(address indexed Address, string strainH,uint256 numberOfPlants,uint256 weightM,uint256 wetP,uint256 wetT,uint256 wetF,uint256 dryT,uint256 dryFlwr,uint256 seeds,uint256 usable,uint256 unusable);
    //@Dev logs date a Harvest was created on
    event DeclarationLogger(string strainH,string date);
     constructor  () public
    {

    }

  //@Dev stores the specified data at the specifed address
    function StoreGrowerInformation(string strainH,uint256 numberOfPlants,uint256 weightM,uint256 wetP,uint256 wetT,uint256 wetF,uint256 dryT,uint256 dryFlwr,uint256 seeds,uint256 usable,uint256 unusable,string date) public onlyOwner returns (string message)
    {
        if(msg.sender == address(0))
        {
            message="Invalid Grower address";
            emit GeneralLogger(message);
            return message;
        }
        if(isStringNullorEmpty(strainH) ||isStringNullorEmpty(date)|| numberOfPlants <0 || weightM <0 || wetP <0 || wetT <0 || wetF <0 || dryFlwr<0 ||dryT<0 ||seeds <0 || usable <0 || unusable<0)
        {
            message="Invalid Data, data cannot be null or empty";
            emit GeneralLogger(message);
            return message;
        }
        HarvestDetails memory temp = HarvestDetails(strainH,numberOfPlants,weightM,wetP,wetT,wetF,dryT,dryFlwr,seeds,usable,unusable,Growers[msg.sender].dataIndex);   
        if(Growers[msg.sender].Activated)
        {
         Growers[msg.sender].StoredData[Growers[msg.sender].dataIndex]=temp;
         Growers[msg.sender].dataIndex++;//@Dev increment data count
        }
        else
        {
           Growers[msg.sender]=GrowerObject(msg.sender,0,0,date,true);
           Growers[msg.sender].StoredData[Growers[msg.sender].dataIndex]=temp;
           Growers[msg.sender].dataIndex++;//@Dev increment data count
        }
        emit GrowerInfo(msg.sender, strainH,numberOfPlants,weightM,wetP,wetT,wetF,dryT,dryFlwr,seeds,usable,unusable);
        message="Succesfully stored Grower data";
        emit GeneralLogger(message);
        return message;
    }
    //@Dev get Harvest Details at specified address 
    function GetGrowerDetails() public returns (string strainH,uint256 numberOfPlants,uint256 weightM,uint256 wetP,uint256 wetT,uint256 wetF,uint256 dryT,uint256 dryFlwr,uint256 seeds,uint256 usable)
    {
     if(msg.sender == address(0))
     {
         emit GeneralLogger("Invalid Grower Address");
         return ("Invalid Grower Address",0,0,0,0,0,0,0,0,0);
     }
     if(!Growers[msg.sender].Activated)
     {
       emit GeneralLogger("Grower details not found");
       return ("",0,0,0,0,0,0,0,0,0);
     }
     strainH=Growers[msg.sender].StoredData[Growers[msg.sender].dataAccessIndex].strainHarvest;
     numberOfPlants=Growers[msg.sender].StoredData[Growers[msg.sender].dataAccessIndex].numberOfPlants;
     weightM=Growers[msg.sender].StoredData[Growers[msg.sender].dataAccessIndex].weightMeasurement;
     wetP=Growers[msg.sender].StoredData[Growers[msg.sender].dataAccessIndex].wetPlant;
     wetT=Growers[msg.sender].StoredData[Growers[msg.sender].dataAccessIndex].wetTrim;
     wetF=Growers[msg.sender].StoredData[Growers[msg.sender].dataAccessIndex].wetFlower;
     dryT=Growers[msg.sender].StoredData[Growers[msg.sender].dataAccessIndex].dryTrim;
     dryFlwr=Growers[msg.sender].StoredData[Growers[msg.sender].dataAccessIndex].dryFlower;
     seeds=Growers[msg.sender].StoredData[Growers[msg.sender].dataAccessIndex].seeds;
     usable=Growers[msg.sender].StoredData[Growers[msg.sender].dataAccessIndex].TotalUsable;
     Growers[msg.sender].dataAccessIndex++;
    }
    //@Dev returns Declaration date for a specific Harvest
    function GetGrowerDataDeclarationDate() public returns (string message)
    {
     if(msg.sender == address(0))
     {
         message="Invalid Grower Address";
         emit GeneralLogger(message);
         return message;
     }
     if(!Growers[msg.sender].Activated)
     {
       message="Grower details not found";
       emit GeneralLogger(message);
       return message;
     }
     message="Date Found";
     emit GeneralLogger(message);
     emit DeclarationLogger(Growers[msg.sender].StoredData[Growers[msg.sender].dataAccessIndex].strainHarvest,Growers[msg.sender].Date);
     return message; 
    }
    
    //@Dev resets the dataAccessIndex to 0
    function ResetDataAccessIndex() public returns (string message)
    {
      if(msg.sender == address(0))
      {
          message ="Invalid Address";
          emit GeneralLogger(message);
          return message;
      }    
      if(!Growers[msg.sender].Activated)
      {
          message="Grower not not Active";
          emit GeneralLogger(message);
          return message;
      }
      Growers[msg.sender].dataAccessIndex=0;
      message="Reset data Index to 0 succesfully";
      emit GeneralLogger(message);
      return message;
    }
}

