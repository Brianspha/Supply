pragma solidity 0.4.24;
import "./Ownable.sol";
import "./HelperFunctions.sol";
//@Dev contract responsible for storing raw materials
contract RawMaterial is Ownable ,HelperFunctions
{

    struct RawMaterials
    {
      address owner;
      string nameofMaterial;
      string datePurchased;
      uint256 DataCount;
      uint256 DataAccessIndex;
      bool Activated;//@Dev Indicates whether the RawMaterial is active or not
      mapping(uint256 =>RawMaterialData) Owned;
    }
    //@Dev represents Raw material data
    struct RawMaterialData
    {
       string nameofMaterial;
       string DateBought;
       uint256 index;
    }
    //@Dev stores raw material data
    mapping(address => RawMaterials)  RawMaterialsData;
    
    
    //@Dev constructor
    constructor() public
    {
    }

    //@Dev stores raw materials belonging to a specific farmer
    function storeValue(string name,string datePurchased) public onlyOwner returns (string message) 
    {
        if(msg.sender==address(0))
        {
            message="Invalid Grower address";
            emit GeneralLogger(message);
            return message;
        }
        if(isStringNullorEmpty(name)||isStringNullorEmpty(datePurchased))
        {
            message="Invalid raw material data";
            emit GeneralLogger(message);
            return message;
        }
        if(RawMaterialsData[msg.sender].Activated)
        {
        RawMaterialsData[msg.sender].Owned[RawMaterialsData[msg.sender].DataCount]=RawMaterialData(name,datePurchased,RawMaterialsData[msg.sender].DataCount);
        RawMaterialsData[msg.sender].DataCount++;    
        }
        else
        {
        RawMaterialsData[msg.sender]=RawMaterials(msg.sender,name,datePurchased,0,0,true);    
        RawMaterialsData[msg.sender].Owned[RawMaterialsData[msg.sender].DataCount]=RawMaterialData(name,datePurchased,RawMaterialsData[msg.sender].DataCount);
        RawMaterialsData[msg.sender].DataCount++;    
        }
        message="Successfully stored Raw Materials Data";
        emit GeneralLogger(message);
        return message;
    }
    //@Dev get raw Material
    function GetRawMaterial()  public returns (string name,string datePurchased,bool found )
    {
        if(msg.sender== address(0))
        {
         emit GeneralLogger("Invalid address of owner of raw material");
         return (name,datePurchased,false);
        }
        if(!RawMaterialsData[msg.sender].Activated)
        {
         emit GeneralLogger("No raw materials for owner exist");
         return (name,datePurchased,false);
        }
        if(RawMaterialsData[msg.sender].DataCount==0)
        {
            name=RawMaterialsData[msg.sender].nameofMaterial;
            datePurchased=RawMaterialsData[msg.sender].datePurchased;
            found=true;
            emit GeneralLogger("Found Raw Material Data");
            return (name,datePurchased,found);
        }
        if(RawMaterialsData[msg.sender].DataAccessIndex >RawMaterialsData[msg.sender].DataCount)
        {
            RawMaterialsData[msg.sender].DataAccessIndex=0;
            emit GeneralLogger("No More resources to return");
            return (name,datePurchased,found); 
        }
        name=RawMaterialsData[msg.sender].Owned[RawMaterialsData[msg.sender].DataAccessIndex].nameofMaterial;
        datePurchased=RawMaterialsData[msg.sender].Owned[RawMaterialsData[msg.sender].DataAccessIndex].DateBought;
        found=true;
        emit GeneralLogger("Found Raw Material");
        RawMaterialsData[msg.sender].DataAccessIndex++;
        return (name,datePurchased,found);
     }
     

}
