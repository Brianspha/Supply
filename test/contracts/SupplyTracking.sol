pragma solidity ^0.4.24;

import "./Ownable.sol";
import "./Expertise.sol";
import "./Lab.sol";
import "./RawMaterial.sol";
import "./Lab.sol";
import "./Grower.sol";
import "./HelperFunctions.sol";
import "./SmartContractVersionsLedger.sol";
import "./Farmer.sol";

//@Dev responsible for keeping track of each raw material
contract SupplyTracking is Ownable,HelperFunctions
{
    address  rawMaterialContractAddress;
    uint256  rawMaterialContractVersion;
    
    address  labContractAddress;
    uint256  labContractVersion;
    
    address  expertiseContractAddress;
    uint256  expertiseContractVersion;

    address  growerContractAddress; 
    uint256  growerContractVersion;    
    
    SmartContractVersionsLedger VersionsLedger;
    Lab LabContract;
    RawMaterial RawMaterialContract;
    Expertise ExpertiseContract;
    Grower GrowerContract;
    Farmer FarmerContract;
    event ChangeGrowerContract(address indexed Address, uint256 indexed version);
    event ChangeRawMaterialContract(address indexed Address, uint256 indexed version);
    event ChangeLabContract(address indexed Address, uint256 indexed version);
    event ChangeExpertiseContract(address indexed Address, uint256 indexed version);
    
    //@Dev constructor
    constructor(address versionsLedgerAdress,address labAddress,address expertisAddress,address rawMaterialsAddress,address GrowerAddress,address farmerContractaddress) 
    {
     require(versionsLedgerAdress != address(0));
     require(labAddress != address(0));
     require(rawMaterialsAddress != address(0));
     require(expertisAddress !=address(0));
     require(GrowerAddress != address(0));
     require(farmerContractaddress != address(0));
     FarmerContract=Farmer(farmerContractaddress);
     VersionsLedger=SmartContractVersionsLedger(versionsLedgerAdress);
     GrowerContract=Grower(GrowerAddress);
     LabContract = Lab(labAddress);
     ExpertiseContract=Expertise(expertisAddress);
     RawMaterialContract=RawMaterial(rawMaterialsAddress);
     emit GeneralLogger("Created Ledgers");
    }

    //-------------------------------------------------------------------------------------------
   //@Dev creates a new instance of the grower contract
    function setGrowerContract(address newAddress, uint256 version) public onlyOwner returns (string message) 
    {
        if(newAddress == address(0))
        {
            message="Invalid new address for Grower Contract";
            emit GeneralLogger(message);
            return message;
        }
        if(newAddress == growerContractAddress)
        {
            message="Address of Contract hasnt changed reverting";
            emit GeneralLogger(message);
            return message;
        }
        if(version <0)
        {
          message="Version cannot be less than 0";
          emit GeneralLogger(message);
          return message;
        }
       else if(VersionsLedger.GetContractStatus(growerContractAddress))
        {
         VersionsLedger.UpdateContractVersion(growerContractAddress,newAddress,version);  
        }
        else
        {
          VersionsLedger.CreateNewVersion(newAddress,version);    
            
        }
        growerContractAddress = newAddress;
        growerContractVersion = version;
        emit ChangeGrowerContract(newAddress, version);
        message= "Succesfully updated Grower Contract";
        emit GeneralLogger(message);
        return message;
    }
    //@Dev sets the new address for the grower contract
    function setGrower(string strainH,uint256 numberOfPlants,uint256 weightM,uint256 wetP,uint256 wetT,uint256 wetF,uint256 dryT,uint256 dryFlwr,uint256 seeds,uint256 usable) public onlyOwner returns (string message)
    {
        if(rawMaterialContractAddress ==address(0)|| msg.sender == address(0))
        {
            message ="Invalid RawMaterials Contract Address";
            emit GeneralLogger(message);
            return message;
        }
         //@Dev We dont need to check if the lab address or data is valid because we check for that in the Expertise Contract
        message=GrowerContract.storeValue(strainH,numberOfPlants,weightM,wetP,wetT,wetF,dryT,dryFlwr,seeds,usable);
        return message;
    }
    //@Dev sets the new address for the grower contract
    function GetGrowerDetails() public onlyOwner returns (string strainH,uint256 numberOfPlants,uint256 weightM,uint256 wetP,uint256 wetT,uint256 wetF,uint256 dryT,uint256 dryFlwr,uint256 seeds,uint256 usable)
    {
        if(rawMaterialContractAddress ==address(0)|| msg.sender == address(0))
        {
         emit GeneralLogger("Invalid RawMaterials Contract Address or sender address");
         return ("Invalid Grower Address",0,0,0,0,0,0,0,0,0);
        }
         //@Dev We dont need to check if the lab address or data is valid because we check for that in the Expertise Contract
         return GrowerContract.GetGrowerDetails();
    }

    //-------------------------------------------------------------------------------------------
    //@Dev creates a new instance of the RawMaterials contract and saves the data passed in
    function setRawMaterialContract(address newAddress, uint256 version) public onlyOwner returns (string message) 
    {
        if(newAddress == address(0))
        {
            message="Invalid address for new Raw materials Contract or sender address";
            emit GeneralLogger(message);
            return message;
        }
        if(version <0)
        {
            message="version cannot be less than 0";
            emit GeneralLogger(message);
            return message;
        }
        if(newAddress ==rawMaterialContractAddress)
        {
            message="Raw Materials Address hasnt changed reverting";
            emit GeneralLogger(message);
            return message;
        }
       else if(VersionsLedger.GetContractStatus(rawMaterialContractAddress))
        {
         VersionsLedger.UpdateContractVersion(rawMaterialContractAddress,newAddress,version);  
        }
        else
        {
          VersionsLedger.CreateNewVersion(newAddress,version);    
        } 
        rawMaterialContractAddress = newAddress;
        rawMaterialContractVersion = version;
        emit ChangeRawMaterialContract(newAddress, version);
        message ="Succefully updated RawMaterials Contract";
        emit GeneralLogger(message);
        return message;
    }

    //@Dev sets the new address for the rawMaterials contracts and saves the data passed in
    function setRawMaterial(string nameofMaterial,string dateBought) public onlyOwner returns (string message) 
    {
        if(msg.sender==address(0))
        {
            message="Invalid Grower address";
            emit GeneralLogger(message);
            return message;
        }
        //@Dev We dont need to check if the lab address or data is valid because we check for that in the Expertise Contract
        message=RawMaterialContract.storeValue(nameofMaterial,dateBought);
        return message;
    }
    //@Dev resets data access index to 0
    function ResetDataAccessGrower () returns (string message)
    {
      message= GrowerContract.ResetDataAccessIndex();
      return message;
    }
    //-------------------------------------------------------------------------------------------

    // @Dev creates a new instance of the Lab Contract 
    function setLabContract(address newAddress, uint256 version) public onlyOwner returns (string message) 
    {
        if(newAddress == address(0))
        {
            message="Invalid address for new Lab Contract";
            emit GeneralLogger(message);
            return message;
        }
        if(version <0)
        {
            message="Version cannot be less than 0";
            emit GeneralLogger(message);
            return message;
        }
        if(newAddress == labContractAddress)
        {
            message="Lab Address hasnt changed reverting";
            emit GeneralLogger(message);
            return message;
        }
       else if(VersionsLedger.GetContractStatus(labContractAddress))
        {
         VersionsLedger.UpdateContractVersion(labContractAddress,newAddress,version);  
        }
        else
        {
          VersionsLedger.CreateNewVersion(newAddress,version);    
        }
        labContractAddress = newAddress;
        labContractVersion = version;
        emit ChangeLabContract(newAddress, version);
        message ="Succesfully updated Lab Contract";
        emit GeneralLogger(message);
        return message;
    }

    //@Dev sets the new address for the rawMaterials contract and saves the data passed in
    function setLab(address Address, string name,string location) public onlyOwner returns (string message)
    {
        if(labContractAddress == address(0))
        {
            message="Invalid Lab contract Address";
            emit GeneralLogger(message);
            return message;
        }
        //@Dev We dont need to check if the lab address or data is valid because we check for that in the Expertise Contract
        message=LabContract.storeValue(Address,name,location);
        return message;                      
    }

    //-------------------------------------------------------------------------------------------

   //@Dev creates a new instance of the Expertise contract
    function setExpertisConract(address newAddress, uint256 version) public onlyOwner returns (string message) 
    {

        if(newAddress == address(0))
        {
            message="Invalid address for new Expertise Contract";
            emit GeneralLogger(message);
            return message;
        }
        if(version <0)
        {
            message="Version cannot be negative";
            emit GeneralLogger(message);
            return message;
        }
        if(newAddress == expertiseContractAddress)
        {
            message="Expertise Contract address hasnt changed reverting";
            emit GeneralLogger(message);
            return message;
        }
       else if(VersionsLedger.GetContractStatus(expertiseContractAddress))
        {
         VersionsLedger.UpdateContractVersion(expertiseContractAddress,newAddress,version);  
        }
        else
        {
          VersionsLedger.CreateNewVersion(newAddress,version);    
        }
        expertiseContractAddress = newAddress;
        expertiseContractVersion = version;
        emit ChangeExpertiseContract(newAddress, version);
        message="Succesfully updated Expertise Contract";
        emit GeneralLogger(message); 
        return message;
    }
  //@Dev sets the new address for the Expertise contract as well as saves the passed in data
    function setExpertise(address labAddress, string name,string labaddress,string manufacturer,string harvest,string conclusion) public onlyOwner returns (string message) 
    {
        if(expertiseContractAddress==address(0))
        {
            message="Invalid Expertise Contract Address";
            emit GeneralLogger(message);
            return message;
        }
        //@Dev We dont need to check if the lab address or data is valid because we check for that in the Expertise Contract
        message=ExpertiseContract.storeValue(msg.sender,name,labaddress,manufacturer,harvest,conclusion);
        return message;
    }

}