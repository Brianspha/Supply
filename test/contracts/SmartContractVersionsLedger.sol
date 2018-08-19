pragma solidity 0.4.24;
import "./HelperFunctions.sol";
//@Dev keeps track of every smart contract used by the Supply Tracking system
contract SmartContractVersionsLedger is HelperFunctions
{

    //@Dev represents every contract thats used by the SupplyTracking system as well as their versions
    mapping(address => ContractVersions) PreviousContracts;
    
    //@Dev constructor
    constructor () public
    {

    }
   //@Dev creates a new version of a contract 
   function CreateNewVersion (address contractAddress,uint256 version) returns (string message)
   {
        PreviousContracts[contractAddress]=ContractVersions(contractAddress,true,0);
        PreviousContracts[contractAddress].PreviousVersions[PreviousContracts[contractAddress].Index]=Contract(contractAddress,version,true);
        PreviousContracts[contractAddress].Index++; 
        message="Created new version for contract";   
        emit GeneralLogger(message);
   }
   //@Dev updates a specfic contracts versions
   function UpdateContractVersion(address oldVersion,address newVersion,uint256 version) returns (string message)
   {
     PreviousContracts[oldVersion].PreviousVersions[PreviousContracts[oldVersion].Index]=Contract(newVersion,version,true);
     PreviousContracts[newVersion].Index++;
     message="Updated contract version";
     emit GeneralLogger(message);  
   }

   //@Dev Gets the status of a contract whether its active or not
   function GetContractStatus(address contractAddress) view returns (bool found)
   {
     require(contractAddress !=address(0));
     found =PreviousContracts[contractAddress].Activated;
     return found;
   }
}