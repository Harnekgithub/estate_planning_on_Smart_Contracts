// SPDX-License-Identifier: MIT
pragma solidity >=0.5.17;
pragma experimental ABIEncoderV2;
// import "./will.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/math/SafeMath.sol";

// compare two strings
/*library StrLib {
  function compareTwoStrings(string memory string1, string memory string2) public pure returns (bool)
  {
    return keccak256(abi.encodePacked(string1)) == keccak256(abi.encodePacked(string2));
  }
}*/
// Create owner of the will
contract owner {
    // Struct to contain the data of the owner of the will
    struct owner_of_the_will{
        string o_firstName;
        string o_lastName;
        string o_ssn;
        string o_dob;
        address o_wallet_address;
        beneficiary[] beneficiaries;
    }
    // Struct to contain the data of the owner of the Beneficiaries
    struct beneficiary{
        string b_firstName;
        string b_lastName;
        string b_ssn;
        string b_dob;
        uint b_share;
        address b_wallet_address;
    }
    // Create a list of beneficiaries to add to the will 
    beneficiary[] public beneficiariesOfWill;
        //uint numofBefeniciaries;


    // Create the owner struct variable
    owner_of_the_will internal wOwner;
    
    // declare the will owner's address variable as a state variable
    address willOwner;

    // this modifier will make sure that only Owner of the will will have access to the functions
    modifier onlyOwner {
        require(msg.sender == willOwner, "You do not have permission to make changes!");
    _;
    }
    // constructor for the owner contract
    constructor() public{
        willOwner = msg.sender;
    } 
    
    // This function set the values passed to it in the state variables for the owner    
    function setOwnerdata(string memory _firstName, string memory _lastName, string memory _ssn, string memory _dob, address _walletAddress) public 
    {
      //owner_of_the_will owner;
        wOwner.o_firstName = _firstName;
        wOwner.o_lastName = _lastName;
        wOwner.o_ssn = _ssn;
        wOwner.o_dob = _dob;
        wOwner.o_wallet_address = _walletAddress;

    }
    // Get owner data
    function getOwner() public view returns( owner_of_the_will memory )
    {
        return(wOwner);
    }
    // This function set the values passed to it in the state variables for the beneficiarOfWill  
    function setBeneficiarydata(string storage _firstName, string storage _lastName, string storage _ssn, string storage _dob, uint _share, address _walletAddress) 
    internal onlyOwner
    {
        beneficiary memory _beneficiaries;
        _beneficiaries.b_firstName = _firstName;
        _beneficiaries.b_lastName = _lastName;
        _beneficiaries.b_ssn = _ssn;
        _beneficiaries.b_dob = _dob;
        _beneficiaries.b_share = _share;
        _beneficiaries.b_wallet_address = _walletAddress;
        beneficiariesOfWill.push(_beneficiaries);
    }
    // update will owner's wallet address
    function updateOwnersWalletAddress(address _walletAddress) public onlyOwner{
        owner_of_the_will storage newOwner = wOwner;
        newOwner.o_wallet_address = _walletAddress;

    }
    // update will beneficiaries once all the beneficiaries are added to the array
    function setBeneficiaries_in_wil() internal onlyOwner{
        owner_of_the_will storage newOwner = wOwner;
        newOwner.beneficiaries = beneficiariesOfWill;
    }    
    // get all beneficiaries
    function getBeneficiaries(address _owner) external returns(beneficiary[] memory){
        return(beneficiariesOfWill);
    }
    // Update a beneficiary's share
    function updateBeneficiaryShare(string memory _ssn, uint _share) public  onlyOwner returns(bool){
        beneficiary[] storage newBenef = beneficiariesOfWill;
        for (uint i=0; i < newBenef.length; i++)
        {
            if(compareTwoStrings(newBenef[i].b_ssn, _ssn))
            {
                newBenef[i].b_share = _share;
                return true;
            }
        }
        return false;
    }
    
    // Let beneficiary update their wallet address
    function updateBeneficiaryWallet(string memory _ssn, address _walletAddress) public onlyOwner returns(bool) {
        beneficiary[] storage newBenef = beneficiariesOfWill;
        for (uint i=0; i < newBenef.length; i++)
        {
            if(compareTwoStrings(newBenef[i].b_ssn, _ssn))
            {
                newBenef[i].b_wallet_address = _walletAddress;
                return true;
            }
        }
        return false;
    }

    // compares two strings
    function compareTwoStrings(string memory string1, string memory string2) public pure returns (bool)
    {
        return keccak256(abi.encodePacked(string1)) == keccak256(abi.encodePacked(string2));
    }
}
/*contract beneficiary{
    struct beneficiary{
        string b_firstName;
        string b_lastName;
        string b_ssn;
        string b_dob;
        uint b_share;
        address b_wallet_address;
    }
    address willOwner;
    constructor() public{
        willOwner = msg.sender;
    }
    modifier onlyOwner {
        require(msg.sender == willOwner, "You do not have permission to mint these tokens!");
        _;
        }
    // Declare the beneficiary variable as an array to capture multiple beneficiaries
    // beneficiary[] public beneficiaries; 
 
    

    function setBeneficiarydata(string calldata _firstName, string calldata _lastName, string calldata _ssn, string calldata _dob, uint _share, address _walletAddress) 
    external onlyOwner
    {
        beneficiary memory beneficiaries;
        beneficiaries.b_firstName = _firstName;
        beneficiaries.b_lastName = _lastName;
        beneficiaries.b_ssn = _ssn;
        beneficiaries.b_dob = _dob;
        beneficiaries.b_share = _share;
        beneficiaries.b_wallet_address = _walletAddress;
        beneficiariesOfWill.push(beneficiaries);
    }
 
 
}



contract will {
        using SafeMath for uint;
 
        address owner;
        constructor () public { //address, uint
                owner = msg.sender;

        }
        
        modifier onlyOwner {
        require(msg.sender == owner, "You do not have permission to mint these tokens!");
        _;
        }

        mapping (address => uint) public beneficiaryMap;
        mapping ( address => bool) public inserted;
        address[] public keys;

       // this functions gets the share of the estate a beneficiary will receive when the will is executed by an executor 
        function get(address _address) public view returns(uint) {
        //if(msg.sender == _address )
             return(beneficiaryMap[_address]);
        }
        function getSize() external view returns (uint){
            return keys.length;

        }
        // this functions sets the share of the estate a beneficiary will receive when the will is executed by an executor 
       function set(address _keys, uint _share ) internal
        {
            beneficiaryMap[_keys] = _share;
            if(!inserted[_keys])
            {
                inserted[_keys] = true;
                keys.push(_keys);
            }
        }
        // iterate the mapping to get all beneficiaries
        function getall(uint _i) external view onlyOwner returns(uint)
        {
            return(beneficiaryMap[keys[_i]]);
        }
        function remove(address _address) public
        {
            delete beneficiaryMap[_address];
        }
}
*/